//////////////////////////////////////////////////////////////////////////////////////////////////
// gap [OBLOBOTS] 
// 
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) 2014-04 - v.10
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <../utilities/constants_oblomobka.scad>
include <../utilities/external_elements_oblobots.scad>
include <../utilities/limits_oblobots.scad>

use <../utilities/functions_oblomobka.scad>
use <../utilities/transformations_oblomobka.scad>
use <../utilities/shapes_oblomobka.scad>



//////////////////////////////////////////////////////
////////// MÓDULOS TIPO BOTÓN AUTOMÁTICO /////////////

layer=0.3;
edge=0.3;

////////// HEMBRAS ////////////////////

module gap (gap=DOWEL_6, deep=15, play=0){								
$fn=6;

h=gap[1];
d=gap[0]+0.25+play;

translate([0,0,-0.1])
	union(){
		pyramid_circumscribed (d1=d+2,d2=d,h=1,n=6);
		translate([0,0,0.9])
			prism_circumscribed (d=d,h=deep+0.1,n=6);
		}	
}


// ------ Ejemplos de alojamiento para botones automáticos ----------------


lado=14;
$fn=50;

difference(){
	translate([0,0,lado/2])
		cube([lado,lado,lado],center=true);
	gap(gap=DOWEL_6,deep=PIPE_6[1]/2,play=0);
}

