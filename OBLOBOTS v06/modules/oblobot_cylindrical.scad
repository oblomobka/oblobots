//////////////////////////////////////////////////////////////////////////////////////////////////
// OBLOBOT CYLINDRICAL [OBLOBOTS] 
// Construido con elementos cúbicos y de formas rectas
// v.06 
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Oct 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <botparts/plus/external_elements.scad>
include <botparts/plus/presets.scad>

use <botparts/plus/functions.scad>
use <botparts/plus/union.scad>
use <botparts/plus/parts.scad>

use <botparts/head.scad>
use <botparts/leg.scad>
use <botparts/hip.scad>
use <botparts/trunk.scad>
use <botparts/arm.scad>
use <botparts/trunkandarms.scad>
use <botparts/hipandlegs.scad>


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

representation=ASSEMBLED;			// "ASSEMBLED" -> Modelo unido 
								// "EXPLOSION" -> Modelo separado
								// "PRINTING"  -> Todas las piezas apoyadas en el plano xy

//-----------------------------------------------------------
//---------------- Formas -----------------------------------

// CABEZA
H=1;						// Tipo de cabeza:	1 -> cerrada. Con tres tipos de ojos (E)
						//					2 -> abierta. Con ojos para alojar leds de 5 mm
head=[25,40,50];			// [ acho cara (x),fondo (y), altura (z) ] Medidas de la Cabeza
headt=3;					// pared de la cabeza si es el caso

E=4;						// Tipo de ojo:	1 -> hueco rebajado
						//				2 -> alojamiento para led 5mm
						//				3 -> cono ciego
						//				4 -> hueco rebajado con borde
eye=[15,5];				// [d,h] medidas de los ojos
expression=[10,40,100];	// [exp1,exp2,separacion] expresion de los ojos

// TRONCO
neck=[15,25,1];		// [ d1,d2,h ]
trunk=[45,35,45];		// [ d1, d2 , h ] Medidas del tronco 
shoulder=[22,5,4];	// [ d, aux d, ancho ] medidas de los hombros en en tronco

// BRAZOS
arm=[21,12,1,68];		// [ d hombro(y), grosor(x), axila (x), longitud(z) ] Medidas de los Brazo
hand=[20,7,180];		// [d, grosor, nº lados] medidas de las manos

// CADERA Y PIERNAS
waist=[50,30,6];		// [ d1,d2,h ] Cintura
hip=[45,18,80,0];		// [ d, h, f, - ] Medidas de la cadera
legs=[35,100];		// [ long, dist] long incluyendo pie, factor de separación entre piernas
foots=[35,10];		// [ long, h ] Medidas de los pies

// ESCUDOS
badgeunits=[1,2,3]; 		// cada nº define un tipo de escudo. A tantos números tantos escudos
badge=[20,2.5,2,8];		// [ diámetro del escudo, h de la base , borde, número de lados del polígono]
badgeposition=[5,45];	// [ dist al borde supeiror, rotación ]
PFbadge=COS11;			// Botón automático del escudo

// UNIONES ENTRE PARTES
PF=NULL;				// Botón automático. Los modelos se definen en <botparts/plus/external_elements.scad>
pin=[10,15,SIMPLE];	// [d,h,TAB] medidas del pin - También definen el taladro donde se aloja
correction=0;			// factor de corrección del pin o del PF. Negativo resta, positivo suma	


// -------------- Fin de los Parámetros ----------------------------------
// ------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

rotate([0,0,180])
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

///////////////////////////////////////////////////
////////// Módulo oblobot_cylindrical() ///////////
///////////////////////////////////////////////////

module oblobot_cylindrical (
		H=1,						//  Tipo de cabeza:	1 -> cerrada. Con tres tipos de ojos (E)
								//					2 -> abierta. Con ojos para alojar leds de 5 mm
		head=[26,26,26],			// [ acho cara (x),fondo (y), altura (z) ] Medidas de la Cabeza
		headt=2,					// Pared de la cabeza si es el caso
		E=1,						// Tipo de ojo:	1 -> hueco rebajado
								//				2 -> alojamiento para led 5mm
								//				3 -> cono ciego
		eye=[10,5],				// [d,h] medidas de los ojos
		expression=[50,90,25],	// [exp1,exp2,separacion] expresion de los ojos
		trunk=[45,25,40],			// [ pecho(x), fondo(y) , altura(z) ] Medidas del tronco	
		shoulder=[20,5,3],		// [ d, aux, h ]
		neck=[25,15,2],			// [ d1, d2, h ]		
		arm=[8,18,1,65],			// [ d hombro(y), grosor(x), axila (x), longitud(z) ] Medidas de los Brazo
		hand=[25,6,8],			// [ d, grosor, nº lados] medidas de las manos
		hip=[33,23,30,6],			// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
		waist=[25,15,2],			// [ d1, d2, h ]
		legs=[35,100],			// [ long, dist] long incluyendo pie, factor de separación entre piernas
		foots=[37,3],			// [ long, h ]
		badgeunits=[1,2,3],		// cada nº define un tipo de escudo. A tantos números tantos escudos
		badge=[20,2.5,5],			// [ diámetro del escudo, h de la base, nº de lados	]
		badgeposition=[5,0],		// [ dist al borde supeiror, rotación ]
		PFbadge=COS11,			// Tipo de botón automátco del escudo
		PF=NULL,					// tipo de botón automático
		pin=[10,15,TABNORMAL],	// [d,h] medidas del pin - También definen el taladro donde se aloja
		correction=0,			// factor de corrección del pin o del PF. Negativo resta, positivo suma
		representation=ASSEMBLED,	// 0 -> Modelo unido || 1 -> Modelo separado || 2 --> para imprimir
		oblobot=ALL,
		){

// ---- Presentación

qexp=24;		// Distancia que se desplazan las partes del cuerpo en el modo explosión
matrix=40;
gap=10;

////////////////// PARÁMETROS /////////////////////////////


// Medidas con límites
pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin
pinlim=[pind,pinh,pin[2]];

//
headh=lim(20,head[2],90);					
headd1=lim(20,head[0],60);				
headd2=lim(15,head[1],2*headh+headd1);				

//
td1=lim(20,trunk[0],70);	
td2=lim(20,trunk[1],td1); 
th=lim(24,max(pin[1]+2,trunk[2]),80);
trunklim=[td1,td2,th];

//
badged=lim(20,badge[0],35);	
badgeh=lim(1,badge[1],5);	
badgeb=lim(1,badge[2],6)	;
badgen=lim(4,badge[3],50);		
badgelim=[badged,badgeh,badgen];

//
armd=lim(pind+1,arm[0],40);	
armh=lim(5,arm[1],25);			
armpit=lim(0,arm[2],60);			

handd=lim(10,hand[0],60);
handh=lim(3,hand[1],armh-0.5);
handang=lim(0,hand[2]/2,180);	

arml=lim(armd+handd,arm[3],120);	
armlim=[armd,armh,armpit,arml];

//
legh=lim(20,legs[0],60);
legsposition=lim(0,legs[1],100);

//
hipd=lim(25,hip[0],80);
hiph=lim(pinh+2,hip[1],70);
hipf=lim(0,hip[2],100);
hiplim=[hipd,hiph,hipf];

//
neckd1=lim(5,neck[0],td2);
neckd2=lim(5,neck[1],neckd1);
neckh=lim(0,neck[2],20);
necklim=[neckd1,neckd2,neckh];

//
waistd1=lim(5,waist[0],hip[0]);
waistd2=lim(5,waist[1],waistd1);
waisth=lim(0,waist[2],20);
waistlim=[waistd1,waistd2,waisth];

// Variables para posicionar las partes en las diferentes representaciones
Z_trunk_assembled=legh+hiph+waisth;
Z_head_assembled=Z_trunk_assembled+th+neckh;


// ------ POSICIÓN DE LAS PARTES ----------

if(oblobot==ALL){

// Cabeza
translate([((max(headd1,headd2)+td1)/2+gap)*representation[0],-((arml+max(headd1,headd2))/2+gap)*representation[0],representation[1]*(Z_head_assembled)+representation[2]*(qexp+2*(pinh+10))])
	head_union_cylindrical(	H=H,	
							head=head,
							headt=headt,	
							E=E,	
							eye=eye,
							expression=expression,	
							pin=pin,
							PF=PF,
							correction=correction);


// Tronco y brazos
translate([0,0,representation[1]*(Z_trunk_assembled)+representation[2]*(qexp+pinh+10)])
	trunkandarms_cylindrical (	trunk=trunk,	
								shoulder=shoulder,
								arm=arm,
								hand=hand,
								pin=pin,	
								neck=necklim,	
								PF=PF,	
								correction=correction,
								badge=badge,		 
								badgeposition=badgeposition,
								badgeunits=badgeunits,
								PFbadge=PFbadge,
								representation=representation[3]);


// Cadera y piernas
translate ([0,-((td1+hipd)/2+gap)*representation[0],0])
	hipandlegs_cylindrical(	hip=hiplim,
							pin=pin,	
							waist=waistlim,	
							legs=legs,
							foots=foots,
							PF=PF,
							correction=correction,
							representation=representation[3]);

*if(representation[3]==2){
	color([1,0,0,0.5])
	translate([0,-40,-2.5])
		cube([200,200,5],center=true);
	}
}


else{
	if(oblobot==LEGS){
		color("gold")
		legs_union_cylindrical(	hip=hip,
								legs=legs,
								pin=pin,
								foots=foots,
								PF=PF,
								correction=correction,
								angle=90	);
		}
	else{
	if(oblobot==HIP){
		color("gold")
		hip_union_cylindrical(	hip=hip,
								pin=pin,
								waist=waistlim,
								legsposition=legsposition,
								PF=PF,
								correction=correction);
		}
	else{
	if(oblobot==TRUNK){
		color("gold")
		trunk_badge_union_cylindrical(	trunk=trunk,	
										shoulder=shoulder,	
										pin=pin,
										neck=necklim,
										PF=PF,
										correction=correction,
										badge=badge,
										badgeposition=badgeposition,
										PFbadge=PFbadge);
		}
	else{
	if(oblobot==HEAD){
		color("gold")
		head_union_cylindrical(	H=H,	
								head=head,
								headt=headt,	
								E=E,	
								eye=eye,
								expression=expression,	
								pin=pin,
								PF=PF,
								correction=correction);
		}
	else{
	if(oblobot==ARMS){
		for(i=[0,1]){
			color("gold")
				mirror([0,i,0])
					translate([-(arml-armd)/2+i*(arml-armd),max(armd,handd)/2+1,0])
							rotate([0,0,180*i])
								arm_union_cylindrical (	arm=arm,
														hand=hand,
														pin=pin,	
														PF=PF,				
														correction=correction);
				}
		}
	else{
	if(oblobot==BADGES){
		color("gold")
		badge_family_compact 	(	units=badgeunits,
								badge=badgelim,
								PF=PFbadge,		
								correction=0.1
								);
		}


}
}
}
}
}
}
}
