//////////////////////////////////////////////////////////////////////////////////////////////////
// external elements [OBLOBOTS] 
// librería de elementos externos comerciales (botones automáticos, espigas de madera baterías, ...) 
// que se usan en las partes de los oblobots
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) 2014-02
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

//-- BOTONES AUTOMÁTICOS - Press Fastener (PF)
//-- Cada código corresponde a las medidas de un modelo concreto

//XXX= [ xx,xx,xx,xx,xx,xx,xx ];		// [ 	diametro hembra,
									//		espesor hembra,
									//		diámetro alojamiento en hembra (aparece en los botones para coser),
									//		saliente del alojamiento en hembra (aparece en los botones para coser),
									//		diámetro macho,
									//		espesor macho	
									//		tipo]

NULL=[0,0,0,0,0,0,0];				// no hay botón automático 
//PON = [11.7,2.35,0,0,11.7,1.6 ];	// marca desconocida, encontrado en Pontejos (Madrid)
//PRYM10 = [11,2.2,0,0,11,2.0];		// marca PRYM - 10 mm
PRYM_SNAP_FASTENERS_11 = [10.1,1.4,3.5,3,9.1,1,2];	// marca PRYM - Snap fasteners 11mm
PRYM_SNAP_FASTENERS_9 = [8.5,1.5,3,2.7,8.1,1,2];	// marca PRYM - Snap fasteners 9mm

fit_male=0.7;

//-- Espigas de madera - DOWEL

DOWEL_8=[8,40,0,0,0,0,1];
DOWEL_6=[6,30,0,0,0,0,1];

//-- TUBOS DE PLÁSTICO

PIPE_6=[6,20,0,0,0,0,1];



//-- BATERÍAS CILÍNDRICAS

//XX= [ xx,xx ];		// [ 	diametro de la pila,
					//		longitud	de la pila	]

AA = [ 14.5, 50.5 ];
AAA = [ 10.5,44.5 ];
C = [ 26.2, 50 ];
D = [ 34.2, 61.5 ]; 
