//////////////////////////////////////////////////////////////////////////////////////////////////
// Leg gap[OBLOBOTS] 
// joint gap
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) 2014-04 v.10
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <../../../utilities/external_elements_oblobots.scad>
include <../../../utilities/presets_oblobots.scad>
include <../../../utilities/limits_oblobots.scad>

use <../../../utilities/functions_oblomobka.scad>
use <../../../utilities/shapes_oblomobka.scad>

use <../../../OBLOBOTS preforms/leg.scad>

use <../../../joints/gap_oblobots.scad>

use <hip_gap.scad>


//////////////////////////////////////////////////////////////////
/////////////////// MÓDULO legs_union_cylindrical()  //////////////

module legs_union_cylindrical (	
		hip=[40,15,80],				// [ d,h,f ] Medidas de la cadera donde van las piernas
		leg=[12,30,100],				// [d, h , posicion] 
		pin=DOWEL_6,					// [ d, h ] medidas del pin. 
		foot=[30,3],					// medida del pie: longitud, altura
		play=0,						
		angle=45,					//angulo de los pies
		resolution=16
		){

$fn=50;

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);					// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);					// longitud del pin

d_leg=lim(d_leg_minmax[0],leg[0],d_leg_minmax[1]);					// medida de la pierna: diametro
h_leg=lim(h_leg_minmax[0],leg[1],h_leg_minmax[1]);					// medida de la pierna: longitud
legsposition=lim(legsposition_minmax[0],leg[2],legsposition_minmax[1]);

d_hip=lim(d_hip_minmax[0],hip[0],d_hip_minmax[1]);
h_hip=lim(h_pin+2,hip[1],h_hip_minmax[1]);
f_hip=lim(f_hip_minmax[0],hip[2],f_hip_minmax[1]);

// variables condicionadas a los valores de entrada
h_real_pin=5;		//ant: h_real_pin=h_pin+1;
h_i_leg=h_leg-h_real_pin;

h1_hip=h_hip-f_hip*h_hip/110;
h2_hip=h_hip-h1_hip;

d1_hip=max(3*d_hip/4,(d_hip-2*h1_hip));  // diámetro inferior de la cadera

// Volumen
legs_position(s=d1_hip, pos=legsposition)	// módulo definido en <hip.scad>
rotate([0,0,-angle])
difference(){
	union(){
		rotate([0,0,90])leg_cylindrical(leg=[d_leg,h_i_leg],foot=foot);
		translate([0,0,h_i_leg])cylinder(r=(d_leg)/2,h=h_real_pin);
	}
	translate([0,0,h_leg])rotate([180,0,0])
		gap(gap=pin,deep=pin[1]-10,play=play);
	}
}

// -------------- Fin del módulo legs_union_cylindrical() ------------------
// ------------------------------------------------------------------------


//////////////////////////////////////////////////////////////////
/////////////////// MÓDULO legs_union_quadrangle()  //////////////

module legs_union_quadrangle (	
		x_hip=40,						// medida de la cadera: ancho	
		leg=[12,40,7,100],				// medida de las piernas [ longitud, número de lados]
		pin=DOWEL_6,					
		foot=[32,6],				// medida del pie: longitud
		play=0,						
		angle=45,					//angulo de los pies
		resolution=16
		){

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);				// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);				// longitud del pin

x1_hip=lim(x_hip_minmax[0],x_hip,x_hip_minmax[1]);

d_leg=lim(d_leg_minmax[0],leg[0],d_leg_minmax[1]);
h_leg=lim(h_leg_minmax[0],leg[1],h_leg_minmax[1]);					// medida de la pierna: longitud
n_leg=lim(n_leg_minmax[0],leg[2],n_leg_minmax[1]);					// lim:(4<-->16) nº de lados de las piernas
legsposition=lim(legsposition_minmax[0],leg[3],legsposition_minmax[1]);

// variables condicionadas a los valores de entrada
h_real_pin=5;
h_i_leg=h_leg-h_real_pin;



// Volumen
legs_position(s=x1_hip, pos=legsposition)	// módulo definido en <hip.scad>
rotate([0,0,-angle])
difference(){
	union(){
		rotate([0,0,90])leg_quadrangle(leg=[d_leg,h_i_leg,n_leg],foot=foot);
		translate([0,0,h_i_leg])if(n_leg%2==0){
			prism_circumscribed(d=d_leg,h=h_real_pin,n=n_leg);
			}
			else{
				rotate([0,0,180/n_leg])prism_circumscribed(d=d_leg,h=h_real_pin,n=n_leg);
				}
	}
	translate([0,0,h_leg])rotate([180,0,0])
		gap(gap=pin,deep=pin[1]-10,play=play);
}

}

// -------------- Fin del módulo legs_union_quadrangle() ------------------------
// ------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

// Preformas cilindricas

translate([145,0,0])
	legs_union_cylindrical(	hip=[50,15,100],
							leg=[12,45,100],
							foot=[32,4],
							pin=DOWEL_6,
							play=0,
							angle=30,
							resolution=16);


translate([85,0,0])
	legs_union_cylindrical(	hip=[50,15,100],
							leg=[16,30,100],
							foot=[35,10],
							pin=DOWEL_6,
							play=0,
							angle=25,
							resolution=16);

translate([20,0,0])
	rotate([0,0,90])
		leg_cylindrical(leg=[15,70],foot=[50,8]);


// Preformas rectangulares
translate([-245,0,0])
	legs_union_quadrangle(	x_hip=50,
							leg=[12,35,7,70],
							pin=DOWEL_6,
							foot=[40,6],
							play=0,	
							angle=0,
							resolution=16);

translate([-165,0,0])
	legs_union_quadrangle(	x_hip=55,
							leg=[15,60,5,100],
							pin=DOWEL_8,
							foot=[35,6],
							play=0,	
							angle=65,
							resolution=16);

translate([-85,0,0])
	legs_union_quadrangle(	x_hip=50,
							leg=[13,40,4,100],
							pin=DOWEL_6,
							foot=[45,6],
							play=0,	
							angle=45,
							resolution=16);

translate([-20,0,0])
	rotate([0,0,90])
		leg_quadrangle(leg=[15,55,4],foot=[45,9]);

