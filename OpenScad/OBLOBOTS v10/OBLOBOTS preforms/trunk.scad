//////////////////////////////////////////////////////////////////////////////////////////////
// Trunk[OBLOBOTS] 
// preform
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) 2014-04 - v.10
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <../utilities/external_elements_oblobots.scad>
include <../utilities/presets_oblobots.scad>
include <../utilities/limits_oblobots.scad>

use <../utilities/functions_oblomobka.scad>
use <../utilities/shapes_oblomobka.scad>

use <badges.scad>

//////////////////////////////////////////////////////////////////
/////////////////// MODULO trunk_cylindrical ()  /////////////////

module trunk_cylindrical(	trunk=[40,30,32],
						shoulder=[15,3,0.5]
						){

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
d1_trunk=lim(d1_trunk_minmax[0],trunk[0],d2_trunk_minmax[1]);		// medida del cuerpo: diametro base 
d2_trunk=lim(d2_trunk_minmax[0],trunk[1],d1_trunk); 				// medida del cuerpo: diametro punta 
h_trunk=lim(h_trunk_minmax[0],trunk[2],h_trunk_minmax[1]);			// medida del cuerpo: altura 

angle_trunk=atan2(h_trunk,(d1_trunk-d2_trunk)/2);				// ángulo de la pared del cono-cilindro

d1_shoulder=lim(d1_shoulder_minmax[0],shoulder[0],h_trunk*sin(angle_trunk));		// diámetro del hombro ||  limitado [10:th/2]
d_aux_shoulder=lim(d_aux_shoulder_minmax[0],shoulder[1],d_aux_shoulder_minmax[1]);	// diámetro del hombro intersección cono
h_shoulder=lim(h_shoulder_minmax[0],shoulder[2],d2_trunk/2);

// variables condicionadas a los valores de entrada
d2_shoulder=d1_shoulder+d_aux_shoulder;
d2_v_shoulder=d2_shoulder*sin(angle_trunk);

h_shoulder_trunk=h_trunk-d2_v_shoulder/2;
d_shoulder_trunk=di_cone(d1_trunk,d2_trunk,h_trunk,h_shoulder_trunk);	// diámetro intermedio del cono

h_i_shoulder=d2_trunk/2-(sqrt(pow(d2_trunk/2,2)-pow(d2_shoulder/2,2)));
h_aux_shoulder=h_shoulder+h_i_shoulder;

$fn=50;

// Volumen
union(){
	cylinder(r1=d1_trunk/2,r2=d2_trunk/2,h=h_trunk);

	// hombros
	difference(){
		for(i=[0,1]){
			mirror([i,0,0])
				translate([d_shoulder_trunk/2-h_i_shoulder,0,h_shoulder_trunk])
					shoulder (d1=d1_shoulder,h=h_aux_shoulder,d2=d2_shoulder);	
			}
		translate([0,0,-hi_cone(100,0,50*tan(angle_trunk),d1_trunk-3)])
			cylinder(r1=50,r2=0,h=50*tan(angle_trunk));
		}
	}

// Modulos auxiliares
module shoulder(d1,d2,h){
d3=d1/5;
slope=h_trunk*sin(angle_trunk);
armpit=9*slope/10-d2_v_shoulder/2;

rotate([0,angle_trunk,0])rotate([0,0,180])translate([0,0,0])
	hull(){
		translate([0,0,-0.1])
			hull(){
				cylinder(r=d2/2,h=0.1);
				translate ([-armpit,0,0])cylinder(r=d3/2,h=0.1);
				}				
		translate ([(d2-d1)/2-h*cos(angle_trunk),0,h*sin(angle_trunk)-0.1])											
			cylinder(r=d1/2,h=0.1);
		}	
}
// Fin de los módulos auxiliares
}

// -- Fin del módulo trunk_cylindrical(); -------
// ----------------------------------------------

//////////////////////////////////////////////////////////////////
/////////////////// MODULO trunk_quadrangle  /////////////////////

module trunk_quadrangle (	trunk=[42,20,32],	// medida del cuerpo: [ ancho (x), fondo (y), altura (z) ]
						T=1				// Tipo de hombro:	1 -> 3 chaflanes
										//					2 -> 4 chaflanes
						){
$fn=50;

// valores con límites: acotados entre un máximo y un mínimo
x_trunk=lim(x_trunk_minmax[0],trunk[0],x_trunk_minmax[1]);
y_trunk=lim(y_trunk_minmax[0],trunk[1],y_trunk_minmax[1]);
z_trunk=lim(z_trunk_minmax[0],trunk[2],z_trunk_minmax[1]);

// variables condicionadas a los valores de entrada
x_shoulder=x_trunk/10;
y_shoulder=y_trunk;
z_shoulder=max(26,3*z_trunk/5);

// Volumen 
union(){
	translate ([0,0,z_trunk/2])
		cube ([x_trunk,y_trunk,z_trunk],center=true);

	// hombros
	if(T<=1){
		for(i=[0,1]){
			mirror([i,0,0])
				translate([-x_trunk/2,0,z_trunk-z_shoulder])
					shoulder (S=T,shoulder=[x_shoulder,y_shoulder,z_shoulder]);
			}
		}
	if(T>=2){
		for(i=[0,1]){
			mirror([i,0,0])
				translate([-x_trunk/2,0,z_trunk-y_shoulder])
					shoulder (S=T,shoulder=[x_shoulder,y_shoulder,z_shoulder]);
			}
		}
	}

// ----- Modulos auxiliares ------------

module shoulder(S,shoulder){

x_shoulder=shoulder[0];
y_shoulder=shoulder[1];
z_shoulder=shoulder[2];

angle=45;		//[0:45]

// paralepipedo achflanado en 3 lados	
if(S<=1){
	rotate([0,-90,0])translate ([z_shoulder/2,0,0])
	hull(){
		translate ([0,0,-0.05])
			cube([z_shoulder,y_shoulder,0.1],center=true);
		translate ([x_shoulder*cos(angle)/2,0,x_shoulder/2])
			cube([z_shoulder-x_shoulder*cos(angle),y_shoulder-2*x_shoulder*cos(angle),x_shoulder],center=true);
		}
	}

// paralepipedo achflanado en 4 lados
	else{
		if(S>=2){
			rotate([0,-90,0])translate ([y_shoulder/2,0,0])
			hull(){
				translate ([0,0,-0.05])
					cube([y_shoulder,y_shoulder,0.1],center=true);
				translate ([0,0,x_shoulder/2])
					cube([y_shoulder-2*x_shoulder*cos(angle),y_shoulder-2*x_shoulder*cos(angle),x_shoulder],center=true);
			}
		}	
	}
}
// ----- Fin de los módulos auxiliares ------------
}

// ---- Fin del módulo trunk_quadrangle(trunk=[x,x,x],T=1); ---------------
// ------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

i=70;

// Con forma de caja
trunk_quadrangle(trunk=[42,24,40],T=2);


// Conicos y cilindricos
translate([i,0,0])
	trunk_cylindrical(trunk=[45,35,48],shoulder=[18,10,6]);

