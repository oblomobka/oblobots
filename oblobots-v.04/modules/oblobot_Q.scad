//////////////////////////////////////////////////////////////////////////////////////////////////
// OBLOBOT Q [OBLOBOTS] 
// Construido con elementos cúbicos y de formas rectas
// v.04 
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Sep 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

use <botparts/plus/union.scad>
use <botparts/plus/parts.scad>

use <botparts/head.scad>
use <botparts/trunk.scad>
use <botparts/hipandlegs.scad>
use <botparts/arm.scad>

//-----------------------------------------------------------------
//-- medidas de los botones automáticos
//-- Cada código corresponde a las medidas de un modelo concreto

XXX= [ xx,xx,xx,xx,xx,xx ];		// [ 	diametro hembra,
								//		espesor hembra,
								//		diámetro alojamiento en hembra (aparece en los botones para coser),
								//		saliente del alojamiento en hembra (aparece en los botones para coser),
								//		diámetro macho,
								//		espesor macho	]

PON = [11.7,2.35,0,0,11.7,1.6 ];	// marca desconocida, encontrado en Pontejos (Madrid)
PRY = [11,2.2,0,0,11,2.0];		// marca PRYM - 10 mm
COS11 = [10,1.3,3.5,3,9.6,0.7];	// marca PRYM - Snap fasteners 11mm


//--------------------------------------------------------------------
//-- expresión de los ojos
//-- cadena de valores que representan las diferentes variables que definen la forma y colocación de los ojos

XXXXX=[xx,xx,xx,xx,xx];			// [	diámetro del ojo (tipo 1 y 3),
								//	lo que sobresale el ojo (tipo 2),
								//	separacion entre ojos (valor entre 0 y 100),	
								//	inclinación de las cejas,
								//	marca de las cejas (valor entre 0 y 100)]

ENFADADO=[15,3,40,45,30];
NEUTRO=[8,3,40,0,100];
DESCONFIADO=[12,3,60,0,20];


////////////////// PARÁMETROS /////////////////////////////

//--------------------------------------------------------
// ---- Presentación --------------------------------------

explote=1;			// 0 -> Modelo unido || 1 -> Modelo separado


//-----------------------------------------------------------
//---------------- Formas -----------------------------------

H=1;					// Tipo de cabeza:	1 -> cerrada. Con tres tipos de ojos (E)
					//					2 -> abierta. Con ojos para alojar leds de 5 mm

head=[26,20,45];		// [ acho cara (x),fondo (y), altura (z) ] Medidas de la Cabeza

E=1;					// Tipo de ojo:	1 -> hueco rebajado
					//				2 -> alojamiento para led 5mm
					//				3 -> cono ciego
eyes=[10,0,25,12,70];	// Expresión de los ojos	

T=1;					// Tipo de hombro en el tronco:	1 -> 3 chaflanes	
					//								2 -> 4 chaflanes
trunk=[37,24,30];		// [ pecho(x), fondo(y) , altura(z) ] Medidas del tronco 

arm=[9,14,52];		// [ grosor(x), fondo(y), longitud(z) ] Medidas de los Brazo
hip=[35,20,14,1];		// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
legs=[10,21,33,90];	// [ diámetro, longitud pierna, longitud pie, sepración entre piernas ] Dimensiones pierna y posición

B=3; 				// tipo de escudo:	1 -> punta cilindrica
					//					2 -> punta esférica
					//					3 -> anillo
badge=[24,50,3];		// [ diámetro del escudo, número de lados del polígono, distancia al borde superior del tronco

buttontyp=COS11;		// Tipo de botón automático. [ diametro H, espesor H, d centro H, saliente H, diámetro M, espesor M]
	


// -------------- Fin de los Parámetros ----------------------------------
// ------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

oblobotQ_01(	H=H,
			head=head,

			E=E,
			eyes=eyes,

			T=T,
			trunk=trunk,
			
			arm=arm,

			hip=hip,
			legs=legs,

			B=B,
			badge=badge,
			
			buttontyp=buttontyp,
			explote=explote
			);



///////////////////////////////////////////////////
////////// Módulo oblobotQ_01() ///////////////////
///////////////////////////////////////////////////

module oblobotQ_01 (	H=1,					//  Tipo de cabeza:	1 -> cerrada. Con tres tipos de ojos (E)
										//					2 -> abierta. Con ojos para alojar leds de 5 mm
					head=[26,26,26],		// [ acho cara (x),fondo (y), altura (z) ] Medidas de la Cabeza
					E=1,					// Tipo de ojo:	1 -> hueco rebajado
										//				2 -> alojamiento para led 5mm
										//				3 -> cono ciego
										// (sólo es útil si H=1)
					eyes=[10,3,40,45,30],	// Valores para la expresión de los ojos
										// [	diámetro del ojo (tipo 1 y 3),
										//	lo que sobresale el ojo (tipo 2),
										//	separacion entre ojos (valor entre 0 y 100),
										//	inclinación de las cejas,
										//	marca de las cejas (valor entre 0 y 100)]
					T=1,					// Tipo de hombro en el tronco:	1 -> 3 chaflanes	
										//								2 -> 4 chaflanes
					trunk=[45,25,40],		// [ pecho(x), fondo(y) , altura(z) ] Medidas del tronco				
					arm=[10,16,55],		// [ grosor(x), fondo(y), longitud(z) ] Medidas de los Brazo
					hip=[33,23,30,6],		// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
					legs=[10,20,35,95],	// [ diámetro, long pierna, long pie, separación entre piernas ] medidas piernas y posición

					B=1,					// tipo de escudo:	1 -> punta cilindrica
										//					2 -> punta esférica
										//					3 -> anillo
					badge=[20,5,3],		// [ 	diámetro del escudo, 
										//		número de lados del polígono, 
										//		distancia al borde superior del tronco	]

					buttontyp=COS11,		// tipo de botón automático
					explote=0			// 0 -> Modelo unido || 1 -> Modelo separado		
					){

// ---- Presentación

qexp=36;		// Distancia que se desplazan las partes del cuerpo en el modo explosión


////////////////// PARÁMETROS /////////////////////////////

// --- Cabeza y ojos

ht=2;		// grosor de la pared de la cabeza

ed=eyes[0];		// Diámetro ojo (para tipos 1 y 3)
eh=eyes[1];		// lo que sobresale el ojo (para el tipos 2)
eb=eyes[2];		// [0:100] factor de separación entre ojos. Mayor valor -> Mayor separación

exp1=eyes[3];	// [-45:45] factor de expresión de los ojos (para tipo 2 y 4)
exp2=eyes[4];	// [0:100] factor de expresión de los ojos (para tipo 2 y 4)




	// --- Union Cabeza<->Tronco
	ud1=12;			//diámetro del pin
	uh1=15;			//altura del pin

	// --- Cuello
	nd=ud1+2;		//diámetro del cuello
	nh=10;			//altura del cuello
	nn=badge[1];			//nº de lados del cuello


// --- Tronco y hombros
trx=trunk[0];			// medida del tronco: ancho
try=trunk[1];			// medida del tronco: fondo
trz=trunk[2];			// medida del tronco: alto

									

	// --- Union Tronco<->Brazos
	ud2=8;			//diámetro del pin
	uh2=15;			//altura del pin


// --- Brazos
ax=arm[0];			// medida del brazo: grosor
ay=arm[1];			// medida del brazo: fondo
az=arm[2];			// medida del brazo: longitud
an=8;			// [4,6,8,10,12] nº de lados del polígono de la mano


// --- Cadera y Piernas
hipx=hip[0]; 		// medida de la cadera: ancho
hipy=hip[1];			// medida de la cadera: fondo
hipz=hip[2];			// medida de la cadera: alto
hipb=hip[3];			// medida de la cadera: chaflán


	// --- Union Piernas<->Cadera
	legd=legs[0];		// medida de la pierna: grosor || También diámetro del pin que entra en la cadera
	c=0;					// correción (puede ser necesario para ajustar el pin al drill)
	legdrill=legd+c;		// diametro del taladro (define el alojamiento de las piernas)

legh=legs[1];			// medida de la pierna: longitud
legp=nn;					// nº de lados de las piernas

foot=legs[2];			// medida del pie: longitud

legb=legs[3];			// [0:100] factor de separación entre piernas

	// --- Union Tronco<->Cadera
	ud3=ud1;			//diámetro del pin
	uh3=uh1;			//altura del pin

	// --- Cintura
	wd=ud3+7;		//diámetro de la cintura
	wh=4;			//altura de la cintura
	wn=badge[1];		//nº de lados de la cintura

// --- escudo
			
bd=max(20,badge[0]);					// diámetro del escudo. Mínimo 20 mm
bb=badge[2];							// distancia del escudo a borde superior del tronco

bdr=min(bd,min(trx-2*bb),trz-2*bb);	// diámetro real del escudo. Depende de las dimensiones del cuerpo


// ------ POSICIÓN DE LAS PARTES ----------

// Cabeza
color("yellow")
translate([0,0,trz+nh+qexp*explote])
	if(H==2){
		drill3(d=ud1,h=uh1)
			headQ_hollow (hs=head,ht=ht,ed=ed,eh=eh,exp1=exp1,exp2=exp2,eb=eb);
				}
		else{		
			if(H==1&&E==2){
				drill3(d=ud1,h=uh1)
					headQ (hs=head,ht=ht,E=E,ed=ed,eh=eh,exp1=exp1,exp2=exp2,eb=eb);
				}
			else{
				difference(){
					headQ (hs=head,ht=ht,E=E,ed=ed,eh=eh,exp1=exp1,exp2=exp2,eb=eb);
					drill2(d=ud1,h=uh1);	
					}
				}
		}

// Cuerpo
color("green")
difference(){	
	union(){
		trunkQ (tr=trunk,T=T);
		translate([0,0,trz])	
			pin2(d=ud1,h=uh1,db1=nd+3,db2=nd,hb=nh,n=nn,k=0.5,s=0.1);
		}
	// hembras para los brazos
	for(i=[-1,1]){
		if(T==1){
			translate([-i*(trx/2+trx/10),0,trz-max(24,trz/2)/2+trx/20])
				rotate([0,i*90,0])
					drill2(d=ud2,h=uh2);	
			}	
		else{
			if(T==2){
				translate([-i*(trx/2+trx/10),0,trz-max(24,trz/2)/2])
					rotate([0,i*90,0])
						drill2(d=ud2,h=uh2);	
				}
			}
		}
	// decoración del pecho
	translate([0,-try/2,trz-bdr/2-bb])
		rotate([-90,0,0])
			translate([0,0,-0.05])
				badge_f(d=bdr,n=nn,h=3,button=1,typ=buttontyp);
	drill2(d=ud3, h=uh3);
	}

// escudo
translate([0,-try/2-qexp*explote,trz-bdr/2-bb])
	rotate([-90,0,0])
		translate([0,0,-0.05])
			badge_m(B=B,d=bdr-0.5,n=nn,h=2.6,button=1,typ=buttontyp);


// Brazos
color("orange")
for(i=[0,180]){
	mirror([i,0,0])
		if(T==1){
			translate([(trx/2+trx/10)+qexp*explote,0,trz-max(24,trz/2)/2+trx/20])
				union(){		
					rotate([0,90,0])
						armQ(arm=arm,an=an);	
					rotate([0,-90,0])
						pin2(d=ud2,h=uh2,k=0.3,s=0.3);
					}	
				}	
		else{
			if(T==2){
				translate([(trx/2+trx/10)+qexp*explote,0,trz-max(24,trz/2)/2])
					union(){		
						rotate([0,90,0])
							armQ(arm=arm,an=an);	
						rotate([0,-90,0])
							pin2(d=ud2,h=uh2,k=0.3,s=0.3);
						}
				}
			}
	}

// Cadera y piernas
translate([0,0,-wh])
	union(){
		// cadera
		color("red")
		translate([0,0,-qexp*explote])
			union(){
				hipQ(hip=hip,legdrill=legdrill,legb=legb);
				pin2(d=ud3,h=uh3,db1=wd,db2=wd,hb=wh,n=wn,k=0.5,s=0.1);
				}

	// piernas
		color("red")
		translate([0,0,-hipz-2*qexp*explote])
			legsQ(legd=legd,legh=legh,legp=legp,hipx=hipx,legb=legb,foot=foot);
	}

}

// --- Fin del módulo oblobotQ_01 () ----------------------

