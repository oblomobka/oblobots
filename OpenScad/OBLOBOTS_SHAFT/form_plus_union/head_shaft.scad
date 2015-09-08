// head shaft [OBLOBOTS] v.12
// form + union
// (c) Jorge Medal (@oblomobka) 2015.09
// GPL license

include <../../2_helpers/external_elements.scad>
include <../../2_helpers/presets_oblobots.scad>
include <../../2_helpers/limits_oblobots.scad>

use <../../0_forms/head.scad>
use <../../1_unions/shaft.scad>

use <oblomobka/functions.scad>
use <oblomobka/shapes.scad>
use <oblomobka/solids.scad>

// Módulos

module head_cylindrical_shaft ( head=[30,35,40], 			//	[d1,d2,h]
								brain=[3,2],				// 	[altura,borde]
								E=1,						// 	Tipo de ojo:	0 -> Sin ojo
                                                            //				1 -> hueco circ rebajado
                                                            //				2 -> hueco circ con reborde
                                                            //				3 -> cono ciego
                                                            //				4 -> 
								eye=[12,5,3],			    // 	[d,h,edge]
								eye_expression=[-45,50],	// 	[exp1,exp2] valores de expresión de los ojos	
								eye_position=[20,50],		// 	[sep,z] posición de los ojos	
								pin=[6,30],
								play=0
								){

h_head=lim(h_head_minmax[0],head[2],h_head_minmax[1]);
h_brain=lim(h_brain_minmax[0],brain[0],h_brain_minmax[1]);

color(head_color)
difference(){
	head_cylindrical (head=head,brain=brain,E=E,eye=eye,eye_expression=eye_expression,eye_position=eye_position);
	
    //Union
    shaft(shaft=pin,play=play);
	translate([0,0,h_head-h_brain])rotate([0,180,0])
		shaft(shaft=pin,play=play);
	}
}

module head_quadrangle_shaft ( 	head=[30,35,40], 			//	[x,y,z]
								brain=[3,2],				// 	[altura,borde]
								E=1,						// 	Tipo de ojo:	0 -> Sin ojo
                                                            //				1 -> hueco circ rebajado
                                                            //				2 -> cono interior
                                                            //				3 -> cono ciego
                                                            //				4 -> 
								eye=[12,5],				    // 	[d,h]
								eye_expression=[-45,50],	// 	[exp1,exp2] valores de expresión de los ojos	
								eye_position=[20,50],		// 	[sep,z] posición de los ojos	
								pin=[6,30],
								play=0
								){

z_head=lim(z_head_minmax[0],head[2],z_head_minmax[1]);
h_brain=lim(h_brain_minmax[0],brain[0],h_brain_minmax[1]);


color(head_color)
difference(){
	head_quadrangle (head=head,brain=brain,E=E,eye=eye,eye_expression=eye_expression,eye_position=eye_position);
	
    // Union
	shaft (shaft=pin,play=play);
	if(E==1){
	translate([0,0,z_head-0.8])rotate([0,180,0])
		shaft (shaft=pin,play=play);
		}
	else{
	translate([0,0,z_head-h_brain])rotate([0,180,0])
		shaft (shaft=pin,play=play);
	}
	}
}

// Ejemplo
i=80;

translate([0*i,0*i,0])
	head_quadrangle(		head=[40,25,40],
                                brain=[3,4],
                                E=3,	
                                eye=[10,3],
                                eye_expression=[30,40],
                                eye_position=[50,75]);

translate([1*i,0*i,0])
	head_cylindrical(		head=[35,45,40],
                                brain=[5,3],
                                E=1,	
                                eye=[18,3,1],
                                eye_expression=[-35,80],
                                eye_position=[10,50]);

translate([0*i,1*i,0])
	head_cylindrical_shaft(	head=[25,25,30],
							brain=[5,2],
							E=2,	
							eye=[12,3,1],
							eye_expression=[35,45],
							eye_position=[35,75],
							pin=DOWEL_8,
							play=0);

translate([1*i,1*i,0])
	head_quadrangle_shaft(	head=[25,25,35],
							brain=[5,2],
							E=1,	
							eye=[15,3],
							eye_expression=[-35,45],
							eye_position=[15,75],
							pin=DOWEL_6,
							play=0);
