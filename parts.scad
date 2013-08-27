//////////////////////////////////////////////////////////////////////////////////////////////////
// parts [OBLOBOTS] 
// v.00 
// partes que estarán integradas en los volúmnese
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) - (@makespacemadrid) Ago 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license ???
//////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
////////////////////// CONOS /////////////////////////

// --- Cono truncado ciego
module blindcone (d=18	// diámetro del cono
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

// -------------- Fin de los módulos de conos ---------------------
// --------------------------------------------------------------------

////////////////////////////////////////////////
/////////////////// PIRÁMIDES //////////////////

// --- Piramide circunscrita en un círculo definido en las variables
module pyramid_C (	n=4,			// nº lados de la base de la pirámide	
					d1=20,		// diámetro del círculo-base donde se inscribe la pirámide
					d2=0,		// diámetro del círculo-punta donde se inscribe la pirámide
					h=10			// altura de la pirámide
					){

rotate([0,0,180/n])
	cylinder (r1=d1/2/cos(180/n), r2=d2/2/cos(180/n), h=h, $fn=n);
}

// -------------- Fin de los módulos de pirámides ---------------------
// ------------------------------------------------------------------------

/////////////////////////////////////////////////////////
////////// MÓDULOS PARA ALOJAR LEDS  ////////////////////

// Cono truncado hueco. Funciona como alojamiento para un led
module ledsocket (	ledn=5,		// Valor nominal del led
					h=4			// altura del cono						
					){
$fn=50;
hi=1.2;
edge=1;					// borde del ojo
ledr=ledn+1;
socket=ledr+1;
lash=socket+2*edge;
fring=1;					// factor que define la falda del cono 1=45º
ring=lash+2*h*fring;

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
}


// Cono truncado hueco. Funciona como alojamiento para un led
module ledsocket_exp(	ledn=5,		// Valor nominal del led
					h=4,			// altura del cono
					exp1=-25,	// [-45:45]	factor para la expresión
					exp2=50		// [1:100]	factor para la expresión
					){
$fn=50;
hi=1.2;
ledr=ledn+1;
socket=ledr+1;
edge=1;							// borde del ojo
lash=socket+2*edge;
fring=1;							// factor que define la falda del cono 1=45º
ring=lash+2*h*fring;

eyer2=socket+2*edge;				// Variable auxiliar
eyer1=eyer2+2*h*fring;			// Variable auxiliar

cut=((eyer1-eyer2)/2)*exp2/100;		// Variable auxiliar

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

// -------------- Fin de los módulos para alojar leds ---------------------
// ------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////


blindcone (d=25);	
translate ([0,30,0])
	blindcone (d=12);	
translate ([0,60,0])
	blindcone (d=30);	

translate ([40,0,0])
	pyramid_C (n=6,d1=20,d2=10,h=10);
translate ([40,30,0])
	pyramid_C (n=4,d1=30,d2=0,h=20);
translate ([40,60,0])
	pyramid_C (n=5,d1=23,d2=5,h=34);
					
translate ([-40,0,0])
	ledsocket_exp (ledn=5,h=6,exp1=-45,exp2=20);
translate ([-40,30,0])
	ledsocket_exp (ledn=5,h=4,exp1=25,exp2=40);
translate ([-40,60,0])
	ledsocket_exp (ledn=5,h=2,exp1=0,exp2=100);
