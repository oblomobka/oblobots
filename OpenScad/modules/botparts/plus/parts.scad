//////////////////////////////////////////////////////////////////////////////////////////////////
// parts [OBLOBOTS] 
// partes que estarán integradas en los volúmenes
// v.06
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Oct 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license 
//////////////////////////////////////////////////////////////////////////////////////////////////

include <external_elements.scad>
include <presets.scad>
use <union.scad>
use <functions.scad>

////////////////////////////////////////////////////////
////////////////////// VOLÚMENES /////////////////////////

// --- Piramide con base circunscrita en un círculo definido en las variables
module pyramid_circumscribed (	n=4,			// nº lados de la base de la pirámide	
								d1=20,		// diámetro del círculo-base donde se circunscribe la pirámide
								d2=0,		// diámetro del círculo-punta donde se circunscribe la pirámide
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
// ------- pyramid_circumscribed (n=n,d1=d1,d2=d2,h=h); -----------------

// --- Prisma con base circunscrita en un círculo definido en las variables
module prism_circumscribed (	n=4,			// nº lados de la base del prisma
							d=20,		// diámetro del círculo donde se circunscribe el prisma
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

// ------- prism_circumscribed (n=n,d=d,h=h); -----------------


////////////////////////////////////////////////////////
////////////////////// DECORACIÓN /////////////////////////

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


// ---- Volumen que debe rebajarse del cuerpo principal donde se colocará el badge();
module badge_subtraction (	badge=[20,3,8],					// medidas del badge
							PF=[0,0,0,0,0,0],		// tipo de botón automático
							correction=0						// valor de corrección del hueco del botón
							){

badged=lim(20,badge[0],35)+0.4;		// diámetro del círculo-base donde se inscribe la pirámide
badgeh=lim(1,badge[1],5)+0.15;					// profundidad del rebaje
badgen=lim(4,badge[2],50);				// nº lados de la base de la pirámide	

badged2=badged-2*badgeh;

translate([0,0,-0.05])
if(badgen%2==0){
	rotate([0,0,180/badgen])
		cylinder (r1=badged/2/cos(180/badgen), r2=badged2/2/cos(180/badgen), h=badgeh, $fn=badgen);
	}
	else{
		rotate([0,0,90/badgen])
			cylinder (r1=badged/2/cos(180/badgen), r2=badged2/2/cos(180/badgen), h=badgeh, $fn=badgen);
		}

//	if(button==1){
		translate([0,0,badgeh])
			gap_button_male(PF,correction=0.1+correction);
//		}
}

// ------- badge_subtraction (badge=[d,h,n],PressFastener,correction); -----------------

// Volumen que representa una columna donde se rebaja la base del badge
// su perímetro lo define el tamaño y la forma del badge al que se le añade un borde parametrizable

module badge_column (	column=[3,20],			// [borde, h] medidas de la columna donde se incrusta el badge
					badge=[20,3,8],			// medidas del badge
					PF=COS11,				// tipo de botón automático
					correction=0				// valor de corrección del hueco del botón
					){

badged=lim(20,badge[0],35)+0.4;	// diámetro del círculo-base donde se inscribe la pirámide
badgeh=lim(1,badge[1],5)+0.15;				// profundidad del rebaje
badgen=lim(4,badge[2],50);			// nº lados 

columnb=max(column[0],1);
columnh=max(column[1],badgeh+PF[5]+1);

difference(){
	prism_circumscribed(n=badgen,d=badged+2*columnb,h=columnh);
	translate([0,0,columnh])
		rotate([0,180,0])
			badge_subtraction(badge=badge,PF=PF,correction=correction);
	}
}

// ------- badge_column (column=[b,h],badge=[d,h,n],PF,correction); -----------------

// ---- Volumen del badge(), la parte inferior podrá alojar un botón automático
// --- Se disponen de varias opciones para la parte superior

module badge (	B=1,								// Tipo de badge
				badge=[20,3,8],					// medidas del badge
				PF=[0,0,0,0,0,0],					// tipo de botón automático
				correction=0						// valor de corrección del hueco del botón
				){
$fn=50;

d=lim(20,badge[0],35);		// diámetro del círculo-base donde se inscribe la pirámide
h=lim(1,badge[1],5);			// altura de la base
n=lim(4,badge[2],50);			// nº lados del badge

d2=d-2*h;

difference(){
	union(){
		pyramid_circumscribed (n=n,d1=d,d2=d2,h=h);
		if(B<=1||B==2){
			mirror([0,0,1])
				hull(){
					prism_circumscribed (n=n,d=d,h=0.5);
					translate([0,0,d/4])
						if(B<=1){
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
		if(B>=3){
			mirror([0,0,1])
				difference(){
					prism_circumscribed(d=d,h=6,n=n);
					translate ([0,0,2])
						prism_circumscribed(d=d-5,h=6,n=n);
					}
			}	
		}
	}
	translate([0,0,h])
		rotate([0,180,0])
			gap_button_female(PF,correction=0.1+correction);
	if(B<=1){
		translate([0,0,-(d/4+3)])
			prism_circumscribed(d=d/3,h=6,n=n);
		}
	}
}

// ------- badge (B=B,badge,PF,correction); -----------------

module badge_family (		units=[1,2,3],
						badge=[20,3,8],			// [d,h base,n lados] medidas del badge
						PF=COS11,					// tipo de botón automático
						correction=0,
						representation=2
						){

d=lim(20,badge[0],35);		// diámetro del círculo-base donde se inscribe la pirámide
h=lim(1,badge[1],5);			// altura de la base
n=lim(4,badge[2],50);			// nº lados del badge

if(representation==0){
	rotate([90,0,0])
		badge (B=units[0],badge=badge,PF=PF,correction=correction);
	}
else{
	if(representation==1){	
		for(i=[0:len(units)-1]){
			translate([0,i*(d+3),0])
				rotate([90,0,0])
					badge (B=units[i],badge=badge,PF=PF,correction=correction);
			}
		}
	else{
		if(representation==2){
			for(i=[0:len(units)-1]){
				translate([0,-i*(d+d/4),h])
					rotate([0,180,0])
						badge (B=units[i],badge=badge,PF=PF,correction=correction);
				}
			}
		}
	}
}


module badge_family_compact 	(	units=[3,3,3],
								badge=[20,3,6],
								PF=COS11,		
								correction=0
								){
$fn=50;

badged=lim(20,badge[0],35);		// diámetro del círculo-base donde se inscribe la pirámide
badgeh=lim(1,badge[1],5);			// altura de la base
badgen=lim(4,badge[2],50);		// nº lados del badge

u=lim(1,len(units),7);

aux= badgen%2==0 ? 360:180;

translate([0,0,badgeh])
	rotate([0,180,0])
		badge (B=units[0],badge=badge,PF=PF,correction=correction);
	
	for(i=[0:u-2]){
		rotate([0,0,i*60])	
			translate([radius_apothem(badged,badgen)+1,0,0])
				translate([0,0,badgeh])
					rotate([0,180,i*aux/badgen])
						badge (B=units[i+1],badge=badge,PF=PF,correction=correction);
		}
}


// ------- badge (B=B,badge,PF,correction); -----------------


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

i=30;

translate ([-i*6,0,0])
	badge_family (	units=[1,2,3],
					badge=[20,3,8],
					PF=COS11,
					correction=0,
					representation=1);

translate ([-i*7,0,0])
	badge_family (	units=[2,1,3],
					badge=[24,3,5],
					PF=COS11,
					correction=0,
					representation=2);

translate ([-i*2,0,0])
	rotate([0,180,0])
		badge(B=0, badge=[20,3,5],PF=COS11,correction=0.2);
translate ([-i*2,i,0])
	rotate([0,180,0])
		badge(B=2,badge=[25,3,8],PF=COS11);
translate ([-i*2,2*i,0])
	rotate([0,180,0])
		badge(B=3,badge=[22,2.5,50],PF=COS11);

translate ([-i*3,0,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([28,28,10],center=true);
		rotate([0,180,0])
			badge_subtraction(badge=[20,3,5],PF=PON);
		}
translate ([-i*3,i,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([28,28,10],center=true);
		rotate([0,180,0])
			badge_subtraction(badge=[25,3,8],PF=COS11);
		}
translate ([-i*3,2*i,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([28,28,10],center=true);
		rotate([0,180,0])
			badge_subtraction(badge=[22,2.5,50],PF=PRYM10);
		}

// Conjunto posicion del Badge
translate ([-i*3,3*i,0])
	color("yellow")
	difference(){
		rotate([0,180,0])
			badge(B=3,badge=[22,2.5,6],PF=COS11);
		translate([0,25,0])
			cube([50,50,50],center=true);
		}

translate ([-i*3,3*i,0])
	difference(){
	color("red")
	difference(){
		translate([0,0,-5])
			cube([28,28,10],center=true);
		rotate([0,180,0])
			badge_subtraction(badge=[22,2.5,6],PF=COS11);
		}
	translate([0,25,0])
			cube([50,50,50],center=true);
	}

translate ([-i*4.5,1.5*i,0])
	badge_column (column=[1,10],badge=[20,2,50],PF=COS11,correction=0.1);
//badge_column (column=[2,3],badge=[20,3,5],PF=COS11,correction=0.1);
translate ([-i*4.5,0,0])
	badge_column (column=[1,40],badge=[24,3,5],PF=COS11,correction=0.1);


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

