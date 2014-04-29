//////////////////////////////////////////////////////////////////////////////////////////////////
// presets [OBLOBOTS] 
// valores predeterminados para los volúmenes de un oblobot así como de los modos de represntación
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Oct 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

use <functions_oblomobka.scad>


//-- CARACTERÍSTICAS DEL PIN

SIMPLE=[0,0,0];					// cilindro 

	// Pestañas en pin con punta expandible
	tab_expansion=80;
	TABWIDE=[35,35,tab_expansion];
	TABNORMAL=[50,50,tab_expansion];
	TABFINE=[65,65,tab_expansion];

/////////////////////////////////////////////
/////// REPRESENTACIÓN //////////////////////
/////////////////////////////////////////////

//-- MODOS DE REPRESENTACIÓN DE LAS PARTES 

ASSEMBLED=[0,1,0,0];
EXPLOSION=[0,1,1,1];
PRINTING=[1,0,0,2];


//-- ELECCIÓN DE LA PARTE REPRESENTADA	

ALL=[0];
LEGS=[1];
HIP=[2];
TRUNK=[3];
HEAD=[4];
ARMS=[5];
BADGES=[6];

//-- COLORES

arms_color=[1,rands(100,200,1)[0]/255,0];
legs_color=[0,rands(100,200,1)[0]/255,1];
trunk_color=[rands(0,100,1)[0]/255,rands(150,225,1)[0]/255,rands(0,100,1)[0]/255];
head_color=[220/255,rands(0,100,1)[0]/255,20/255];
badges_color=[rands(0,255,1)[0]/255,rands(0,255,1)[0]/255,rands(0,255,1)[0]/255];
hip_color=[0,(rands(100,200,1)[0])/255,1];







