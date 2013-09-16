//////////////////////////////////////////////////////////////////////////////////////////////////
// parts [OBLOBOTS] 
// v.04 
// partes que estarán integradas en los volúmenes
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Sep 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license ???
//////////////////////////////////////////////////////////////////////////////////////////////////

use <union.scad>

//-- sizes Buttons

PON = [11.7,2.35,0,0,11.7,1.6 ];	// [ diametro H, espesor H, d centro H, saliente H, diámetro M, espesor M]
PRY = [11,2.2,0,0,11,2.0 ];		// [ diametro H, espesor H, d centro H, saliente H, diámetro M, espesor M]
COS11 = [10,1.3,3.5,3,9.6,0.7];	// [ diámetro H, espesor H, d centro H, saliente H, diámetro M, espesor M]

////////////////////////////////////////////////////////
////////////////////// VOLÚMENES /////////////////////////

// --- Cono truncado ciego falda 45º
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


// --- Piramide circunscrita en un círculo definido en las variables
module pyramid_C (	n=4,			// nº lados de la base de la pirámide	
					d1=20,		// diámetro del círculo-base donde se inscribe la pirámide
					d2=0,		// diámetro del círculo-punta donde se inscribe la pirámide
					h=10			// altura de la pirámide
					){

if(n%2==0){
rotate([0,0,180/n])
	cylinder (r1=d1/2/cos(180/n), r2=d2/2/cos(180/n), h=h, $fn=n);
}
else{
	rotate([0,0,90/n])
		cylinder (r1=d1/2/cos(180/n), r2=d2/2/cos(180/n), h=h, $fn=n);
}

}

// ------- pyramid_C (n=n,d1=d1,d2=d2,h=h); -----------------

// --- Prisma circunscrit0 en un círculo definido en las variables
module prism_C (	n=4,			// nº lados de la base del prisma
				d=20,		// diámetro del círculo donde se inscribe el prisma
				h=10			// altura del prisma
				){
if(n%2==0){
rotate([0,0,180/n])
	cylinder (r=d/2/cos(180/n), h=h, $fn=n);
}
else{
	rotate([0,0,90/n])
	cylinder (r=d/2/cos(180/n), h=h, $fn=n);
}

}

// ------- prism_C (n=n,d=d,h=h); -----------------


////////////////////////////////////////////////////////
////////////////////// DECORACIÓN /////////////////////////

module badge_f (	n=5,			// nº lados de la base de la pirámide	
				d=20,		// diámetro del círculo-base donde se inscribe la pirámide
				h=3,			// altura de la pirámide
				button=0,	// si =1 se construira un rebaje para un botón automático
				typ			// tipo de botón automático
				){
d2=d-2*h;

if(n%2==0){
	rotate([0,0,180/n])
		cylinder (r1=d/2/cos(180/n), r2=d2/2/cos(180/n), h=h, $fn=n);
	}
	else{
		rotate([0,0,90/n])
			cylinder (r1=d/2/cos(180/n), r2=d2/2/cos(180/n), h=h, $fn=n);
		}

	if(button==1){
		translate([0,0,h])
			auto_button_m0(typ);
		}
}
// ------- shield_f (n=n,d=d,h=h,button=button,typ=[typ]); -----------------


module badge_m (	n=5,			// nº lados de la base de la pirámide	
				d=19,		// diámetro del círculo-base donde se inscribe la pirámide
				h=3,			// altura de la pirámide
				B=1,			// Tipo de escudo
				button=0,	// si =1 se construira un rebaje para un botón automático
				typ			// tipo de botón automático
				){
$fn=50;

d2=d-2*h;

difference(){
	union(){
		pyramid_C (n=n,d1=d,d2=d2,h=h);
		if(B==1||B==2){
			mirror([0,0,1])
				hull(){
					prism_C (n=n,d=d,h=0.5);
	
					translate([0,0,d/4])
						if(B==1){
							cylinder(r=d/4,h=1);
							}
							else{
								if(B==2){
									sphere(d/4);
								}
							}
					}
				}
		else{
		if(B==3){
			mirror([0,0,1])
				difference(){
					prism_C(d=d,h=6,n=n);
					translate ([0,0,1])
						prism_C(d=d-5,h=6,n=n);
					}
			}	
		}
	}
	if(button==1){
		translate([0,0,h])
			rotate([0,180,0])
				auto_button_f0(typ);
		}
	else{}
	if(B==1){
		translate([0,0,-(d/4+3)])
			prism_C(d=d/3,h=6,n=n);
		}
	}
}

// ------- badge_m (B=B,n=n,d=d,h=h,button=button,typ=[typ]); -----------------

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
			translate([0,0,-0.1])
				cylinder(r=socket/2, h=0.2);
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

*badge_f(button=1,typ=COS11);

translate ([0,-30,0])
badge_m(B=1, button=1,typ=COS11);

translate ([0,-60,0])
badge_m(B=2,button=1,typ=COS11);

translate ([0,-90,0])
badge_m(B=3,button=1,typ=COS11);


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
