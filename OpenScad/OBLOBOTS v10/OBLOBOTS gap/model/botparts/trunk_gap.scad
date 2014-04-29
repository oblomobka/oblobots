//////////////////////////////////////////////////////////////////////////////////////////////
// Trunk gap [OBLOBOTS] 
// joint_gap
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) 2014-02 - v.10
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <../../../utilities/external_elements_oblobots.scad>
include <../../../utilities/presets_oblobots.scad>
include <../../../utilities/limits_oblobots.scad>

use <../../../utilities/functions_oblomobka.scad>
use <../../../utilities/shapes_oblomobka.scad>

use <../../../OBLOBOTS preforms/trunk.scad>

use <../../../joints/gap_oblobots.scad>

use <badges_gap.scad>


//////////////////////////////////////////////////////////////////
/////////////////// MODULO trunk_union_cylindrical ()  ///////////

module trunk_union_cylindrical (	trunk=[45,30,40],		// [d1,d2,h] medida del cuerpo:
								shoulder=[25,3,3],	// [d,daux,h]
								neck=[18,15,1],		// [d1,d2,h] medidas y forma de la base. Opcional
								pin=DOWEL_6, 
								play=0,				// ajuste entre pines
								resolution=50
								){

// valores con límites: acotados entre un máximo y un mínimo
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);				// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);				// altura (diámetro) de la bola

d1_trunk=lim(d1_trunk_minmax[0],trunk[0],d1_trunk_minmax[1]);	// medida del cuerpo: diametro base 
d2_trunk=lim(d2_trunk_minmax[0],trunk[1],d1_trunk); 			// medida del cuerpo: diametro punta 
h_trunk=lim(h_trunk_minmax[0],trunk[2],h_trunk_minmax[1]);		// medida del cuerpo: altura 
		
angle_trunk=atan2(h_trunk,(d1_trunk-d2_trunk)/2);				// ángulo de la pared del cono-cilindro

d1_shoulder=lim(d_pin+3,shoulder[0],h_trunk*sin(angle_trunk));						// diámetro del hombro 
d_aux_shoulder=lim(d_aux_shoulder_minmax[0],shoulder[1],d_aux_shoulder_minmax[1]);	// diámetro del hombro intersección cono
h_shoulder=lim(h_shoulder_minmax[0],shoulder[2],d2_trunk/2);

d1_neck=lim(d_pin+2,neck[0],d2_trunk);
d2_neck=lim(d_pin+2,neck[1],d1_neck);
h_neck=lim(h_neck_minmax[0],neck[2],h_neck_minmax[1]);

// variables condicionadas a los valores de entrada
d2_shoulder=d1_shoulder+d_aux_shoulder;
d2_v_shoulder=d2_shoulder*sin(angle_trunk);
d1_v_shoulder=d1_shoulder*sin(angle_trunk);

h_shoulder_trunk=h_trunk-d2_v_shoulder/2;
d_shoulder_trunk=di_cone(d1_trunk,d2_trunk,h_trunk,h_shoulder_trunk);		// diámetro intermedio del cono

h_i_shoulder=d2_trunk/2-(sqrt(pow(d2-trunk/2,2)-pow(d2_shoulder/2,2)));
h_aux_shoulder=h_shoulder+h_i_shoulder;

// Volumen
difference(){
	union(){
		trunk_cylindrical(trunk=trunk,shoulder=[d1_shoulder,d_aux_shoulder,h_shoulder]);
		translate([0,0,h_trunk])cylinder(r1=d1_neck/2,r2=(d2_neck)/2,h=h_neck);
		}
		// Hueco para introducir una espiga de madera (u otra cosa cilíndrica del diámetro apropiado) en el cuello
		translate([0,0,h_trunk+h_neck])rotate([180,0,0])
			gap(gap=pin,deep=pin[1]/2,play=play);

		// Hueco para introducir una espiga de madera (u otra cosa cilíndrica del diámetro apropiado) en la cadera
		gap(gap=pin,deep=pin[1]/2,play=play);
	
		// Hueco para introducir una espiga de madera (u otra cosa cilíndrica del diámetro apropiado) en los brazos
		for(i=[0,1]){
			mirror([i,0,0])
				translate([-(d_shoulder_trunk/2+h_shoulder),0,h_trunk-(d1_v_shoulder/2)])
					rotate([0,180-angle_trunk,0])
						gap(gap=pin,deep=3*pin[1]/4,play=play);	
			}
		}
	
	
}

// -- Fin del módulo trunk_union_cylindrical(); --------
// -----------------------------------------------------

//////////////////////////////////////////////////////////////////
/////////////////// MODULO trunk_badge_cylindrical ()  ///////////

module trunk_badge_cylindrical (	trunk=[45,32,45],			// [d1,d2,h] medida del cuerpo
								shoulder=[16,2,2],		// [d,daux,h]
								badge=[20,2.5,3,5],		// [d,h base, b, n lados]
								badgeposition=[1,180],	// [dist b, ang] 
								pin=DOWEL_6,
								play=0
								){

// valores con límites: acotados entre un máximo y un mínimo
d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);				// diámetro del círculo-base donde se inscribe la pirámide
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);				// profundidad del rebaje
n_badge=lim(n_badge_minmax[0],badge[3],n_badge_minmax[1]);				// nº lados de la base de la pirámide
edge_badge=lim(edge_badge_minmax[0],badge[2],edge_badge_minmax[1]);		// borde del alojamiento del badge

d1_trunk=lim(d1_trunk_minmax[0],trunk[0],d1_trunk_minmax[1]); 		// medida del cuerpo: diametro base
d2_trunk=lim(d2_trunk_minmax[0],trunk[1],d1_trunk);	 				// medida del cuerpo: diametro punta 
h_trunk=lim(h_trunk_minmax[0],trunk[2],h_trunk_minmax[1]);			// medida del cuerpo: altura 

angle_trunk=atan2(h_trunk,(d1_trunk-d2_trunk)/2);				// ángulo de la pared del cono-cilindro

// variables condicionadas a los valores de entrada
h_badge_trunk=h_trunk-3-badgeposition[0]-(d_badge+2*edge_badge)*0.5*sin(angle_trunk);	// altura intermedia del tronco para la posición del badge
d_badge_trunk=di_cone(d1_trunk,d2_trunk,h_trunk,h_badge_trunk);				// diámetro intermedio del tronco para la posición del badge

// Volumen
difference(){
	union(){
		trunk_cylindrical (trunk=trunk,shoulder=shoulder);
		translate([0,d_badge_trunk/2,h_badge_trunk])
			rotate([-angle_trunk,0,0])
				translate([0,0,-10])
					rotate([0,0,badgeposition[1]])
					rotate([0,0,180/n_badge])
						prism_circumscribed(d=d_badge+2*edge_badge,h=10,n=n_badge);
		}
	translate([0,d_badge_trunk/2,h_badge_trunk])
			rotate([-angle_trunk,0,0])
				rotate([0,0,badgeposition[1]])
				rotate([0,180,180/n_badge])
					badge_subtraction(badge=[d_badge,h_badge,n_badge],pin=pin,play=play);
	}
}

// -- Fin del módulo trunk_badge_cylindrical(); --------
// -----------------------------------------------------

////////////////////////////////////////////////////////////////////////
/////////////////// MODULO trunk_badge_union_cylindrical ()  ///////////

module trunk_badge_union_cylindrical (	trunk=[40,37,40],		// [d1,d2,h] medida del cuerpo
									shoulder=[18,5,1],	// [d,daux,h]
									pin=DOWEL_6,
									neck=[30,25,1],		// [d1,d2,h] medidas y forma de la base. Opcional
									badge=[20,2.5,2,7],	// [d,h base, b, n lados]
									badgeposition=[0,0],	// [dist b, ang] 
									play=0,
									resolution=50
									){

// valores con límites: acotados entre un máximo y un mínimo
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);				// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);				// altura (diámetro) de la bola

d1_trunk=lim(d1_trunk_minmax[0],trunk[0],d1_trunk_minmax[1]);	// medida del cuerpo: diametro base 
d2_trunk=lim(d2_trunk_minmax[0],trunk[1],d1_trunk); 			// medida del cuerpo: diametro punta 
h_trunk=lim(h_trunk_minmax[0],trunk[2],h_trunk_minmax[1]);		// medida del cuerpo: altura 
		
angle_trunk=atan2(h_trunk,(d1_trunk-d2_trunk)/2);				// ángulo de la pared del cono-cilindro

d1_shoulder=lim(d_pin+3,shoulder[0],h_trunk*sin(angle_trunk));						// diámetro del hombro 
d_aux_shoulder=lim(d_aux_shoulder_minmax[0],shoulder[1],d_aux_shoulder_minmax[1]);	// diámetro del hombro intersección cono
h_shoulder=lim(h_shoulder_minmax[0],shoulder[2],d2_trunk/2);

d1_neck=lim(d_pin+2,neck[0],d2_trunk);
d2_neck=lim(d_pin+2,neck[1],d1_neck);
h_neck=lim(h_neck_minmax[0],neck[2],h_neck_minmax[1]);

// variables condicionadas a los valores de entrada
d2_shoulder=d1_shoulder+d_aux_shoulder;
d2_v_shoulder=d2_shoulder*sin(angle_trunk);
d1_v_shoulder=d1_shoulder*sin(angle_trunk);

h_shoulder_trunk=h_trunk-d2_v_shoulder/2;
d_shoulder_trunk=di_cone(d1_trunk,d2_trunk,h_trunk,h_shoulder_trunk);		// diámetro intermedio del cono

h_i_shoulder=d2_trunk/2-(sqrt(pow(d2-trunk/2,2)-pow(d2_shoulder/2,2)));
h_aux_shoulder=h_shoulder+h_i_shoulder;

// Volumen

difference(){
	union(){
		trunk_badge_cylindrical(	trunk=trunk,
								shoulder=[d1_shoulder,d_aux_shoulder,h_shoulder],
								badge=badge,
								badgeposition=badgeposition,
								pin=pin,
								play=play
								);
		translate([0,0,h_trunk])cylinder(r1=d1_neck/2,r2=(d2_neck)/2,h=h_neck);
		}
		// Hueco para introducir una espiga de madera (u otra cosa cilíndrica del diámetro apropiado) en el cuello
		translate([0,0,h_trunk+h_neck])rotate([180,0,0])
			gap(gap=pin,deep=pin[1]/2,play=play);

		// Hueco para introducir una espiga de madera (u otra cosa cilíndrica del diámetro apropiado) en la cadera
		gap(gap=pin,deep=pin[1]/2,play=play);
	
		// Hueco para introducir una espiga de madera (u otra cosa cilíndrica del diámetro apropiado) en los brazos
		for(i=[0,1]){
			mirror([i,0,0])
				translate([-(d_shoulder_trunk/2+h_shoulder),0,h_trunk-(d1_v_shoulder/2)])
					rotate([0,180-angle_trunk,0])
						gap(gap=pin,deep=3*pin[1]/4,play=play);		
			}
		}
}

// -- Fin del módulo trunk_badge_union_cylindrical(); --------
// -----------------------------------------------------


//////////////////////////////////////////////////////////////////
///////////// MODULO trunk_union_quadrangle  /////////////////////

module trunk_union_quadrangle	(	trunk=[42,25,40],		// medida del cuerpo: [ancho(x),fondo(y),altura(z)]
								T=1,					// Tipo de hombro:	1 -> 3 chaflanes
													//					2 -> 4 chaflanes
								pin=DOWEL_6,
								neck=[20,15,1,2],		// [d1,d2,h,n] medidas y forma de la base. Opcional
								play=0,
								resolution=50
								){

// valores con límites: acotados entre un máximo y un mínimo
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);					// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);					// longitud del pin

x_trunk=lim(x_trunk_minmax[0],trunk[0],x_trunk_minmax[1]);
y_trunk=lim(d_pin+1+x_trunk/5,trunk[1],y_trunk_minmax[1]);
z_trunk=lim(z_trunk_minmax[0],trunk[2],z_trunk_minmax[1]);

n_neck=lim(n_neck_minmax[0],neck[3],n_neck_minmax[1]);
d1_neck=lim(d_pin+2,neck[0],min(x_trunk,y_trunk));
d2_neck=lim(d_pin+2,neck[1],d1_neck);
h_neck=lim(h_neck_minmax[0],neck[2],h_neck_minmax[1]);

// variables condicionadas a los valores de entrada
x_shoulder=x_trunk/10;
y_shoulder=y_trunk;
z_shoulder=max(26,3*z_trunk/5);

//hermaphroditic(pin=pin,play=play,z=z_trunk+h_neck,direction=-90,resolution=resolution)
difference(){
	union(){
		trunk_quadrangle (trunk=trunk,T=T);
		translate([0,0,z_trunk])
			pyramid_circumscribed (n=n_neck,d1=d1_neck,d2=d2_neck,h=h_neck);	
		}

		// Hueco para introducir una espiga de madera (u otra cosa cilíndrica del diámetro apropiado) en la cadera
		gap(gap=pin,deep=pin[1]/2,play=play);

		// Hueco para introducir una espiga de madera (u otra cosa cilíndrica del diámetro apropiado) en el cuello
		translate([0,0,z_trunk+h_neck])rotate([180,0,0])
			gap(gap=pin,deep=pin[1]/2,play=play);


		// Hueco para introducir una espiga de madera (u otra cosa cilíndrica del diámetro apropiado) en los brazos
		if(T<=1){
			for(i=[-1,1]){
				translate([-i*(x_trunk/2+x_shoulder),0,z_trunk-4-d_pin/2])
					rotate([0,i*90,0])
						gap(gap=pin,deep=3*pin[1]/4,play=play);
				}
			}
		if(T>=2){
			for(i=[-1,1]){
				translate([-i*(x_trunk/2+x_shoulder),0,z_trunk-y_shoulder/2])
					rotate([0,i*90,0])
						gap(gap=pin,deep=3*pin[1]/4,play=play);
				}
			}		
	}	
}

// ---- Fin del módulo trunk_union_quadrangle(); ---------
// ------------------------------------------------------------------------

//////////////////////////////////////////////////////////////////
///////////// MODULO trunk_badge_union_quadrangle  ///////////////

module trunk_badge_union_quadrangle	(	trunk=[42,25,40],		// medida del cuerpo: [ancho(x),fondo(y),altura(z)]
										T=2,					// Tipo de hombro:	1 -> 3 chaflanes
															//					2 -> 4 chaflanes
										pin=DOWEL_6,
										neck=[20,15,1,2],		// [d1,d2,h,n] medidas y forma de la base. Opcional
										
										badge=[20,2.5,8],		 
										badgeposition=[3,0],	// [dist b, ang]
										play=0,
										resolution=50
										){

// valores con límites: acotados entre un máximo y un mínimo
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);					// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);					// longitud del pin

n_neck=lim(n_neck_minmax[0],neck[3],n_neck_minmax[1]);
d1_neck=lim(d_pin+2,neck[0],min(x_trunk,y_trunk));
d2_neck=lim(d_pin+2,neck[1],d1_neck);
h_neck=lim(h_neck_minmax[0],neck[2],h_neck_minmax[1]);

x_trunk=lim(x_trunk_minmax[0],trunk[0],x_trunk_minmax[1]);
y_trunk=lim(d_pin+1+x_trunk/5,trunk[1],y_trunk_minmax[1]);
z_trunk=lim(z_trunk_minmax[0],trunk[2],z_trunk_minmax[1]);

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);			// diámetro del círculo-base donde se inscribe la pirámide
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);			// profundidad del rebaje
n_badge=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);			// nº lados de la base de la pirámide



difference(){
	trunk_union_quadrangle (trunk=trunk,T=T,pin=pin,neck=neck,play=play,resolution=resolution);
	translate([0,y_trunk/2,z_trunk-d_badge/2-2.5-badgeposition[0]])
		rotate([-90,0,180])
			rotate([0,0,+badgeposition[1]])
				badge_subtraction(badge=badge,pin=pin,play=play);
	}
}

// ---- Fin del módulo trunk_badge_quadrangle(); ---------
// -------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

i=70;

// Con forma de caja
trunk_quadrangle(trunk=[45,25,32],T=1);

translate([0,i,0])
	trunk_union_quadrangle(	trunk=[50,30,50],	
							T=2,	
							pin=DOWEL_6,	
							neck=[23,19,3,5],	
							play=0,
							resolution=12);

translate([-i,i,0])
	trunk_badge_union_quadrangle(	trunk=[40,25,42],	
								T=2,	
								pin=DOWEL_6,	
								neck=[15,15,2,4],	
								badge=[20,2,7],		 
								badgeposition=[1,0],
								play=0,
								resolution=12);



// Conicos y cilindricos
translate([i,0,0])
	trunk_cylindrical(trunk=[40,30,48],shoulder=[18,0,3]);

translate([i,i,0])
	trunk_union_cylindrical(	trunk=[40,32,40],	
							shoulder=[20,6,3],
							pin=PIPE_6,
							neck=[26,15,3],
							play=0.0,
							resolution=8);

translate([2*i,0,0])
	trunk_badge_cylindrical(	trunk=[50,30,45],	
							shoulder=[20,5,1],
							badge=[24,2,1,50],
							badgeposition=[1,0],
							pin=PIPE_6,
							play=0);

translate([2*i,i,0])
	trunk_badge_union_cylindrical(	trunk=[42,42,42],	
									shoulder=[24,3,2],	
									pin=PIPE_6,
									neck=[24,24,3],
									badge=[20,2,2,6],
									badgeposition=[3,90],
									play=0,
									resolution=8);



