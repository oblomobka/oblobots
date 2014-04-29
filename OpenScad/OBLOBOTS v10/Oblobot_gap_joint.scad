//////////////////////////////////////////////////////////////////////////////////////////////////
// OBLOBOT GAP
// joint gap
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) 2014 - v.10
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////


include <utilities/external_elements_oblobots.scad>
include <utilities/presets_oblobots.scad>
include <utilities/limits_oblobots.scad>

use <utilities/functions_oblomobka.scad>

use <OBLOBOTS gap/model/botparts/head_gap.scad>
use <OBLOBOTS gap/model/botparts/leg_gap.scad>
use <OBLOBOTS gap/model/botparts/hip_gap.scad>
use <OBLOBOTS gap/model/botparts/trunk_gap.scad>
use <OBLOBOTS gap/model/botparts/arm_gap.scad>
use <OBLOBOTS gap/model/botparts/trunkandarms_gap.scad>
use <OBLOBOTS gap/model/botparts/hipandlegs_gap.scad>
use <OBLOBOTS gap/model/botparts/badges_gap.scad>

use <OBLOBOTS gap/model/oblobot_quadrangle_gap.scad>
use <OBLOBOTS gap/model/oblobot_cylindrical_gap.scad>


////////////////// PARÁMETROS /////////////////////////////

//--------------------------------------------------------
// ---- Presentación --------------------------------------

oblobot=		ALL;					
		// 	"ALL"
		//	"LEGS"
		//	"HIP"
		//	"TRUNK"
		//	"ARMS"
		// 	"HEAD"
		//	"BADGES"

representation=	EXPLOSION;		
			//	"ASSEMBLED" -> Modelo unido 
			// 	"EXPLOSION" -> Modelo separado
			// 	"PRINTING"  -> Todas las piezas apoyadas en el plano xy

//////////////////////////////////////////////////////////////////////////////////////////////////////

// TIPO DE OBLOBOT		// -------- Q ---	-----				// -------- C --------
TYP=C;					// Formas prismáticas					// Formas cilíndricas

// CABEZA				                      
head=[28,35,35];			// [x,y,z] 							// [d1,d2,h]
brain=[5,3];			// [altura,borde]						// [altura,borde]	

E=1;						//	0 -> Sin ojo						//	0 -> Sin ojo
						//	1 -> hueco circ rebajado			//	1 -> hueco circ rebajado
						//	2 -> cono interior				//	2 -> hueco circ con reborde
						//	3 -> cono ciego					//	3 -> cono ciego
eye=[17,5,2];			// 	[d,h,-]							// [d,h,reborde (para E=2)]
eye_expression=[40,60];	// 	[exp1,exp2]
eye_position=[30,50];		// 	[sep, altura]

// TRONCO
neck=[20,20,4];			// [xy base, xy punta,h]				// [d1,d2,h]
trunk=[45,28,42];			// [x,y,z]							// [d1,d2,h]
shoulder=[20,2,5];			// [(1 ó 2),inactivo,inactivo]		// [d,d aux,ancho(x)]

// BRAZOS
arm=[20,8,3,80];			// [ancho(y),grosor(x),plus(x),long]	// [d,grosor(x),plus(x),long]
hand=[28,5,180];			// [d,grosor,n lados(4,6,8,10,12)]		// [d,grosor,ang(0<-->180)

// CADERA Y PIERNAS
waist=[25,18,1];			// [xy base, xy punta,h]				// [d1,d2,h]
hip=[45,22,80,1];			// [x,y,z,chaflán] 					// [d,h,factor(0<->100),inactivo]
leg=[13,52,100];			// [d,long,distancia relativa] 		// [d,long,distancia relativa] 
foot=[40,9];				// [long,h]							// [long,h]

// ESCUDOS
badgeunits=[1,2,3];		// cada nº define un tipo de escudo. A tantos números tantos escudos
badge=[20,2,2,50];			// [d,h base, inactivo, n lados]		// [d,h base,borde,n lados]
badgeposition=[3,0];		// [dist bordesup tronco,ang]			// [dist bordesup tronco,ang]

// UNIONES ENTRE PARTES
pin=PIPE_6;
play=0;					// Juego del pin (define lo holgado o apretado que entra el pin)
//resolution=12;			//	Resolución del pin - 	Valores bajos para que e programa funcione mejor
						//						Valores altos para generar stl

//////////////////////////////////////////////////////////////////////////////////////////////////////////

$fn=50;

if(TYP==Q || TYP==q){
oblobot_quadrangle(	head=head,
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

if(TYP==C || TYP==c){
oblobot_cylindrical(	head=head,
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

