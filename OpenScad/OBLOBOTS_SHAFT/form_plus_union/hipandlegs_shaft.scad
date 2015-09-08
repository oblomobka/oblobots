// Hip and legs shaft [OBLOBOTS] v.12
// form + union
// (c) Jorge Medal (@oblomobka) 2015.09
// GPL license

include <../../2_helpers/external_elements.scad>
include <../../2_helpers/presets_oblobots.scad>
include <../../2_helpers/limits_oblobots.scad>

use <../../1_unions/shaft.scad>

use <oblomobka/functions.scad>
use <oblomobka/shapes.scad>
use <oblomobka/solids.scad>

use <hip_shaft.scad>
use <leg_shaft.scad>

// Módulos
module	hipandlegs_cylindrical_shaft ( 	
			hip=[40,15,80],			// [ d,h,f ] Medidas de la cadera donde van las piernas
			pin=[6,30],				// 
			waist=[0,0,0],			// [d1,d2,h] medidas y forma de la base del pin o del botón. Opcional
			leg=[12,30,100],			// medida de las piernas: [d,h,posicion]
			foot=[30,3],				// medida del pie: [ longitud, altura ]	
			play=0,
			resolution=24,
			representation=0			// 0=junto
                                        // 1=explosión	
                                        // 2=printing				
			){


d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);			
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);

legsposition=lim(legsposition_minmax[0],leg[2],legsposition_minmax[1]);

d_hip=lim(d_hip_minmax[0],hip[0],d_hip_minmax[1]);
d_leg=lim(d_leg_minmax[0],leg[0],d_leg_minmax[1]);			// medida de la pierna: diametro
h_leg=lim(h_leg_minmax[0],leg[1],h_leg_minmax[1]);			// medida de la pierna: longitud

if(representation==0){
	color(hip_color)
	translate([0,0,h_leg])
		hip_cylindrical_shaft(	hip=hip,
								pin=pin,
								waist=waist,
								legsposition=legsposition,
								play=play,
								resolution=resolution);
	color(legs_color)
	legs_cylindrical_shaft(	hip=hip,
							leg=leg,
							foot=foot,
							pin=pin,
							play=play,
							resolution=resolution);
	}

	else{
		if(representation==1){
			color(hip_color)
			translate([0,0,h_leg+h_pin+10])
				hip_cylindrical_shaft(	hip=hip,
										pin=pin,
										waist=waist,
										legsposition=legsposition,
										play=play,
										resolution=resolution);
			color(legs_color)
			translate([0,0,0])
				legs_cylindrical_shaft(	hip=hip,
										leg=leg,
										foot=foot,
										pin=pin,
										play=play,
										resolution=resolution);
			}
			else{
				color(hip_color)
				hip_cylindrical_shaft(	hip=hip,
										pin=pin,
										waist=waist,
										legsposition=legsposition,
										play=play,
										resolution=resolution);
				color(legs_color)
				translate([d_hip/4,-(d_hip+2),0])
					rotate([0,0,90])
					legs_cylindrical_shaft(	hip=hip,
											leg=leg,
											foot=foot,
											pin=pin,
											play=play,
											resolution=resolution,
											angle=0);
				}
		}
}

module	hipandlegs_quadrangle_shaft ( 	
			hip=[35,20,12,5],			// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
			pin=DOWEL_6,				// 
			waist=[0,0,0,0],			// [d1,d2,h,n] medidas y forma de la base del pin o del botón. Opcional
			leg=[30,8,100],			// medida de las piernas [d, longitud, número de lados,posicion]
			foot=[30,3],				// medida del pie: [ longitud, altura ]	
			play=0,
			resolution=16,
			representation=0			// 0=junto
									// 1=explosión	
									// 2=printing				
		){

d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);			
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);

x_hip=lim(x_hip_minmax[0],hip[0],x_hip_minmax[1]);
y_hip=lim(y_hip_minmax[0],hip[1],y_hip_minmax[1]);
z_hip=lim(z_hip_minmax[0],hip[2],z_hip_minmax[1]);

legsposition=lim(legsposition_minmax[0],leg[3],legsposition_minmax[1]);

d_leg=lim(d_leg_minmax[0],leg[0],d_leg_minmax[1]);			// medida de la pierna: diametro
h_leg=lim(h_leg_minmax[0],leg[1],h_leg_minmax[1]);	// medida de la pierna: longitud

if(representation==0){
	color(hip_color)
	translate([0,0,h_leg])
		hip_quadrangle_shaft(	hip=	hip,	
							pin=pin,
							waist=waist,
							legsposition=legsposition,	
							play=play,
							resolution=resolution);

		color(legs_color)
			legs_quadrangle_shaft(	x_hip=x_hip,
									leg=leg,
									pin=pin,
									foot=foot,
									play=play,		
									resolution=resolution);
	}

	else{
		if(representation==1){
			color(hip_color)
			translate([0,0,h_leg+h_pin+10])
				hip_quadrangle_shaft(	hip=	hip,	
									pin=pin,
									waist=waist,
									legsposition=legsposition,	
									play=play,
									resolution=resolution);
			color(legs_color)
			translate([0,0,0])
				legs_quadrangle_shaft(	x_hip=x_hip,
										leg=leg,
										pin=pin,
										foot=foot,
										play=play,
										resolution=resolution);
			}
			else{
				color(hip_color)
					hip_quadrangle_shaft(	hip=	hip,	
										pin=pin,
										waist=waist,
										legsposition=legsposition,	
										play=play,
										resolution=resolution);
				color(legs_color)
				translate([x_hip/4,-(y_hip/2+x_hip/2+5),0])
					rotate([0,0,90])
						legs_quadrangle_shaft(	x_hip=x_hip,
												leg=leg,
												pin=pin,
												foot=foot,
												play=play,
												resolution=resolution,
												angle=0);
				}
		}
}


// Ejemplos


translate([0,100,0])
hipandlegs_quadrangle_shaft ( 	hip=[50,30,12,5],	
                                pin=DOWEL_6,
                                waist=[25,20,1,8],
                                leg=[12,45,6,90],
                                foot=[30,3],	
                                play=0,
                                resolution=8,
                                representation=0);

translate([70,100,0])
hipandlegs_quadrangle_shaft ( 	hip=[50,30,12,5],	
                                pin=DOWEL_6,
                                waist=[25,20,1,8],
                                leg=[12,45,6,90],
                                foot=[30,3],	
                                play=0,
                                resolution=8,
                                representation=1);

translate([-70,100,0])
hipandlegs_quadrangle_shaft ( 	hip=[50,30,12,5],	
                                pin=DOWEL_6,
                                waist=[25,20,1,8],
                                leg=[12,45,6,90],
                                foot=[30,3],	
                                play=0,
                                resolution=8,
                                representation=2);


translate([0,-100,0])
hipandlegs_cylindrical_shaft ( 	hip=[50,15,50],			
                                pin=DOWEL_6,			
                                waist=[25,20,2],			
                                leg=[12,30,100],			
                                foot=[30,3],					
                                play=0,
                                resolution=10,
                                representation=2			
                                );				

translate([-70,-100,0])
hipandlegs_cylindrical_shaft ( 	hip=[50,15,50],			
                                pin=DOWEL_6,				
                                waist=[25,20,2],			
                                leg=[12,30,100],			
                                foot=[30,3],					
                                play=0,
                                resolution=10,
                                representation=1			
                                );				

translate([70,-100,0])
hipandlegs_cylindrical_shaft ( 	hip=[50,15,50],			
                                pin=DOWEL_6,			
                                waist=[25,20,2],			
                                leg=[12,30,100],			
                                foot=[30,3],					
                                play=0,
                                resolution=10,
                                representation=2			
                                );				
						

