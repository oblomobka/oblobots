//////////////////////////////////////////////////////////////////////////////////////////////////
// OBLOBOT MODEL ONE[OBLOBOTS] 
// 
// v.06 
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Oct 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <modules/botparts/plus/external_elements.scad>
include <modules/botparts/plus/presets.scad>
include <modules/botparts/plus/translate.scad>

use <modules/botparts/plus/functions.scad>
use <modules/botparts/plus/union.scad>
use <modules/botparts/plus/parts.scad>

use <modules/botparts/head.scad>
use <modules/botparts/leg.scad>
use <modules/botparts/hip.scad>
use <modules/botparts/trunk.scad>
use <modules/botparts/arm.scad>
use <modules/botparts/trunkandarms.scad>
use <modules/botparts/hipandlegs.scad>

use <modules/oblobot_quadrangle.scad>
use <modules/oblobot_cylindrical.scad>


////////////////// PARÁMETROS /////////////////////////////

//--------------------------------------------------------
// ---- Presentación --------------------------------------

oblobot=ALL;						// "ALL"
								// "LEGS"
								// "HIP"
								// "TRUNK"
								// "ARMS"
								// "HEAD"
								// "BADGES"

representation=EXPLOSION;			// "ASSEMBLED" -> Modelo unido 
								// "EXPLOSION" -> Modelo separado
								// "PRINTING"  -> Todas las piezas apoyadas en el plano xy

//////////////////////////////////////////////////////////////////////////////////////////////////////

// TIPO DE OBLOBOT		// -------- Q ---	-----				// -------- C --------
TYP=Q;					// Formas prismáticas					// Formas cilíndricas

// CABEZA				                      
H=1;						// 1 -> cerrada						// 1 -> cerrada
						// 2 -> abierta
head=[28,28,28];			// [x,y,z] 							// [d1,d2,h]
headt=4;					// pared								// pared

E=3;						// 1 -> hueco						// 1 -> hueco
						// 2 -> alojamiento led 5mm			// 2 -> alojamiento led 5mm
						// 3 -> cono 						// 3 -> cono
															// 4 -> hueco con borde			
eye=[18,5];				// [d,h] (inactivo si E=2)			// [d,h] (inactivo si E=2)
expression=[-25,42,50];	// [ang,ceño,separacion]				// [ang,ceño,separacion]

// TRONCO
neck=[18,12,2];			// [xy base, xy punta,h]				// [d1,d2,h]
trunk=[38,24,45];			// [x,y,z]							// [d1,d2,h]
shoulder=[1,2,3];			// [(1 ó 2),inactivo,inactivo]		// [d,d aux,ancho(x)]

// BRAZOS
arm=[18,10,2,65];			// [ancho(y),grosor(x),plus(x),long]	// [d,grosor(x),plus(x),long]
hand=[30,6,8];			// [d,grosor,n lados(4,6,8,10,12)]		// [d,grosor,ang(0<-->180)

// CADERA Y PIERNAS
waist=[15,15,1];			// [xy base, xy punta,h]				// [d1,d2,h]
hip=[37,22,17,8];			// [x,y,z,chaflán] 					// [d,h,factor(0<->100),inactivo]
legs=[35,100];			// [long,distancia relativa] 			// [long,distancia relativa] 
foots=[35,9];			// [long,h]							// [long,h]

// ESCUDOS
badgeunits=[3,2,1];		// cada nº define un tipo de escudo. A tantos números tantos escudos
badge=[20,2.5,2,6];		// [d,h base, inactivo, n lados]		// [d,h base,borde,n lados]
badgeposition=[4,180];	// [dist bordesup tronco,ang]			// [dist bordesup tronco,ang]
PFbadge=COS11;			// Tipo de botón automático			// Tipo de botón automático

// UNIONES ENTRE PARTES
PF=COS11;					// Si "NULL" -> pin[] activo // Si "COS11", "PON", "PRYM10" bottónautomático 
pin=[10,15,TABNORMAL];	// [d,h, presets de las pestaña] "SIMPLE","TABNORMAL","TABWIDE","TABFINE"
correction=0;			// factor de corrección del pin o del PF. Negativo resta, positivo suma	

//////////////////////////////////////////////////////////////////////////////////////////////////////////



if(TYP==Q || TYP==q){
oblobot_quadrangle(	H=H,
					head=head,
					headt=headt,

					E=E,
					eye=eye,
					expression=expression,

					neck=neck,
					trunk=trunk,
					shoulder=shoulder,
			
					arm=arm,
					hand=hand,

					waist=waist,
					hip=hip,
					legs=legs,
					foots=foots,

					badgeunits=badgeunits,
					badge=badge,
					badgeposition=badgeposition,
					PFbadge=PFbadge,
			
					PF=PF,
					pin=pin,
					correction=correction,

					representation=representation,
					oblobot=oblobot
					);
}
else{

if(TYP==C || TYP==c){
oblobot_cylindrical(	H=H,
					head=head,
					headt=headt,

					E=E,
					eye=eye,
					expression=expression,

					trunk=trunk,
					shoulder=shoulder,
					neck=neck,
			
					arm=arm,
					hand=hand,

					waist=waist,
					hip=hip,
					legs=legs,
					foots=foots,

					badgeunits=badgeunits,
					badge=badge,
					badgeposition=badgeposition,
					PFbadge=PFbadge,
			
					PF=PF,
					pin=pin,
					correction=correction,

					representation=representation,
					oblobot=oblobot
					);
	}
	else{
	translate([0,0,75])
		cube([40,40,150],center=true);
}
}

