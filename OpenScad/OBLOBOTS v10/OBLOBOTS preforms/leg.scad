//////////////////////////////////////////////////////////////////////////////////////////////////
// Leg[OBLOBOTS] 
// preform
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) 2014-04 v.10
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <../utilities/external_elements_oblobots.scad>
include <../utilities/presets_oblobots.scad>
include <../utilities/limits_oblobots.scad>

use <../utilities/functions_oblomobka.scad>
use <../utilities/shapes_oblomobka.scad>

use <hip.scad>


/////////////////////////////////////////////////////////////////
/////////////////// MÓDULO leg_cylindrical()  ///////////////////

module leg_cylindrical (	leg=[12,45],		// [d,h] Medidas de la pierna (la altura incluye el pie)
						foot=[40,5]		// [long,h] Medidas del pie
						){
$fn=50;

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
d_leg=lim(d_leg_minmax[0],leg[0],d_leg_minmax[1]);			// medida de la pierna: diámetro
h_leg=lim(h_leg_minmax[0],leg[1],h_leg_minmax[1]);			// medida de la pierna: longitud

l_foot=lim(l_foot_minmax[0],foot[0],l_foot_minmax[1]);		// medida del pie: longitud	
h_foot=lim(h_foot_minmax[0],foot[1],h_foot_minmax[1]);		// medida del pie: altura (sin contar la altura de la base (heel))

// variables condicionadas a los valores de entrada
//legdtop=legd+1;					// medida de la pierna: grosor superior 
ankle=max(d_leg-5,7);				// medida de la pierna: grosor inferior

d_foot=ankle+6;				// medida del pie: ancho en el talón
d_pointfoot=d_foot*0.7;				// medida del pie: ancho en la punta

l_i_foot=l_foot-(d_pointfoot+d_foot)/2;

heel=3;							// talón, altura de la base

h_i_leg=h_leg-h_foot-heel;

// Volumen
rotate([0,0,90])
	union(){
		translate([0,0,heel+h_foot])
			// Canilla
			cylinder (r2=d_leg/2,r1=ankle/2,h=h_i_leg);
				// Pie				
				difference(){
					hull(){
						cylinder (r=d_foot/2,h=heel);
						translate([0,-l_i_foot,0])
							cylinder (r=d_pointfoot/2,h=2);
						translate([0,0,heel])
							cylinder(r=ankle/2,h=h_foot);
						}

					hull(){
						cylinder (r=(d_foot-4)/2,h=2,center=true);
						translate([0,-l_i_foot,0])
							cylinder (r=(d_pointfoot-4)/2,h=2,center=true);
						}
					}
		}
}
// -------------- Fin del módulo leg_cylindrical() ------------------------
// ------------------------------------------------------------------------


//////////////////////////////////////////////////////////////////
///////////// MÓDULO leg_quadrangle ();  ////////////////////

module leg_quadrangle (	leg=[10,15,8], 		// [ d, h, num de lados ] Medidas de la pierna (incluye el pie)
						foot	=[35,4]			// [ long, h ] Medidas dele pie
						){

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
d_leg=lim(d_leg_minmax[0],leg[0],d_leg_minmax[1]);		// medida de la pierna: diámetro
h_leg=lim(h_leg_minmax[0],leg[1],h_leg_minmax[1]);		// medida de la pierna: longitud
n_leg=lim(n_leg_minmax[0],leg[2],n_leg_minmax[1]);		// lim:(4<-->16) nº de lados de las piernas

l_foot=lim(l_foot_minmax[0],foot[0],l_foot_minmax[1]);	// medida del pie: longitud	
h_foot=lim(h_foot_minmax[0],foot[1],h_foot_minmax[1]);	// medida del pie: altura (sin contar la altura de la base (heel))

// variables condicionadas a los valores de entrada
//legdtop=legd+1;					// medida de la pierna: grosor superior 
ankle=max(d_leg-5,7);					// medida de la pierna: grosor inferior

w_foot=ankle+5;					// medida del pie: ancho en el talón
w_pointfoot=w_foot*0.7;				// medida del pie: ancho en la punta

l_i_foot=l_foot-(w_pointfoot+w_foot)/2;

heel=3;

h_i_leg=h_leg-h_foot-heel;

// Volumen
rotate([0,0,90])
	union(){
		// Canilla
		translate([0,0,heel+h_foot])
			pyramid_circumscribed (n=n_leg,d2=d_leg,d1=ankle,h=h_i_leg);	
				// Pie			
				difference(){
					hull(){
						translate([0,0,heel/2])
							cube([w_foot,w_foot,heel],center=true);
						translate([0,-l_i_foot,1])
							cube([w_pointfoot,w_pointfoot,2],center=true);
						translate([0,0,heel])
							prism_circumscribed(d=ankle,h=h_foot,n=n_leg);
						}
						hull(){
							cube([w_foot-4,w_foot-4,1.5],center=true);
							translate([0,-l_i_foot,0])								
								cube([w_pointfoot-4,w_pointfoot-4,1.5],center=true);
							}
						}
		}
}

// ------ Fin del módulo leg_quadrangle(leg=[d,h,n],foot=[l,h]) --------
// ----------------------------------------------------------------------




/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////



translate([20,0,0])
	rotate([0,0,90])
		leg_cylindrical(leg=[20,70],foot=[50,8]);

translate([-20,0,0])
	rotate([0,0,90])
		leg_quadrangle(leg=[25,55,4],foot=[45,9]);

