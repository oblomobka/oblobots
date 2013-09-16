//////////////////////////////////////////////////////////////////////////////////////////////////
// OBLOBOT Q typ01[OBLOBOTS] 
// Construido con elementos cúbicos y de formas rectas
// Las conexiones entre piezas van con pines que se expanden en la punta
// La unión del escudo al pecho se hace con un botón automático
// v.04 
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Sep 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

use <modules/oblobot_Q.scad>

//-----------------------------------------------------------------
//-- medidas de los botones automáticos
//-- Cada código corresponde a las medidas de un modelo concreto

XXX= [ xx,xx,xx,xx,xx,xx ];			// [ 	diametro hembra,
									//		espesor hembra,
									//		diámetro alojamiento en hembra (aparece en los botones para coser),
									//		saliente del alojamiento en hembra (aparece en los botones para coser),
									//		diámetro macho,
									//		espesor macho	]

PON = [11.7,2.35,0,0,11.7,1.6 ];	// marca desconocida, encontrado en Pontejos (Madrid)
PRY = [11,2.2,0,0,11,2.0];			// marca PRYM - 10 mm
COS11 = [10,1.3,3.5,3,9.6,0.7];		// marca PRYM - Snap fasteners 11mm


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

explote=0;			// 0 -> Modelo unido || 1 -> Modelo separado


//-----------------------------------------------------------
//---------------- Formas -----------------------------------

H=2;					// Tipo de cabeza:	1 -> cerrada. Con tres tipos de ojos (E)
						//					2 -> abierta. Con ojos para alojar leds de 5 mm

head=[38,26,26];		// [ acho cara (x),fondo (y), altura (z) ] Medidas de la Cabeza

E=1;					// Tipo de ojo:	1 -> hueco rebajado
						//				2 -> alojamiento para led 5mm
						//				3 -> cono ciego
eyes=[10,5,60,0,10];	// Expresión de los ojos	

T=2;					// Tipo de hombro en el tronco:	1 -> 3 chaflanes	
						//								2 -> 4 chaflanes
trunk=[32,24,38];		// [ pecho(x), fondo(y) , altura(z) ] Medidas del tronco 

arm=[7,15,50];			// [ grosor(x), fondo(y), longitud(z) ] Medidas de los Brazo
hip=[31,23,15,5];		// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
legs=[10,28,30,100];	// [ diámetro, longitud pierna, longitud pie, sepración entre piernas ] Dimensiones pierna y posición

B=3; 					// tipo de escudo:	1 -> punta cilindrica
						//					2 -> punta esférica
						//					3 -> anillo
badge=[20,7,5];			// [ diámetro del escudo, número de lados del polígono, distancia al borde superior del tronco

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

