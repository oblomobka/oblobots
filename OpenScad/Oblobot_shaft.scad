// Oblobot shaft [OBLOBOTS] v.12
// (c) Jorge Medal (@oblomobka) 2015.09
// GPL license

include <2_helpers/external_elements.scad>
include <2_helpers/presets_oblobots.scad>
include <2_helpers/limits_oblobots.scad>

use <oblomobka/functions.scad>

use <OBLOBOTS_SHAFT/form_plus_union/head_shaft.scad>
use <OBLOBOTS_SHAFT/form_plus_union/leg_shaft.scad>
use <OBLOBOTS_SHAFT/form_plus_union/hip_shaft.scad>
use <OBLOBOTS_SHAFT/form_plus_union/trunk_shaft.scad>
use <OBLOBOTS_SHAFT/form_plus_union/arm_shaft.scad>
use <OBLOBOTS_SHAFT/form_plus_union/trunkandarms_shaft.scad>
use <OBLOBOTS_SHAFT/form_plus_union/hipandlegs_shaft.scad>
use <OBLOBOTS_SHAFT/form_plus_union/badges_shaft.scad>

use <OBLOBOTS_SHAFT/oblobot_quadrangle_shaft.scad>
use <OBLOBOTS_SHAFT/oblobot_cylindrical_shaft.scad>


// PARÁMETROS
// Presentación

oblobot=	ALL;					
		// 	"ALL"
		//	"LEGS"
		//	"HIP"
		//	"TRUNK"
		//	"ARMS"
		// 	"HEAD"
		//	"BADGES"

representation=	ASSEMBLED;		
			//	"ASSEMBLED" -> Modelo unido 
			// 	"EXPLOSION" -> Modelo separado
			// 	"PRINTING"  -> Todas las piezas apoyadas en el plano xy
    
// TIPO DE OBLOBOT		//  0			                    // 1 
TYP=0;					// Formas prismáticas					// Formas cilíndricas

// CABEZA				                      
head=[35,35,20];			// [x,y,z] 							// [d1,d2,h]
brain=[2,3];			// [altura,borde]						// [altura,borde]	

E=3;						//	0 -> Sin ojo						//	0 -> Sin ojo
						//	1 -> hueco circ rebajado			//	1 -> hueco circ rebajado
						//	2 -> cono interior				//	2 -> hueco circ con reborde
						//	3 -> cono ciego					//	3 -> cono ciego
eye=[14,5,2];			// 	[d,h,-]							// [d,h,reborde (para E=2)]
eye_expression=[-40,00];	// 	[exp1,exp2]
eye_position=[10,100];		// 	[sep, altura]

// TRONCO
neck=[44,20,4];			// [xy base, xy punta,h]				// [d1,d2,h]
trunk=[44,24,34];			// [x,y,z]							// [d1,d2,h]
shoulder=[1,2,5];		// [(1 ó 2),inactivo,inactivo]		// [d,d aux,ancho(x)]

// BRAZOS
arm=[22,9,3,70];			// [ancho(y),grosor(x),plus(x),long]	// [d,grosor(x),plus(x),long]
hand=[25,5,110];			// [d,grosor,n lados(4,6,8,10,12)]		// [d,grosor,ang(0<-->180)

// CADERA Y PIERNAS
waist=[44,15,1];			// [xy base, xy punta,h]				// [d1,d2,h]
hip=[44,24,0,1];			// [x,y,z,chaflán] 					// [d,h,factor(0<->100),inactivo]
leg=[13,37,100];			// [d,long,distancia relativa] 		// [d,long,distancia relativa] 
foot=[40,5];				// [long,h]							// [long,h]

// ESCUDOS
badgeunits=[1,2,3];		// cada nº define un tipo de escudo. A tantos números tantos escudos
badge=[20,2,1,4];			// [d,h base, inactivo, n lados]		// [d,h base,borde,n lados]
badgeposition=[3,0];		// [dist bordesup tronco,ang]			// [dist bordesup tronco,ang]

// UNIONES ENTRE PARTES
pin=PIPE_6;
play=0;					// Juego del pin (define lo holgado o apretado que entra el pin)
resolution=12;			//	Resolución del pin - 	Valores bajos para que e programa funcione mejor
						//						Valores altos para generar stl


$fn=50;

if(TYP == 0 || TYP == 0){
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
}
else{

if(TYP == 1 || TYP == 1){
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
                            leg=leg,//
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
	}
        else{
        translate([0,0,75])
            cube([40,40,150],center=true);
    }
}

