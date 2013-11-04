//////////////////////////////////////////////////////////////////////////////////////////////////
// hipandlegs[OBLOBOTS] 
//
// v.06
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Oct 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <plus/external_elements.scad>
include <plus/presets.scad>

use <plus/functions.scad>
use <plus/union.scad>
use <plus/parts.scad>
use <hip.scad>
use <leg.scad>


//////////////////////////////////////////////////////////////////
///////////// MÓDULO hipandlegs_cylindrical()  ////////////////////

module	hipandlegs_cylindrical ( 	
			hip=[40,15,80],			// [ d,h,f ] Medidas de la cadera donde van las piernas
			pin=[10,15,TABNORMAL],	// [ d, h ] medidas del pin. Existe si PF=NULL. Por defecto
			waist=[0,0,0],			// [d1,d2,h] medidas y forma de la base del pin o del botón. Opcional
			legs=[30,100],			// medida de las piernas: altura (incluye la altura del pie)
			foots=[30,3],				// medida del pie: [ longitud, altura ]	
			PF=NULL,					// Opcional, define el botón aut., si existe se anulan el pin[],
			correction=0,			// corrección para el botón automático
			representation=0			// 0=junto
									// 1=explosión	
									// 2=printing				
			){


pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin

/*
hiph=lim(pinh+2,hip[1],70);
hipf=lim(0,hip[2],100);
hiplim=[hipd,hiph,hipf];

[pind,pinh,pin[2]]

*/

//legsposition=lim(0,legs[1],100);
hipd=lim(25,hip[0],80);
legh=lim(20,legs[0],70);			// medida de la pierna: longitud

if(representation==0){
	color(hip_color)
	translate([0,0,legh])
		hip_union_cylindrical(	hip=hip,
								pin=pin,
								waist=waist,
								legsposition=legs[1],
								PF=PF,
								correction=correction);
	color(legs_color)
	legs_union_cylindrical (	hip=hip,
							legs=legs,
							pin=pin,
							foots=foots,
							PF=PF,
							correction=correction);
	}

	else{
		if(representation==1){
			color(hip_color)
			translate([0,0,legh+pinh+10])
				hip_union_cylindrical(	hip=hip,
										pin=pin,
										waist=waist,
										legsposition=legs[1],
										PF=PF,
										correction=correction);
			color(legs_color)
			translate([0,0,0])
				legs_union_cylindrical (	hip=hip,
										legs=legs,
										pin=pin,
										foots=foots,
										PF=PF,
										correction=correction);
			}
			else{
				color(hip_color)
				hip_union_cylindrical(	hip=hip,
										pin=pin,
										waist=waist,
										legsposition=legs[1],
										PF=PF,
										correction=correction);
				color(legs_color)
				translate([hipd/4,-(hipd+2),0])
					rotate([0,0,90])
					legs_union_cylindrical (	hip=hip,
											legs=legs,
											pin=pin,
											foots=foots,
											PF=PF,
											correction=correction,
											angle=90);
				}
		}
}



//////////////////////////////////////////////////////////////////
///////////// MÓDULO hipandlegs_quadrangle()  ////////////////////

module	hipandlegs_quadrangle ( 	
			hip=[35,20,12,5],			// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
			pin=[10,15,TABNORMAL],				// [ d, h ] medidas del pin. Existe si PF=NULL. Por defecto
			waist=[0,0,0,0],			// [d1,d2,h,n] medidas y forma de la base del pin o del botón. Opcional
			legs=[30,8,100],			// medida de las piernas [ longitud, número de lados]
			foots=[30,3],				// medida del pie: [ longitud, altura ]	
			PF=NULL,					// Opcional, define el botón aut., si existe se anulan el pin[],
			correction=0,			// corrección para el botón automático
			representation=0			// 0=junto
									// 1=explosión	
									// 2=printing				
		){


pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin

hipx=lim(20,hip[0],80);
hipy=lim(15,hip[1],60);
hipz=lim(pinh+2,hip[2],50);
//hiplim=[hipx,hipy,hipz,hip[3]];

legh=lim(20,legs[0],70);			// medida de la pierna: longitud

if(representation==0){
	color(hip_color)
	translate([0,0,legh])
		hip_union_quadrangle(	hip=hip,
							pin=pin,
							waist=waist,
							legsposition=legs[2],
							PF=PF,
							correction=correction);
		color(legs_color)
		legs_union_quadrangle (	hipx=hipx,
								legs=legs,
								pin=pin,
								foots=foots,
								PF=PF,
								correction=correction);
	}

	else{
		if(representation==1){
			color(hip_color)
			translate([0,0,legh+pinh+10])
				hip_union_quadrangle(	hip=hip,
									pin=pin,
									waist=waist,
									legsposition=legs[2],
									PF=PF,
									correction=correction);
			color(legs_color)
			translate([0,0,0])
				legs_union_quadrangle (	hipx=hipx,
										legs=legs,
										pin=pin,
										foots=foots,
										PF=PF,
										correction=correction);
			}
			else{
				color(hip_color)
				hip_union_quadrangle(	hip=hip,
									pin=pin,
									waist=waist,
									legsposition=legs[2],
									PF=PF,
									correction=correction);
				color(legs_color)
				translate([hipx/4,-(hipy/2+hipx/2+5),0])
					rotate([0,0,90])
					legs_union_quadrangle (	hipx=hipx,
											legs=legs,
											pin=pin,
											foots=foots,
											PF=PF,
											correction=correction,
											angle=90);
				}
		}
}


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////


translate([0,100,0])
hipandlegs_quadrangle(	hip=[40,20,12,3],
						pin=[10,15,SIMPLE],	
						waist=[15,10,2,8],
						legs=[35,8,100],
						foots=[32,8],
						PF=NULL,
						correction=0,
						representation=0);

translate([70,100,0])
hipandlegs_quadrangle(	hip=[42,25,17,2],
						pin=[10,15,TABFINE],	
						waist=[15,5,0,0],
						legs=[45,8,100],
						foots=[30,5],
						PF=COS11,
						correction=0.2,
						representation=2);

translate([-70,100,0])
hipandlegs_quadrangle(	hip=[40,22,30,4],
						pin=[10,15,TABFINE],	
						waist=[15,10,5,4],
						legs=[30,4,100],
						foots=[30,5],
						PF=NULL,
						correction=-0.3,
						representation=1);


translate([0,-100,0])
hipandlegs_cylindrical ( 	hip=[42,18,100],
						pin=[8,15,TABNORMAL],	
						waist=[35,35,7],
						legs=[35,100],
						foots=[40,5],
						PF=NULL,
						correction=0.1,
						representation=0);	

translate([-70,-100,0])
hipandlegs_cylindrical ( 	hip=[40,25,95],
						pin=[10,15,SIMPLE],	
						waist=[25,25,2],
						legs=[25,100],
						foots=[38,5],
						PF=NULL,
						correction=0.1,
						representation=1);

translate([70,-100,0])
hipandlegs_cylindrical ( 	hip=[40,15,50],
						pin=[12,15,SIMPLE],	
						waist=[15,12,4],
						legs=[50,95],
						foots=[30,5],
						PF=COS11,
						correction=0,
						representation=2);				
						

