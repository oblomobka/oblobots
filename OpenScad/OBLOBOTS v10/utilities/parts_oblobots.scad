//////////////////////////////////////////////////////////////////////////////////////////////////
// parts [OBLOBOTS] 
// partes que estarán integradas en los volúmenes
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) 2014-02 v.07
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license 
//////////////////////////////////////////////////////////////////////////////////////////////////

include <external_elements_oblobots.scad>
include <presets_oblobots.scad>

use <shapes_oblomobka.scad>
use <functions_oblomobka.scad>


// --- Geometría particular. Cono truncado ciego, falda 45º
module blindcone (d=50	// diámetro del cono
				){
$fn=50;

union(){
	difference(){
		cylinder (r1=d/2,r2=d/4,h=d/4);
		translate([0,0,(d/4-7*d/32)+0.1])
			cylinder (r1=0,r2=7*d/32,h=7*d/32);
		}
	cylinder (r1=7*d/32,r2=d/32,h=7*d/32);
	}
}

// ------- blindcone (d=d); -----------------

/////////////////////////////////////////////////////////
////////// MÓDULOS PARA ALOJAR LEDS  ////////////////////

// Cono truncado hueco. Funciona como alojamiento para un led, el led entra holgado

module ledsocket_simple (	ledn=5,				// Valor nominal del led
						h=4,					// altura del cono
						expression=[0,100]					
						){

$fn=50;

edge=1;							// borde del hueco
ledr=ledn+1;
socket=ledr+1;
lash=socket+2*edge;				// base del cono
fring=1;							// factor que define la falda del cono 1=45º
ring=lash+2*h*fring;

exp1=expression[0];				// [-45:45]	factor para la expresión
exp2=expression[1];				// [1:100]	factor para la expresión

eyer2=socket+2*edge;				// Variable auxiliar
eyer1=eyer2+2*h*fring;			// Variable auxiliar

cut=((eyer1-eyer2)/2)*exp2/100;	// Variable auxiliar

difference(){
	difference(){
		cylinder(r2=lash/2,r1=ring/2,h=h);
		cylinder(r=socket/2,h=3*h,center=true);
		}
	translate ([0,0,h/2])
		rotate ([0,0,exp1])
			translate ([0,eyer1/2+eyer2/2+0.5+cut,0])	
				cube ([eyer1,eyer1,eyer1],center=true);						
	}
}
// ------- ledsocket_simple (ledn=ledn,h=h,expression=[x,x]); -----------------


// Cono truncado hueco. Funciona como alojamiento para un led, el led entra a presión
module ledsocket_press (	ledn=5,				// Valor nominal del led
						h=4,					// altura del cono	
						expression=[0,100]					
						){
$fn=50;

hi=1.2;
edge=1;							// borde del ojo
ledr=ledn+1;
socket=ledr+1;
lash=socket+2*edge;				// base del cono
fring=1;							// factor que define la falda del cono 1=45º
ring=lash+2*h*fring;

exp1=expression[0];				// [-45:45]	factor para la expresión
exp2=expression[1];				// [1:100]	factor para la expresión

eyer2=socket+2*edge;				// Variable auxiliar
eyer1=eyer2+2*h*fring;			// Variable auxiliar

cut=((eyer1-eyer2)/2)*exp2/100;	// Variable auxiliar

difference(){
	difference(){
		cylinder(r2=lash/2,r1=ring/2,h=h);
		union(){
			cylinder(r2=ledr/2,r1=socket/2,h=hi+0.1);
			translate([0,0,hi])
				cylinder(r2=socket/2,r1=ledr/2,h=h-hi);
			translate([0,0,h-0.1])
				cylinder(r=socket/2, h=2);
			translate([0,0,-2])
				cylinder(r=socket/2, h=2.1);
			}
		}
	translate ([0,0,h/2])
		rotate ([0,0,exp1])
			translate ([0,eyer1/2+eyer2/2+0.5+cut,0])	
				cube ([eyer1,eyer1,eyer1],center=true);						
	}
}
// ------- ledsocket_press (ledn=ledn,h=h,expression=[x,x]); -----------------

// -------------- Fin de los módulos para alojar leds ---------------------
// ------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

i=40;

blindcone (d=25);	
translate ([0,i,0])
	blindcone (d=12);	
translate ([0,i*2,0])
	blindcone (d=21);	

translate ([i,0,0])
	pyramid_circumscribed (n=6,d1=20,d2=10,h=10);
translate ([i,i,0])
	pyramid_circumscribed (n=4,d1=22,d2=0,h=20);
translate ([i,i*2,0])
	prism_circumscribed (n=8,d=23,h=34);
				
translate ([-i,0,0])
	ledsocket_press (ledn=5,h=4,expression=[0,100]);
translate ([-i,i,0])
	ledsocket_simple (ledn=3,h=3,expression=[0,100]);
translate ([-i,i*2,0])
	ledsocket_press (ledn=5,h=6,expression=[45,20]);
translate ([-i,i*3,0])
	ledsocket_simple (ledn=5,h=4,expression=[-25,35]);


