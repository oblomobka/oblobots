///////////////////////////////////////////////////////////////////////////////////////////////
// head[OBLOBOTS] 
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
use <../utilities/parts_oblobots.scad>

//////////////////////////////////////////////////////////////////
/////////// MODULO head_cylindrical () ///////////////////////////

module head_cylindrical (		head=[30,35,40], 			//	[d1,d2,h]
							brain=[3,2],				// 	[altura,borde]
							E=1,						// 	Tipo de ojo:	0 -> Sin ojo
													//				1 -> hueco circ rebajado
													//				2 -> hueco circ con reborde
													//				3 -> cono ciego
													//				4 -> 
							eye=[12,5,3],			// 	[d,h,edge]
							eye_expression=[-45,50],	// 	[exp1,exp2] valores de expresión de los ojos	
							eye_position=[20,50],		// 	[sep,z] posición de los ojos	
							){

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
h_head=lim(h_head_minmax[0],head[2],h_head_minmax[1]);		// medida de la cabeza: altura
d1_head=lim(h_head_minmax[0],head[0],h_head_minmax[1]);		// medida de la cabeza: diámetro de base del cono
d2_head=lim(h_head_minmax[0],head[1],2*headh+headd1);		// medida de la cabeza: diámetro de la punta del cono

d_eye=lim(d_eye_minmax[0],eye[0],(d1_head+d2_head)/2);				// Diámetro ojo (para tipos 1 y 3) 
h_eye=lim(h_eye_minmax[0],eye[1],h_eye_minmax[1]);			// lo que sobresale el ojo (para tipos 2 y 3)
edge_eye=lim(edge_eye_minmax[0],eye[2],d_eye/2-3);

angle_eye_expression=eye_expression[0];				
frown_eye_expression=lim(frown_eye_expression_minmax[0],eye_expression[1],frown_eye_expression_minmax[1]);	// [0:100] 
bridge_eye_position=lim(bridge_eye_position_minmax[0],eye_position[0],bridge_eye_position_minmax[1]);		// [0:100] 
f_h_eye_position=lim(f_h_eye_position_minmax[0],eye_position[1],f_h_eye_position_minmax[1]);	


// variables condicionadas a los valores de entrada

// relaciones necesarias para determinar la posición de los ojos en el volumen cabeza
h_edge=5;
h_eye_position=h_edge+d_eye/2+f_h_eye_position*(h_head-d_eye-2*h_edge)/f_h_eye_position_minmax[1];
d_i_eye_position=di_cone(d1_head,d2_head,h_head,h_eye_position);			// diámetro intermedio de la cabeza, para posicionar los ojos
r_eye_position=r_circle_intersection(d_i_eye_position,d_eye);

minimal=atan2(d_eye/2,r_eye_position)+1;
maximal=90-minimal;

angle_eye_position=minimal+bridge_eye_position*(maximal-atan2(d_eye/2,r_eye_position))/bridge_eye_position_minmax[1];

$fn=50;

// Volumen
if(E<=0){
	empty_brain_cylindrical()
		cylinder(r1=d1_head/2,r2=d2_head/2,h=h_head);
}
else{
if(E==1){
	// hueco en la parte superior de la cabeza
	empty_brain_cylindrical()
	difference(){
		// Volumen de la cabeza
		cylinder(r1=d1_head/2,r2=d2_head/2,h=h_head);
		// Colocación de los ojos en la cabeza
		move_eyes_conic_subtraction ()
				// Forma del ojo
				difference(){
					cylinder(r=d_eye/2,h=h_eye);
						rotate([0,0,angle_eye_expression])
							translate([0,(2+(2*frown_eye_expression/frown_eye_expression_minmax[1]))*d_eye/4,h_head/2-1])
								cube([d_eye,d_eye,h_head],center=true);
					}
		}
	}
	else{
	if(E==2){
		// hueco en la parte superior de la cabeza
		empty_brain_cylindrical()
			difference(){
					union(){
						// Volumen de la cabeza
						cylinder(r1=d1_head/2,r2=d2_head/2,h=h_head);
						// Colocación de los ojos en la cabeza
						move_eyes_conic_subtraction ()
						// Forma del ojo
						difference(){
							cylinder(r=d_eye/2,h=d_i_eye_position/2-r_eye_position);
							rotate([0,0,angle_eye_expression])
								translate([0,(2+(2*frown_eye_expression/frown_eye_expression_minmax[1]))*d_eye/4,h_head/2])
									cube([d_eye,d_eye,h_head+0.05],center=true);
							}
						}
					move_eyes_conic_subtraction ()
						difference(){
							translate([0,0,-1])
								cylinder(r=(d_eye-2*edge_eye)/2,h=h_eye+1);
							translate([0,0,-1])
							rotate([0,0,angle_eye_expression])
								translate([0,(2+(2*frown_eye_expression/frown_eye_expression_minmax[1]))*d_eye/4,h_head/2-1])
									cube([(d_eye+2*edge_eye),(d_eye+2*edge_eye),h_head],center=true);
							}
					}
			}
			
			else{
				if(E>=3){
					// hueco en la parte superior de la cabeza
					empty_brain_cylindrical()
						union(){
						// Volumen de la cabeza
							cylinder(r1=d1_head/2,r2=d2_head/2,h=h_head);
							// Colocación de los ojos en la cabeza
							move_eyes_conic_addition ()
								// Forma del ojo
								rotate([0,180,0])
								blindcone(d=d_eye);
							}
					
					}
				}
			}
	}



// Modulos auxiliares 

module move_eyes_conic_subtraction	(){

	for(i=[0,1]){
		mirror([i,0,0])
			rotate ([0,0,angle_eye_position])
				translate ([0,d_i_eye_position/2+0.05,h_eye_position])
					rotate ([atan2(h_head,(d2_head-d1_head)/2),0,0])
						child(0);
			}
}

module move_eyes_conic_addition	(){

	for(i=[0,1]){
		mirror([i,0,0])
			rotate ([0,0,angle_eye_position])
				translate ([0,r_eye_position+0.05,h_eye_position])
					rotate ([atan2(h_head,(d2_head-d1_head)/2),0,0])
						child(0);
			}
	}


module empty_brain_cylindrical	(){

	h_brain=lim(h_brain_minmax[0],brain[0],h_brain_minmax[1]);
	edge_brain=lim(edge_brain_minmax[0],brain[1],edge_brain_minmax[1]);

	d2_brain=d2_head-2*edge_brain;
	d1_brain=d1_head-2*edge_brain;

	d_i_brain=di_cone(d1_brain,d2_brain,h_head,h_head-h_brain);	

	difference(){
		child();
		translate([0,0,h_head-h_brain+0.05])
			cylinder(r2=d2_brain/2,r1=d_i_brain/2,h=h_brain);
		}
	}

// Fin de los módulos auxiliares

}

// -------------- Fin del módulo head_cylindrical () --------
// ----------------------------------------------------------



///////////////////////////////////////////////////////////////////////////
/////////////////// MODULO head_quadrangle ()  ////////////////////////////

module head_quadrangle(	head=[30,35,40], 			//	[x,y,z]
						brain=[3,2],				// 	[altura,borde]
						E=1,						// 	Tipo de ojo:	0 -> Sin ojo
												//				1 -> hueco circ rebajado
												//				2 -> cono interior
												//				3 -> cono ciego
												//				4 -> 
						eye=[12,5,3],			// 	[d,h,edge]
						eye_expression=[-45,50],	// 	[exp1,exp2] valores de expresión de los ojos	
						eye_position=[20,50],		// 	[sep,z] posición de los ojos	
						){

$fn=50;

x_head=lim(x_head_minmax[0],head[0],x_head_minmax[1]);		// Arista X del cubo
y_head=lim(y_head_minmax[0],head[1],y_head_minmax[1]);		// Arista Y del cubo
z_head=lim(z_head_minmax[0],head[2],z_head_minmax[1]);		// Arista Z del cubo				

d_eye=lim(d_eye_minmax[0],eye[0],x_head/2-2*1); 		// Diámetro ojo (para tipos 1 y 3)
h_eye=lim(h_eye_minmax[0],eye[1],h_eye_minmax[1]);

angle_eye_expression=eye_expression[0];		
frown_eye_expression=lim(frown_eye_expression_minmax[0],eye_expression[1],frown_eye_expression_minmax[1]);
bridge_eye_position=lim(bridge_eye_position_minmax[0],eye_position[0],bridge_eye_position_minmax[1]);	
f_h_eye_position=lim(f_h_eye_position_minmax[0],eye_position[1],f_h_eye_position_minmax[1]);

// variables condicionadas a los valores de entrada
// relaciones necesarias para determinar la posición de los ojos en el volumen cabeza
z_edge=5;
z_eye_position=z_edge+d_eye/2+f_h_eye_position*(z_head-d_eye-2*z_edge)/f_h_eye_position_minmax[1];

x_eye_minimal=0.5;
x_eye_maximal=x_head/2-d_eye/2-2;

x_eye_position=x_eye_minimal+d_eye/2+bridge_eye_position*(x_eye_maximal-d_eye/2-x_eye_minimal)/bridge_eye_position_minmax[1];

// Volumen 	
if(E<=0){	
	// hueco en la parte superior de la cabeza
	empty_brain_quadrangle()
		// Volumen de la cabeza
		translate([0,0,z_head/2])
			cube([x_head,y_head,z_head],center=true);
}
else{
if(E==1){
	// Rebaje de las caras limpias
	lower()
		difference(){
			// Volumen de la cabeza
			translate([0,0,z_head/2])
				cube([x_head,y_head,z_head],center=true);	
			// Colocación de los ojos en la cabeza			
			move_eyes_cube()
				translate([0,0,-h_eye+0.1])
					// Forma del ojo
					rotate([0,0,180])
						difference(){
							cylinder (r=d_eye/2,h=h_eye);
							rotate([0,0,angle_eye_expression])
								translate([0,(2+(2*frown_eye_expression/100))*d_eye/4,h_eye/2])
									cube([d_eye,d_eye,2*h_eye],center=true);
						}			
			}
	}		
	else{
		if(E>=3){
			// hueco en la parte superior de la cabeza
			empty_brain_quadrangle()
				union(){
					// Volumen de la cabeza
					translate([0,0,z_head/2])
						cube([x_head,y_head,z_head],center=true);
					// Colocación de los ojos en la cabeza			
					move_eyes_cube()
						translate([0,0,-0.1])
							blindcone(d=d_eye);
					// Orejas
					move_ears_cube()
						blindcone(d=1.3*min(y_head,z_head)/2);			
				}
			}
		else{
			if(E==2){
			// hueco en la parte superior de la cabeza
			empty_brain_quadrangle()
				union(){
					difference(){
						// Volumen de la cabeza
						translate([0,0,z_head/2])
							cube([x_head,y_head,z_head],center=true);	
						// Colocación de los ojos en la cabeza			
						move_eyes_cube()
							translate([0,0,-h_eye+0.1])
							// Forma del ojo
								rotate([0,0,180])
									difference(){
										cylinder (r=d_eye/2,h=h_eye);
										rotate([0,0,angle_eye_expression])
										translate([0,(2+(2*frown_eye_expression/100))*d_eye/4,h_eye/2])
											cube([d_eye,d_eye,2*h_eye],center=true);
										}			
						}
					move_eyes_cube()
						translate([0,0,-(h_eye)])
							hull(){
								cylinder(r=d_eye/2,h=0.5);
								translate([0,0,h_eye-1])
									sphere(2);
							}
					}
				}
		}
	}

}


// ----- Modulos auxiliares ------------

module move_eyes_cube	(){

	for(i=[0,1]){
		mirror([i,0,0])
			translate ([x_eye_position,y_head/2,z_eye_position])
				rotate ([-90,0,0])
					child(0);
		}
	}

module move_ears_cube(){

	for(i=[1,-1]){
		translate ([i*x_head/2-0.1*i,0,z_head/2])
			rotate ([0,i*90,0])
				child(0);				
		}
	}

module lower	(){

h_lower=0.8;
edge_lower=lim(edge_brain_minmax[0],brain[1],edge_brain_minmax[1]);;

difference(){
	child();
	translate([0,0,z_head])translate([0,0,-h_lower/2+0.05])
		cube([x_head-2*edge_lower,y_head-2*edge_lower,h_lower],center=true);
	translate([0,-y_head/2,z_head/2])rotate([90,0,0])translate([0,0,-h_lower/2+0.05])
			cube([x_head-2*edge_lower,z_head-2*edge_lower,h_lower],center=true);
	translate([-x_head/2,0,z_head/2])rotate([0,-90,0])translate([0,0,-h_lower/2+0.05])
			cube([z_head-2*edge_lower,y_head-2*edge_lower,h_lower],center=true);
	translate([x_head/2,0,z_head/2])rotate([0,90,0])translate([0,0,-h_lower/2+0.05])
			cube([z_head-2*edge_lower,y_head-2*edge_lower,h_lower],center=true);
	}
}

module empty_brain_quadrangle	(){

	h_brain=lim(h_brain_minmax[0],brain[0],h_brain_minmax[1]);
	edge_brain=lim(edge_brain_minmax[0],brain[1],edge_brain_minmax[1]);

	y_brain=y_head-2*edge_brain;
	x_brain=x_head-2*edge_brain;	

	difference(){
		child();
		translate([0,0,h_brain/2+z_head-h_brain+0.05])
			cube([x_brain,y_brain,h_brain],center=true);
		}
	}

// Fin de los módulos auxiliares 

}

// -------------- Fin del módulo head_quadrangle () -----------------------------
// ------------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

i=80;

translate([0*i,0*i,0])
	head_quadrangle(		head=[60,50,60],
						brain=[5,3],
						E=3,	
						eye=[20,5],
						eye_expression=[-50,30],
						eye_position=[30,0]);

translate([1*i,0*i,0])
	head_cylindrical(		head=[60,45,60],
						brain=[5,3],
						E=2,	
						eye=[20,3,3],
						eye_expression=[-45,60],
						eye_position=[0,12]);


