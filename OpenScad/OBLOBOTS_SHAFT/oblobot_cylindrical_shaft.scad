// Oblobot cylindrical shaft [OBLOBOTS] v.12
// (c) Jorge Medal (@oblomobka) 2015.09
// GPL license

include <../2_helpers/external_elements.scad>
include <../2_helpers/presets_oblobots.scad>
include <../2_helpers/limits_oblobots.scad>

use <oblomobka/functions.scad>
use <oblomobka/shapes.scad>
use <oblomobka/solids.scad>

use <form_plus_union/head_shaft.scad>
use <form_plus_union/leg_shaft.scad>
use <form_plus_union/hip_shaft.scad>
use <form_plus_union/trunk_shaft.scad>
use <form_plus_union/arm_shaft.scad>
use <form_plus_union/trunkandarms_shaft.scad>
use <form_plus_union/hipandlegs_shaft.scad>
use <form_plus_union/badges_shaft.scad>


// PARÁMETROS 
// Presentación 

oblobot=	ALL;						
		// "ALL"
		// "LEGS"
		// "HIP"
		// "TRUNK"
		// "ARMS"
		// "HEAD"
		// "BADGES"

representation=		ASSEMBLED;			
				// "ASSEMBLED" -> Modelo unido 
				// "EXPLOSION" -> Modelo separado
				// "PRINTING"  -> Todas las piezas apoyadas en el plano xy

// FORMAS 
// CABEZA
head=[23,15,45];			// [ d1,d2,h ] Medidas de la Cabeza
brain=[4,2];				// [h,borde] Pared de la cabeza si es el caso
E=2;						// Tipo de ojo:	0 -> Sin ojo
						//				1 -> hueco circ rebajado						
						//				2 -> hueco circ con reborde
						//				3 -> cono ciego
eye=[11,3,1];			// [d,h] medidas de los ojos
eye_expression=[45,100];	// [exp1,exp2] expresion de los ojos
eye_position=[50,20];		// [sep, altura]

// TRONCO
neck=[32,23,50];		// [ d1,d2,h ]
trunk=[60,25,40];		// [ d1, d2 , h ] Medidas del tronco 
shoulder=[24,3,8];	// [ d, aux d, ancho ] medidas de los hombros en en tronco

// BRAZOS
arm=[24,10,1,80];		// [ d hombro(y), grosor(x), axila (x), longitud(z) ] Medidas de los Brazo
hand=[24,7,112];		// [d, grosor, nº lados] medidas de las manos

// CADERA Y PIERNAS
waist=[80,60,10];		// [ d1,d2,h ] Cintura
hip=[80,18,50,0];		// [ d, h, f, - ] Medidas de la cadera
leg=[24,65,100];		// [ d, long, dist] long incluyendo pie, factor de separación entre piernas
foot=[48,10];		// [ long, h ] Medidas de los pies

// ESCUDOS
badgeunits=[2,3,1]; 		// cada nº define un tipo de escudo. A tantos números tantos escudos
badge=[20,2.5,3,50];		// [ diámetro del escudo, h de la base , borde, número de lados del polígono]
badgeposition=[1,150];		// [ dist al borde supeiror, rotación ]

// UNIONES ENTRE PARTES
pin=DOWEL_6;
play=0;
resolution=8;		// 

//  Ejemplos

rotate([0,0,180])
oblobot_cylindrical_shaft(	head=head,
					brain=brain,

					E=E,	
					eye=eye,
					eye_expression=eye_expression,
					eye_position=eye_position,

					trunk=trunk,
					shoulder=shoulder,
					neck=neck,
			
					arm=arm,
					hand=hand,

					waist=waist,
					hip=hip,
					leg=leg,
					foot=foot,

					badgeunits=badgeunits,
					badge=badge,
					badgeposition=badgeposition,
			
					pin=pin,
					play=play,
					resolution=resolution,

					representation=representation,
					oblobot=oblobot
					);

// Módulo
module oblobot_cylindrical_shaft (
		head=[26,26,26],			// [ acho cara (x),fondo (y), altura (z) ] Medidas de la Cabeza
		brain=[5,2],				// [h,borde] Pared de la cabeza si es el caso
		E=1,						// Tipo de ojo:	0 -> Sin ojo
								//				1 -> hueco circ rebajado
								//				2 -> hueco circ con reborde
								//				3 -> cono ciego
		eye=[10,5],				// [d,h] medidas de los ojos
		eye_expression=[50,90],	// [exp1,exp2] expresion de los ojos
		eye_position=[20,50],		// [sep, altura]
		trunk=[45,25,40],			// [ pecho(x), fondo(y) , altura(z) ] Medidas del tronco	
		shoulder=[20,5,3],		// [ d, aux, h ]
		neck=[25,15,2],			// [ d1, d2, h ]		
		arm=[8,18,1,65],			// [ d hombro(y), grosor(x), axila (x), longitud(z) ] Medidas de los Brazo
		hand=[25,6,8],			// [ d, grosor, nº lados] medidas de las manos
		hip=[33,23,30,6],			// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
		waist=[25,15,2],			// [ d1, d2, h ]
		leg=[12,35,100],			// [ d, long, dist] long incluyendo pie, factor de separación entre piernas
		foot=[37,3],				// [ long, h ]
		badgeunits=[1,2,3],		// cada nº define un tipo de escudo. A tantos números tantos escudos
		badge=[20,2.5,2,5],		// [ diámetro del escudo, h de la base, borde, nº de lados	]
		badgeposition=[5,0],		// [ dist al borde supeiror, rotación ]
		
		pin=[6,30],
		play=0,					// factor de corrección del pin.
		resolution=12,			// resolución para el pin, 	valor bajo mejorara el funcionamiento del programa
								//							valor alto para generar .stl
		representation=ASSEMBLED,	// 0 -> Modelo unido || 1 -> Modelo separado || 2 --> para imprimir
		oblobot=ALL,
		){

// Presentación

q_explosion=24;		// Distancia que se desplazan las partes del cuerpo en el modo explosión
matrix=40;
gap=10;

// PARÁMETROS 


// Medidas con límites
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);			
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);

//
h_head=lim(h_head_minmax[0],head[2],h_head_minmax[1]);			
d1_head=lim(h_head_minmax[0],head[0],h_head_minmax[1]);			
d2_head=lim(h_head_minmax[0],head[1],2*h_head+d1_head);		

//
d1_trunk=lim(d1_trunk_minmax[0],trunk[0],d1_trunk_minmax[1]); 
d2_trunk=lim(d2_trunk_minmax[0],trunk[1],d1_trunk);
h_trunk=lim(h_trunk_minmax[0],trunk[2],h_trunk_minmax[1]);
//trunklim=[td1,td2,th];

//
d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);
edge_badge=lim(edge_badge_minmax[0],badge[2],edge_badge_minmax[1]);
n_badge=lim(n_badge_minmax[0],badge[3],n_badge_minmax[1]);	

q_badges=len(badgeunits);
//badgelim=[badged,badgeh,badgen];

//
d_arm=lim(d_pin+1,arm[0],d_arm_minmax[1]);	
h_arm=lim(h_arm_minmax[0],arm[1],h_arm_minmax[1]);
armpit=lim(armpit_minmax[0],arm[2],armpit_minmax[1]);

d_hand=lim(d_hand_minmax[0],hand[0],d_hand_minmax[1]);
h_hand=lim(h_hand_minmax[0],hand[1],h_arm-0.5);
angle_hand=lim(angle_hand_minmax[0],hand[2]/2,angle_hand_minmax[1]);

l_arm=lim(d_arm+d_hand,arm[3],l_arm_minmax[1]);	
//armlim=[armd,armh,armpit,arml];

//
d_leg=lim(d_leg_minmax[0],leg[0],d_leg_minmax[1]);
h_leg=lim(h_leg_minmax[0],leg[1],h_leg_minmax[1]);	
legsposition=lim(legsposition_minmax[0],leg[2],legsposition_minmax[1]);

//
d_hip=lim(d_hip_minmax[0],hip[0],d_hip_minmax[1]);
//h_hip=lim(h_pin+2,hip[1],h_hip_minmax[1]);
h_hip=lim(h_hip_minmax[0],hip[1],h_hip_minmax[1]);
f_hip=lim(f_hip_minmax[0],hip[2],f_hip_minmax[1]);
//hiplim=[hipd,hiph,hipf];

//
d1_neck=lim(d_pin,neck[0],d2_trunk);
d2_neck=lim(d_pin,neck[1],d1_neck);
h_neck=lim(h_neck_minmax[0],neck[2],h_neck_minmax[1]);
//necklim=[neckd1,neckd2,neckh];

//
d1_waist=lim(d_pin,waist[0],d_hip);
d2_waist=lim(d_pin,waist[1],d1_waist);
h_waist=lim(h_waist_minmax[0],waist[2],h_waist_minmax[1]);
//waistlim=[waistd1,waistd2,waisth];

// Variables para posicionar las partes en las diferentes representaciones
Z_trunk_assembled=h_leg+h_hip+h_waist;
Z_head_assembled=Z_trunk_assembled+h_trunk+h_neck;


// POSICIÓN DE LAS PARTES

if(oblobot==ALL){

// Cabeza
translate([((max(d1_head,d2_head)+d1_trunk)/2+gap)*representation[0],-((l_arm+max(d1_head,d2_head))/2+gap)*representation[0],representation[1]*(Z_head_assembled)+representation[2]*(q_explosion+2*(h_pin+10))])
		head_cylindrical_shaft(	head=head,
								brain=brain,
								E=E,	
								eye=eye,
								eye_expression=eye_expression,
								eye_position=eye_position,
								pin=pin,
								play=play);


// Tronco y brazos
translate([0,0,representation[1]*(Z_trunk_assembled)+representation[2]*(q_explosion+h_pin+10)])
	trunkandarms_cylindrical_shaft (	trunk=trunk,	
                                        shoulder=shoulder,
                                        arm=arm,
                                        hand=hand,
                                        pin=pin,	
                                        neck=neck,	
                                        badge=badge,		 
                                        badgeposition=badgeposition,
                                        badgeunits=badgeunits,
                                        play=play,
                                        resolution=resolution,
                                        representation=representation[3]);


// Cadera y piernas
translate ([0,-((d1_trunk+d_hip)/2+gap)*representation[0],0])
	hipandlegs_cylindrical_shaft(	hip=hip,
                                    pin=pin,	
                                    waist=waist,	
                                    leg=leg,
                                    foot=foot,
                                    play=play,
                                    resolution=resolution,
                                    representation=representation[3]);


if(representation[3]==2){
	color([1,0,0,0.5])
	translate([0,-40,-2.5])
		cube([200,200,5],center=true);
	}
}


else{
	if(oblobot==LEGS){
		color("gold")
		legs_cylindrical_shaft(	hip=hip,
								leg=leg,
								foot=foot,
								pin=pin,
								play=play,
								resolution=resolution,
								angle=0);
		}
	else{
	if(oblobot==HIP){
		color("gold")
		hip_cylindrical_shaft(	hip=hip,
								pin=pin,
								waist=waist,
								legsposition=legsposition,
								play=play,
								resolution=resolution);

		}
	else{
	if(oblobot==TRUNK){
		color("gold")
		for(i=q_badges-1){
			if(badgeunits[0]==0&&badgeunits[i]==0){
				trunk_cylindrical_shaft(	trunk=trunk,	
										shoulder=shoulder,	
										pin=pin,
										neck=neck,
										play=play,
										resolution=resolution);
			}
		else{
				trunk_badge_cylindrical_shaft(	trunk=trunk,	
												shoulder=shoulder,	
												pin=pin,
												neck=neck,
												badge=badge,
												badgeposition=badgeposition,
												play=play,	
												resolution=resolution);
		}}}
	else{
	if(oblobot==HEAD){
		color("gold")
		head_cylindrical_shaft(	head=head,
								brain=brain,
								E=E,	
								eye=eye,
								eye_expression=eye_expression,
								eye_position=eye_position,
								pin=pin,
								play=play);
		}
	else{
	if(oblobot==ARMS){
		for(i=[0,1]){
			color("gold")
				mirror([0,i,0])
					translate([-(l_arm-d_arm)/2+i*(l_arm-d_arm),max(d_arm,d_hand)/2+1,0])
							rotate([0,0,180*i])
							arm_cylindrical_shaft (	arm=arm,
													hand=hand,
													pin=pin,				
													play=play,
													resolution=resolution);
				}
		}
	else{
	if(oblobot==BADGES){
		color("gold")
		badge_family_compact_shaft (	units=badgeunits,
                                        badge=[d_badge,h_badge,n_badge],
                                        pin=pin,
                                        play=play);
		}


}
}
}
}
}
}
}
