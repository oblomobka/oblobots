// Hip shaft [OBLOBOTS] v.12
// form + union
// (c) Jorge Medal (@oblomobka) 2015.09
// GPL license


include <../../2_helpers/external_elements.scad>
include <../../2_helpers/presets_oblobots.scad>
include <../../2_helpers/limits_oblobots.scad>

use <../../0_forms/hip.scad>
use <../../1_unions/shaft.scad>

use <oblomobka/functions.scad>
use <oblomobka/shapes.scad>
use <oblomobka/solids.scad>

// Módulo
// Colocación relativa de 2 piernas en línea

module legs_position(	s,		// Normalmente el ancho de la cadera
						pos		// [0:100] factor de separación entre piernas
						){

pose=lim(3,pos,100)*(s/3.5)/100;				// factor de separación entre piernas

for(i=[0,1]){
	mirror([i,0,0])
		translate([pose,0,0])
			children(0);
	}
}

module hip_cylindrical_shaft (
		hip=[45,22,80],				// [ d,h,f ] Medida de la cadera
		pin=[8,40],	// 
		waist=[0,0,0],				// [d1,d2,h] medidas y forma de la base del pin o del botón. Opcional
		legsposition=100,				// [0:100] factor que posiciona las piernas en la cadera
		play=0,
		resolution=50
		){

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);					// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);					// longitud del pin

d_hip=lim(d_hip_minmax[0],hip[0],d_hip_minmax[1]);
h_hip=lim(10,hip[1],h_hip_minmax[1]);		//h_hip=lim(2*(h_pin+2),hip[1],h_hip_minmax[1]);
f_hip=lim(f_hip_minmax[0],hip[2],f_hip_minmax[1]);

d1_waist=lim(d_pin,waist[0],d_hip);
d2_waist=lim(d_pin,waist[1],d1_waist);
h_waist=lim(h_waist_minmax[0],waist[2],h_waist_minmax[1]);

// variables condicionadas a los valores de entrada
h1_hip=h_hip-f_hip*h_hip/110;
h2_hip=h_hip-h1_hip;

d1_hip=max(3*d_hip/4,(d_hip-2*h1_hip));  // diámetro inferior de la cadera

$fn=50;

// Volumen
color(hip_color)
difference(){
	union(){
		hip_cylindrical(hip=[d_hip,h_hip,f_hip]);
		translate([0,0,h_hip])cylinder(r1=d1_waist/2,r2=(d2_waist+2)/2,h=h_waist);
		}
        
	// Union - Huecos hexagonales para introducir una espiga
	for(i=[1,0]){
	translate([0,0,(h_hip+h_waist)*i])rotate([180*i,0,0])
		shaft (shaft=pin,play=play);
	}
	legs_position(s=d1_hip, pos=legsposition)
		shaft (shaft=pin,play=play);
	}
		
}

module hip_quadrangle_shaft (	
		hip=[35,20,25,5],				// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
		pin=DOWEL_8,				// [ d, h ] medidas del pin
		waist=[0,0,0,0],				// [d1,d2,h,n] medidas y forma de la base del pin o del botón. Opcional
		legsposition=100,				// [0:100] factor que posiciona las piernas en la cadera
		play=0,
		resolution=50
		){

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);					// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);					// longitud del pin

x_hip=lim(x_hip_minmax[0],hip[0],x_hip_minmax[1]);				// medida de la cadera: ancho
y_hip=lim(d_pin+5,hip[1],y_hip_minmax[1]);						// medida de la cadera: fondo	
z_hip=lim(10,hip[2],h_hip_minmax[1]);			//z_hip=lim(2*(h_pin+2),hip[2],z_hip_minmax[1]); medida de la cadera: alto
bevel_hip=lim(bevel_hip_minmax[0],hip[3],bevel_hip_minmax[1]);	// medida de la cadera: chaflán

d1_waist=lim(d_pin,waist[0],min(x_hip,y_hip));
d2_waist=lim(d_pin,waist[1],d1_waist);
h_waist=lim(h_waist_minmax[0],waist[2],h_waist_minmax[1]);
n_waist=lim(n_waist_minmax[0],waist[3],n_waist_minmax[1]);

$fn=50;
			
// Volumen
color(hip_color)
difference(){
	union(){
		hip_quadrangle(hip=[x_hip,y_hip,z_hip,bevel_hip]);
		translate([0,0,z_hip])pyramid_circumscribed(d1=d1_waist,d2=d2_waist,h=h_waist,n=n_waist);	
	}
	// Huecos hexagonales para introducir una espiga
	for(i=[1,0]){
	translate([0,0,i*(z_hip+h_waist)])rotate([i*180,0,0])
		shaft (shaft=pin,play=play);
	}
	legs_position(s=x_hip, pos=legsposition)
		shaft (shaft=pin,play=play);
		}	
}


// Ejemplos

// Preformas cilindricas
translate([175,0,0])
	hip_cylindrical_shaft(	hip=[40,16,50],
							pin=DOWEL_6,
							waist=[25,0,1],
							legsposition=100,
							play=0,
							resolution=16);


translate([100,80,0])
	hip_cylindrical_shaft(	hip=[55,18,5],
							pin=DOWEL_6,
							waist=[100,0,1],
							legsposition=100,
							play=0,
							resolution=16);


translate([100,0,0])
	hip_cylindrical_shaft(	hip=[55,20,50],
							pin=DOWEL_8,
							waist=[20,2,1],
							legsposition=100,
							play=0,
							resolution=16);

translate([35,0,0])
	hip_cylindrical(hip=[52,15,50]);


// Preformas rectangulares
translate([-175,80,0])
	hip_quadrangle_shaft(	hip=[45,24,15,5],	
                            pin=DOWEL_8,
                            waist=[50,40,1,4],
                            legsposition=100,	
                            play=0,
                            resolution=16);

translate([-175,0,0])
	hip_quadrangle_shaft(	hip=[45,24,15,5],	
                            pin=DOWEL_6,
                            waist=[50,12,1,8],
                            legsposition=100,	
                            play=0,
                            resolution=16);

translate([-100,0,0])
	hip_quadrangle_shaft(	hip=[40,12,22,5],	
                            pin=DOWEL_6,
                            waist=[22,12,1,8],
                            legsposition=100,	
                            play=0,
                            resolution=16);

translate([-35,0,0])
	hip_quadrangle(hip=[50,40,15,20]);

