// Oblobot quadrangle shaft [OBLOBOTS] v.12
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
				// 	"ASSEMBLED" -> Modelo unido 
				// 	"EXPLOSION" -> Modelo separado
				// 	"PRINTING"  -> Todas las piezas apoyadas en el plano xy

// FORMAS
// CABEZA
head=[45,30,20];			// [ acho cara (x),fondo (y), altura (z) ] Medidas de la Cabeza
brain=[12,5];				// [h,borde] Pared de la cabeza si es el caso
E=3;						// Tipo de ojo:	0 -> Sin ojo
						//				1 -> hueco circ rebajado
						//				2 -> cono interior
						//				3 -> cono ciego
eye=[10,5,2];			// [d,h] medidas de los ojos
eye_expression=[15,70];	// [exp1,exp2] expresion de los ojos
eye_position=[60,20];		// [sep, altura]

// TRONCO
neck=[22,20,1];		// [ d1,d2,h ] medidas del cuello
trunk=[50,28,50];		// [ pecho(x), fondo(y) , altura(z) ] Medidas del tronco
shoulder=[1,0,0];		// Tipo de hombro en el tronco (solo importa el 1er valor):	1 -> 3 chaflanes	
					//														2 -> 4 chaflanes

// BRAZOS
arm=[24,8,2,75];		// [ fondo (y), grosor(x), axila (x), longitud(z) ] Medidas de los Brazo
hand=[22,5,6];		// [d, grosor, nº lados] medidas de las manos

// CADERA Y PIERNAS
waist=[25,20,1];		// [ d1,d2,h] Cintura
hip=[45,23,18,8];		// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
leg=[12,25,90];		// [ long, dist] long incluyendo pie, factor de separación entre piernas
foot=[35,6];			// [ long, h ] Medidas de los pies

// ESCUDOS
badgeunits=[1,2,3];	// cada nº define un tipo de escudo. A tantos números tantos escudos
badge=[24,2,2,7];	// [ diámetro del escudo, h de la base , -, número de lados del polígono]
badgeposition=[5,0];	// [ dist al borde supeiror, rotación ]

// UNIONES ENTRE PARTES
pin=DOWEL_6;			// 
play=0;
resolution=8;		//


// Ejemplos

rotate([0,0,180])
oblobot_quadrangle_shaft(	head=head,
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


// mÓDULO

module oblobot_quadrangle_shaft (
		head=[3,40,55],			// [ acho cara (x),fondo (y), altura (z) ] Medidas de la Cabeza
		brain=[4,3],				// [h,borde] Pared de la cabeza si es el caso
		E=1,						// Tipo de ojo:	0 -> Sin ojo
								//				1 -> hueco circ rebajado
								//				2 -> cono interior		
								//				3 -> cono ciego
		eye=[18,5,2],			// [d,h] medidas de los ojos
		eye_expression=[15,70],	// [exp1,exp2] expresion de los ojos
		eye_position=[10,70],		// [sep, altura]
		shoulder=[1,0,0],		// Tipo de hombro en el tronco (solo importa el 1er valor)	1-> 3 chaflanes	/ 2 -> 4 chaflanes
		trunk=[45,25,40],		// [ pecho(x), fondo(y) , altura(z) ] Medidas del tronco
		neck=[30,20,3],		// [ d1,d2,h ]				
		arm=[8,18,2,65],		// [ fondo (y), grosor(x), axila (x), longitud(z) ] Medidas de los Brazo
		hand=[25,6,8],		// [d, grosor, nº lados] medidas de las manos
		hip=[33,23,30,6],		// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
		waist=[30,25,2],		// [ d1,d2,h ] Cintura
		leg=[35,100],		// [ long, dist] long incluyendo pie, factor de separación entre piernas
		foot=[37,3],			// [ long, h ]
		badgeunits=[1,2,3],	// cada nº define un tipo de escudo. A tantos números tantos escudos
		badge=[20,2.5,5],		// [ diámetro del escudo, h de la base, nº de lados	]
		badgeposition=[5,0],	// [ dist al borde supeiror, rotación ]
		pin=DOWEL_6,				// 
		play=0,					// factor de corrección del pin o del PF. Negativo resta, positivo suma
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
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);					// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);					// longitud del pin

//
x_head=lim(x_head_minmax[0],head[0],x_head_minmax[1]);
y_head=lim(y_head_minmax[0],head[1],y_head_minmax[1]);
z_head=lim(z_head_minmax[0],head[2],z_head_minmax[1]);		

//
x_trunk=lim(x_trunk_minmax[0],trunk[0],x_trunk_minmax[1]);
y_trunk=lim(d_pin+1+x_trunk/5,trunk[1],y_trunk_minmax[1]);
z_trunk=lim(z_trunk_minmax[0],trunk[2],z_trunk_minmax[1]);
//trunklim=[trunkx,trunky,trunkz];

T=shoulder[0];

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);
n_badge=lim(n_badge_minmax[0],badge[3],n_badge_minmax[1]);

q_badges=len(badgeunits);
limit_badge=[d_badge,h_badge,n_badge];

//
x_arm=lim(x_arm_minmax[0],arm[1],x_arm_minmax[1]);
y_arm=lim(y_arm_minmax[0],arm[0],y_arm_minmax[1]);
armpit=lim(armpit_minmax[0],arm[2],armpit_minmax[1]);			// medida de la axila

d_hand=lim(d_hand_minmax[0],hand[0],d_hand_minmax[1]);
h_hand=lim(h_hand_minmax[0],hand[1],x_arm-0.5);
n_hand=lim(n_hand_minmax[0],2*floor(hand[2]/2),n_hand_minmax[1]);

z_arm=lim(y_arm+5+d_hand,arm[3],z_arm_minmax[1]);
//armlim=[army,armx,arml];

//
d_leg=lim(d_leg_minmax[0],leg[0],d_leg_minmax[1]);	
h_leg=lim(h_leg_minmax[0],leg[1],h_leg_minmax[1]);	
legsposition=lim(legsposition_minmax[0],leg[2],legsposition_minmax[1]);
limit_leg=[d_leg,h_leg,n_badge,legsposition];

//
x_hip=lim(x_hip_minmax[0],hip[0],x_hip_minmax[1]);
y_hip=lim(y_hip_minmax[0],hip[1],y_hip_minmax[1]);
z_hip=lim(z_hip_minmax[0],hip[2],z_hip_minmax[1]);
//hiplim=[hipx,hipy,hipz,hip[3]];

//
d1_neck=lim(d_pin,neck[0],min(x_trunk,y_trunk));
d2_neck=lim(d_pin,neck[1],d1_neck);
h_neck=lim(h_neck_minmax[0],neck[2],h_neck_minmax[1]);
limit_neck=[d1_neck,d2_neck,h_neck,4];

//
d1_waist=lim(d_pin,waist[0],min(x_hip,y_hip));
d2_waist=lim(d_pin,waist[1],d1_waist);
h_waist=lim(h_waist_minmax[0],waist[2],h_waist_minmax[1]);
limit_waist=[d1_waist,d2_waist,h_waist,4];


// Variables para posicionar las partes en las diferentes representaciones
Z_trunk_assembled=h_leg+z_hip+h_waist;
Z_head_assembled=Z_trunk_assembled+z_trunk+h_neck;


// POSICIÓN DE LAS PARTES 

if(oblobot==ALL){

// Cabeza
translate([((x_head+x_trunk)/2+gap)*representation[0],-((z_arm+y_head)/2+gap)*representation[0],representation[1]*Z_head_assembled+representation[2]*(2*q_explosion+h_pin+10)])
	head_quadrangle_shaft(	head=head,
							brain=brain,
							E=E,	
							eye=eye,
							eye_expression=eye_expression,
							eye_position=eye_position,
							pin=pin,
							play=play);

// Tronco y brazos
translate([0,0,representation[1]*Z_trunk_assembled+representation[2]*(q_explosion+h_pin+10)])
trunkandarms_quadrangle_shaft (		T=T,	
                                    trunk=trunk,
                                    arm=arm,
                                    hand=hand,
                                    pin=pin,	
                                    neck=limit_neck,	
                                    badge=limit_badge,		 
                                    badgeposition=badgeposition,
                                    badgeunits=badgeunits,
                                    play=play,
                                    resolution=resolution,
                                    representation=representation[3]);


// Cadera y piernas
translate ([0,-((y_trunk+y_hip)/2+gap)*representation[0],0])
	hipandlegs_quadrangle_shaft ( 	hip=hip,	
                                    pin=pin,
                                    waist=limit_waist,
                                    leg=limit_leg,
                                    foot=foot,	
                                    play=play,
                                    resolution=resolution,
                                    representation=representation[3]);

if(representation[3]==2){
	color([1,0,0,0.5])
	translate([0,-30,-2.5])
		cube([200,200,5],center=true);
}
}

else{
	if(oblobot==LEGS){
		color("gold")
		legs_quadrangle_shaft(		x_hip=x_hip,
									leg=limit_leg,
									pin=pin,
									foot=foot,
									play=play,		
									resolution=resolution,
									angle=0	);



		}
	else{
	if(oblobot==HIP){
		color("gold")
		hip_quadrangle_shaft(	hip=hip,	
                                pin=pin,
                                waist=limit_waist,
                                legsposition=legsposition,	
                                play=play,
                                resolution=resolution);
		}
	else{
	if(oblobot==TRUNK){
		color("gold")
		for(i=q_badges-1){
		if(badgeunits[0]==0&&badgeunits[i]==0){
			trunk_quadrangle_shaft(	trunk=trunk,	
									T=T,	
									pin=pin,	
									neck=neck,	
									play=play,
									resolution=resolution);
			}
		else{
			trunk_badge_quadrangle_shaft(	trunk=trunk,	
                                            T=T,	
                                            pin=pin,	
                                            neck=neck,	
                                            badge=limit_badge,		 
                                            badgeposition=badgeposition,
                                            play=play,
                                            resolution=resolution);
			}
	}}
	else{
	if(oblobot==HEAD){
		color("gold")
			head_quadrangle_shaft(	head=head,
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
					translate([-(z_arm-y_arm)/2+i*(z_arm-y_arm),max(y_arm,d_hand)/2+3,0])
							rotate([0,0,180*i])
								arm_quadrangle_shaft (	arm=arm,
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
								pin=pin);
		}


}
}
}
}
}
}
}



