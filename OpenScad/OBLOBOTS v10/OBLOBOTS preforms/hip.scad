//////////////////////////////////////////////////////////////////////////////////////////////////
// HIP[OBLOBOTS] 
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


//////////////////////////////////////////////////////////////////
/////////////////// MODULO hip_cylindrical  //////////////////////

module hip_cylindrical(hip=[40,15,80]){	// [ d,h,f ] Medidas de la cadera

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
d_hip=lim(d_hip_minmax[0],hip[0],d_hip_minmax[1]);
h_hip=lim(h_hip_minmax[0],hip[1],h_hip_minmax[1]);
f_hip=lim(f_hip_minmax[0],hip[2],f_hip_minmax[1]);

// variables condicionadas a los valores de entrada
h1_hip=h_hip-f_hip*h_hip/110;
h2_hip=h_hip-h1_hip;

d1_hip=max(3*d_hip/4,(d_hip-2*h1_hip));  // diámetro inferior de la cadera

$fn=50;

// --------- Volumen ----------------

union(){
	cylinder(r1=d1_hip/2,r2=d_hip/2,h=h1_hip);
	translate([0,0,h1_hip])
		cylinder (r=d_hip/2,h=h2_hip);	
	}
}
// -------------- Fin del módulo hip_cylindrical() ------------------------
// ------------------------------------------------------------------------


//////////////////////////////////////////////////////////////////
/////////////////// MÓDULO hip_quadrangle()  /////////////////////

module hip_quadrangle (hip=[40,22,18,3]){			// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera


x_hip=lim(x_hip_minmax[0],hip[0],x_hip_minmax[1]);			// medida de la cadera: ancho
y_hip=lim(y_hip_minmax[0],hip[1],y_hip_minmax[1]);			// medida de la cadera: fondo
z_hip=lim(z_hip_minmax[0],hip[2],z_hip_minmax[1]);			// medida de la cadera: alto
bevel_hip=lim(bevel_hip_minmax[0],hip[3],bevel_hip_minmax[1]);;		// medida de la cadera: chaflán

// Volumen
difference(){
	translate([0,0,z_hip/2])
		cube ([x_hip,y_hip,z_hip],center=true);
	for(i=[	[1,1,0],
			[1,-1,-90],
			[-1,1,90],
			[-1,-1,180]]){
		translate([i[0]*x_hip,i[1]*y_hip,0]/2)
			rotate([0,0,i[2]])rotate(45*[0,1,1])
				cube([min(2*bevel_hip,((y_hip-1)/2)),x_hip,x_hip],center=true);
		}
	}
}
// ------------ Fin del módulo hip_quadrangle(hip[x,y,z,b]) -------------
// ----------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

i=35;

translate([i,0,0])
	hip_cylindrical(hip=[60,21,90]);

translate([-i,0,0])
	hip_quadrangle(hip=[50,25,25,4]);

