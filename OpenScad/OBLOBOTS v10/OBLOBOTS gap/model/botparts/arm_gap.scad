///////////////////////////////////////////////////////////////////////////////////////////////
// arm gap[OBLOBOTS] 
// joint_gap
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) 2014-04 - v.10
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <../../../utilities/external_elements_oblobots.scad>
include <../../../utilities/presets_oblobots.scad>
include <../../../utilities/limits_oblobots.scad>

use <../../../utilities/functions_oblomobka.scad>
use <../../../utilities/shapes_oblomobka.scad>

use <../../../OBLOBOTS preforms/arm.scad>

use <../../../joints/gap_oblobots.scad>


//////////////////////////////////////////////////////////////////
///////////// MODULO arm_union_cylindrical()  ////////////////////

module arm_union_cylindrical (	arm=[18,10,1,65],					// [d,h,armpit,l]
								hand=[22,8,120],					// [d,h,ang]
								pin=DOWEL_6,						//  
								play=0,
								resolution=50
								){

d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);			// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);			// longitud del pin

d_arm=lim(d_pin+1,arm[0],d_arm_minmax[1]);					// medida del brazo: fondo	
h_arm=lim(h_arm_minmax[0],arm[1],h_arm_minmax[1]);			// medida del brazo: ancho
armpit=lim(armpit_minmax[0],arm[2],armpit_minmax[1]);		// medida de la axila

d_hand=lim(d_hand_minmax[0],hand[0],d_hand_minmax[1]);

l_arm=lim(d_arm+d_hand,arm[3],l_arm_minmax[1]);				// medida del brazo: longitud

difference(){
	union(){
		arm_cylindrical(arm=[d_arm,h_arm,l_arm],hand=hand);
		translate([0,0,h_arm])cylinder(r1=d_arm/2,r2=(d_pin+2)/2,h=armpit);
		}
	// Huecos hexagonales para introducir una espiga
	gap(gap=pin,deep=pin[1],play=play);
	translate([0,0,h_arm+armpit])rotate([180,0,0])
		gap(gap=pin,deep=pin[1],play=play);
	}
}

// -------------- Fin del módulo arm_union_cylindrical () -----------------
// ------------------------------------------------------------------------


//////////////////////////////////////////////////////////////////
///////////// MODULO arm_union_quadrangle()  ////////////////////

module arm_union_quadrangle (	arm=[18,10,2,65],			// [grosor(x),fondo(y),armpit,longitud(z)] Medidas de los Brazo
							hand=[22,8,8],			// [d,h,n lados]
							pin=DOWEL_6,				
							play=0,
							resolution=50
							){

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);		// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);		// longitud del pin

x_arm=lim(x_arm_minmax[0],arm[1],x_arm_minmax[1]);				// medida del brazo: grosor
y_arm=lim(d_pin+1,arm[0],y_arm_minmax[1]);						// medida del brazo: fondo
armpit=lim(armpit_minmax[0],arm[2],armpit_minmax[1]);	// medida de la axila

d_hand=lim(d_hand_minmax[0],hand[0],d_hand_minmax[1]);
h_hand=lim(h_hand_minmax[0],hand[1],x_arm-0.5);
n_hand=lim(n_hand_minmax[0],2*floor(hand[2]/2),n_hand_minmax[1]);	// [4,6,8,10,12] nº de lados del polígono de la mano

z_arm=lim(y_arm+5+d_hand,arm[3],z_arm_minmax[1]);	// medida del brazo: longitud

// Volumen
difference(){
	union(){
		arm_quadrangle(arm=[y_arm,x_arm,z_arm],hand=hand);
		translate([0,0,x_arm])
			pyramid_circumscribed (d1=y_arm,d2=d_pin+1,h=armpit,n=4);
		}
	// Huecos hexagonales para introducir una espiga
	gap(gap=pin,deep=pin[1],play=play);
	translate([0,0,x_arm+armpit])rotate([180,0,0])
		gap(gap=pin,deep=pin[1],play=play);
	}
}


// -------------- Fin del módulo arm_union_quadrangle () -----------------
// ------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////


i=20;

translate([0,-i,0])
	arm_cylindrical(	arm=[15,8,50],hand=[15,4,45]);

translate([0,-3*i,0])
	arm_union_cylindrical (	arm=[18,5,1,55],
							hand=[16,4,75],
							pin=DOWEL_6,				
							play=0,
							resolution=16);
translate([0,-5*i,0])
	arm_union_cylindrical (	arm=[25,10,1,65],
							hand=[22,8,75],
							pin=DOWEL_6,				
							play=0,
							resolution=16);

translate([0,-7*i,0])
	arm_union_cylindrical (	arm=[18,6,2,50],
							hand=[14,4,100],
							pin=DOWEL_6,				
							play=0,
							resolution=0);

translate([0,i,0])
	arm_quadrangle(arm=[18,9,70],hand=[22,10,8]);

translate([0,3*i,0])
	arm_union_quadrangle (	arm=[15,8,3,60],
							hand=[20,6,8],
							pin=DOWEL_6,	
							play=0,
							resolution=16);

translate([0,5*i,0])
	arm_union_quadrangle (	arm=[16,5,3,50],
							hand=[16,4,6],
							pin=DOWEL_6,	
							play=0,
							resolution=16);

