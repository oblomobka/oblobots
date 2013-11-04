//////////////////////////////////////////////////////////////////////////////////////////////////
// OBLOBOT QUADRANGLE [OBLOBOTS] 
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
H=2;						// Tipo de cabeza:	1 -> cerrada. Con tres tipos de ojos (E)
						//					2 -> abierta. Con ojos para alojar leds de 5 mm
head=[35,28,40];			// [ acho cara (x),fondo (y), altura (z) ] Medidas de la Cabeza
headt=2;					// pared de la cabeza si es el caso

E=2;						// Tipo de ojo:	1 -> hueco rebajado
						//				2 -> alojamiento para led 5mm
						//				3 -> cono ciego
eye=[15,5];				// [d,h] medidas de los ojos
expression=[-25,42,50];	// [exp1,exp2,separacion] expresion de los ojos

// TRONCO
neck=[18,12,8];		// [ d1,d2,h ] medidas del cuello
trunk=[40,23,42];		// [ pecho(x), fondo(y) , altura(z) ] Medidas del tronco
shoulder=[1,0,0];		// Tipo de hombro en el tronco (solo importa el 1er valor):	1 -> 3 chaflanes	
					//														2 -> 4 chaflanes

// BRAZOS
arm=[15,10,3,60];		// [ fondo (y), grosor(x), axila (x), longitud(z) ] Medidas de los Brazo
hand=[18,7,4];		// [d, grosor, nº lados] medidas de las manos

// CADERA Y PIERNAS
waist=[18,25,2];		// [ d1,d2,h] Cintura
hip=[38,23,10,8];		// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
legs=[48,100];		// [ long, dist] long incluyendo pie, factor de separación entre piernas
foots=[35,6];			// [ long, h ] Medidas de los pies

// ESCUDOS
badgeunits=[1,2,3];	// cada nº define un tipo de escudo. A tantos números tantos escudos
badge=[20,2.5,0,8];	// [ diámetro del escudo, h de la base , -, número de lados del polígono]
badgeposition=[3,180];	// [ dist al borde supeiror, rotación ]
PFbadge=COS11;		// Botón automático del escudo

// UNIONES ENTRE PARTES
PF=NULL;					// Botón automático. Los modelos se definen en <botparts/plus/external_elements.scad>
pin=[10,15,TABNORMAL];	// [d,h] medidas del pin - También definen el taladro donde se aloja
correction=0;			// factor de corrección del pin o del PF. Negativo resta, positivo suma	


// -------------- Fin de los Parámetros ----------------------------------
// ------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

rotate([0,0,180])
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



///////////////////////////////////////////////////
////////// Módulo oblobot_quadrangle //////////////
///////////////////////////////////////////////////

module oblobot_quadrangle (
		H=1,					//  Tipo de cabeza:	1 -> cerrada. Con tres tipos de ojos (E)
							//					2 -> abierta. Con ojos para alojar leds de 5 mm
		head=[26,26,26],		// [ acho cara (x),fondo (y), altura (z) ] Medidas de la Cabeza
		headt=2,				// Pared de la cabeza si es el caso
		E=1,					// Tipo de ojo:	1 -> hueco rebajado
							//				2 -> alojamiento para led 5mm
							//				3 -> cono ciego
		eye=[10,5],			// [d,h] medidas de los ojos
		expression=[50,90,25],// [exp1,exp2,separacion] expresion de los ojos
		shoulder=[1,0,0],		// Tipo de hombro en el tronco (solo importa el 1er valor)	1-> 3 chaflanes	/ 2 -> 4 chaflanes
		trunk=[45,25,40],		// [ pecho(x), fondo(y) , altura(z) ] Medidas del tronco
		neck=[30,20,3],		// [ d1,d2,h ]				
		arm=[8,18,65],		// [ fondo (y), grosor(x), axila (x), longitud(z) ] Medidas de los Brazo
		hand=[25,6,8],		// [d, grosor, nº lados] medidas de las manos
		hip=[33,23,30,6],		// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
		waist=[30,25,2],		// [ d1,d2,h ] Cintura
		legs=[35,100],		// [ long, dist] long incluyendo pie, factor de separación entre piernas
		foots=[37,3],		// [ long, h ]
		badgeunits=[1,2,3],	// cada nº define un tipo de escudo. A tantos números tantos escudos
		badge=[20,2.5,5],		// [ diámetro del escudo, h de la base, nº de lados	]
		badgeposition=[5,0],	// [ dist al borde supeiror, rotación ]
		PFbadge=COS11,		// Tipo de botón automátco del escudo
		PF=NULL,				// tipo de botón automático
		pin=[10,15,SIMPLE],	// [d,h] medidas del pin - También definen el taladro donde se aloja
		correction=0,		// factor de corrección del pin o del PF. Negativo resta, positivo suma

		representation=ASSEMBLED,			
		oblobot=ALL
		){

// ---- Presentación

qexp=24;		// Distancia que se desplazan las partes del cuerpo en el modo explosión
matrix=40;
gap=10;

////////////////// PARÁMETROS /////////////////////////////


// Medidas con límites
pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin

//
headx=lim(20,head[0],80);			
heady=lim(20,head[1],80);			
headz=lim(20,head[2],80);			

//
trunkx=lim(20,trunk[0],90);
trunky=lim(20,trunk[1],90);
trunkz=lim(pinh+2,trunk[2],90);
trunklim=[trunkx,trunky,trunkz];

T=shoulder[0];

badgen=lim(4,badge[3],50);
badgelim=[badge[0],badge[1],badgen];

//
armx=lim(5,arm[1],25);				// medida del brazo: grosor
army=lim(pind+1,arm[0],40);			// medida del brazo: fondo
armpit=lim(0,arm[2],60);				// medida de la axila

handd=lim(10,hand[0],60);
handh=lim(3,hand[1],armx-0.5);
handnreal=lim(4,2*floor(hand[2]/2),12);

arml=lim(army+5+handd,arm[3],120);		// medida del brazo: longitud
armlim=[army,armx,arml];

//
legh=lim(20,legs[0],60);
legsposition=lim(0,legs[1],100);
leglim=[legh,badgen,legsposition];

//
hipx=lim(20,hip[0],80);
hipy=lim(15,hip[1],60);
hipz=lim(pin[1]+2,hip[2],50);
hiplim=[hipx,hipy,hipz,hip[3]];

//
neckd1=lim(5,neck[0],min(trunkx,trunky));
neckd2=lim(5,neck[1],neckd1);
neckh=lim(0,neck[2],20);
necklim=[neckd1,neckd2,neckh,4];

//
waistd1=lim(5,waist[0],min(hipx,hipy));
waistd2=lim(5,waist[1],waistd1);
waisth=lim(0,waist[2],20);
waistlim=[waistd1,waistd2,waisth,4];


// Variables para posicionar las partes en las diferentes representaciones
Z_trunk_assembled=legh+hipz+waisth;
Z_head_assembled=Z_trunk_assembled+trunkz+neckh;


// ------ POSICIÓN DE LAS PARTES ----------

if(oblobot==ALL){

// Cabeza
translate([((headx+trunkx)/2+gap)*representation[0],-((arml+heady)/2+gap)*representation[0],representation[1]*Z_head_assembled+representation[2]*(2*qexp+pinh+10)])
	head_union_quadrangle(	H=H,	
							head=head,
							headt=headt,	
							E=E,	
							eye=eye,
							expression=expression,	
							pin=pin,
							PF=PF,
							correction=correction);


// Tronco y brazos
translate([0,0,representation[1]*Z_trunk_assembled+representation[2]*(qexp+pinh+10)])
	trunkandarms_quadrangle (		T=T,	
								trunk=trunklim,
								arm=arm,
								hand=hand,
								pin=pin,	
								neck=necklim,	
								PF=PF,	
								correction=correction,
								badge=badgelim,		 
								badgeposition=badgeposition,
								badgeunits=badgeunits,
								PFbadge=PFbadge,
								representation=representation[3]);


// Cadera y piernas
translate ([0,-((trunky+hipy)/2+gap)*representation[0],0])
	hipandlegs_quadrangle(	hip=hiplim,
							pin=pin,	
							waist=waistlim,	
							legs=leglim,
							foots=foots,
							PF=PF,
							correction=correction,
							representation=representation[3]);

*if(representation[3]==2){
	color([1,0,0,0.5])
	translate([0,-30,-2.5])
		cube([200,200,5],center=true);
}
}

else{
	if(oblobot==LEGS){
		color("gold")
		legs_union_quadrangle(	hip=hipx,
								legs=leglim,
								pin=pin,
								foots=foots,
								PF=PF,
								correction=correction,
								angle=90	);
		}
	else{
	if(oblobot==HIP){
		color("gold")
		hip_union_quadrangle(	hip=hiplim,
								pin=pin,
								waist=waistlim,
								legsposition=legsposition,
								PF=PF,
								correction=correction);
		}
	else{
	if(oblobot==TRUNK){
		color("gold")
		trunk_badge_union_quadrangle(	trunk=trunklim,	
									T=T,	
									pin=pin,
									neck=necklim,
									PF=PF,
									correction=correction,
									badge=badgelim,
									badgeposition=badgeposition,
									PFbadge=PFbadge);
		}
	else{
	if(oblobot==HEAD){
		color("gold")
		head_union_quadrangle(	H=H,	
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
					translate([-(arml-army)/2+i*(arml-army),max(army,handd)/2+3,0])
							rotate([0,0,180*i])
								arm_union_quadrangle (	arm=arm,
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



