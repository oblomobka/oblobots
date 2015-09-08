// presets [OBLOBOTS] v.02
// valores predeterminados para los volúmenes de un oblobot así como de los modos de representación
// (c) Jorge Medal (@oblomobka) 2015.09
// GPL license

// MODOS DE REPRESENTACIÓN DE LAS PARTES 

ASSEMBLED=[0,1,0,0];
EXPLOSION=[0,1,1,1];
PRINTING=[1,0,0,2];

// TIPO DE OBLOBOT

CUADRADO=0;
REDONDO=1;


// ELECCIÓN DE LA PARTE REPRESENTADA	
ALL=[0];
LEGS=[1];
HIP=[2];
TRUNK=[3];
HEAD=[4];
ARMS=[5];
BADGES=[6];

BODY=[7];
CAPS=[8];


// COLORES

arms_color=[1,rands(100,200,1)[0]/255,0];
legs_color=[0,rands(100,200,1)[0]/255,1];
trunk_color=[rands(0,100,1)[0]/255,rands(150,225,1)[0]/255,rands(0,100,1)[0]/255];
head_color=[220/255,rands(0,100,1)[0]/255,20/255];
badges_color=[rands(0,255,1)[0]/255,rands(0,255,1)[0]/255,rands(0,255,1)[0]/255];
hip_color=[0,(rands(100,200,1)[0])/255,1];

// Juego de holgura para los badges

play_d_badge=0.4;
play_h_badge=0.15;







