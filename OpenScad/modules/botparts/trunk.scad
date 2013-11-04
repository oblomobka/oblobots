//////////////////////////////////////////////////////////////////////////////////////////////
// Trunk [OBLOBOTS] 
// 
// v.06
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Oct 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <plus/external_elements.scad>
include <plus/presets.scad>

use <plus/union.scad>
use <plus/parts.scad>
use <plus/battery.scad>
use <plus/functions.scad>

//////////////////////////////////////////////////////////////////
/////////////////// MODULO trunk_cylindrical ()  /////////////////

module trunk_cylindrical(	trunk=[40,30,32],
						shoulder=[15,3,0.5]
						){

td1=lim(20,trunk[0],70);		// medida del cuerpo: diametro base || limitado [20:100]
td2=lim(20,trunk[1],td1); 	// medida del cuerpo: diametro punta ||  limitado [20:td1]
th=lim(24,trunk[2],80);		// medida del cuerpo: altura ||  limitado [20:80]

tang=atan2(th,(td1-td2)/2);	// ángulo de la pared del cono-cilindro

sd1=lim(12,shoulder[0],th*sin(tang));	// diámetro del hombro ||  limitado [10:th/2]
sdaux=lim(0,shoulder[1],10);				// diámetro del hombro intersección cono
sh=lim(0,shoulder[2],td2/2);

sd2=sd1+sdaux;
sd2v=sd2*sin(tang);

ths=th-sd2v/2;
tds=di_cone(td1,td2,th,ths);	// diámetro intermedio del cono

	shi=td2/2-(sqrt(pow(td2/2,2)-pow(sd2/2,2)));
shaux=sh+shi;

$fn=50;

// --------- Volumen ----------------

union(){

cylinder(r1=td1/2,r2=td2/2,h=th);

// hombros

difference(){
	for(i=[0,1]){
		mirror([i,0,0])
			translate([tds/2-shi,0,ths])
				shoulder (d1=sd1,h=shaux,d2=sd2);	
	}
	translate([0,0,-hi_cone(100,0,50*tan(tang),td1-3)])
		cylinder(r1=50,r2=0,h=50*tan(tang));
	}
}

// ----- Modulos auxiliares ------------

module shoulder(d1,d2,h){

d3=d1/5;

falda=th*sin(tang);
armpit=9*falda/10-sd2v/2;

		rotate([0,tang,0])
			rotate([0,0,180])
			translate([0,0,0])
			hull(){
				translate([0,0,-0.1])
				hull(){
					cylinder(r=d2/2,h=0.1);
					translate ([-armpit,0,0])
						cylinder(r=d3/2,h=0.1);
					}				
				translate ([(d2-d1)/2-h*cos(tang),0,h*sin(tang)-0.1])											
					cylinder(r=d1/2,h=0.1);
			}
		
}
// ----- Fin de los módulos auxiliares ------------
}

// -- Fin del módulo trunk_cylindrical(); -------
// ----------------------------------------------

//////////////////////////////////////////////////////////////////
/////////////////// MODULO trunk_union_cylindrical ()  ///////////

module trunk_union_cylindrical (	trunk=[45,30,40],		// [d1,d2,h] medida del cuerpo:
								shoulder=[25,3,3],	// [d,daux,h]
								pin=[10,15,TABNORMAL],			// [d,h] medidas del pin (para macho y hembra)
								neck=[18,15,1],		// [d1,d2,h] medidas y forma de la base. Opcional
								PF=NULL,				// tipo de botón automático
								correction=-0.3		// valor de corrección del hueco del botón
								){

pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin

td1=lim(20,trunk[0],70);		// medida del cuerpo: diametro base || limitado [20:100]
td2=lim(20,trunk[1],td1); 	// medida del cuerpo: diametro punta ||  limitado [20:td1]
th=lim(24,trunk[2],80);		// medida del cuerpo: altura ||  limitado [20:80]

tang=atan2(th,(td1-td2)/2);	// ángulo de la pared del cono-cilindro

sd1=lim(pind+3,shoulder[0],th*sin(tang));	// diámetro del hombro ||  limitado [10:th/2]
sdaux=lim(0,shoulder[1],10);				// diámetro del hombro intersección cono
sh=lim(0,shoulder[2],td2/2);

sd2=sd1+sdaux;
sd2v=sd2*sin(tang);
sd1v=sd1*sin(tang);

ths=th-sd2v/2;
tds=di_cone(td1,td2,th,ths);	// diámetro intermedio del cono

	shi=td2/2-(sqrt(pow(td2/2,2)-pow(sd2/2,2)));
shaux=sh+shi;

union(){
	difference(){
		trunk_cylindrical(trunk=trunk,shoulder=shoulder);
	
		// Para unión mediante pin expandible
		if(PF==NULL){
			// hembras para la cadera
			socket (pin=pin);
	
			// hembras para los brazos
			for(i=[0,1]){
				mirror([i,0,0])
					translate([-(tds/2+sh),0,th-(sd1v/2)])
						rotate([0,180-tang,0])
							socket (pin=pin);		
				}
			}
	
		// Para unión mediante botón automático
		else{
			// hembras para la cadera
			gap_button_female(PF=PF,correction=0.1);
	
			// hembras para los brazos
			for(i=[0,1]){
				mirror([i,0,0])
					translate([-(tds/2+sh),0,th-(sd1v/2)])
						rotate([0,180-tang,0])
							gap_button_female(PF=PF,correction=0.1);		
				}
			}
		}

	if(PF==NULL){
		translate([0,0,trunk[2]])
			pin (pin=pin,base=[neck[0],neck[1],neck[2],50],correction=correction);
		}
	else{
		translate([0,0,trunk[2]])
			gap_button_male_base (PF=PF,base=[neck[0],neck[1],neck[2],50],correction=0.1);
		}
}
}

// -- Fin del módulo trunk_union_cylindrical(); --------
// -----------------------------------------------------

//////////////////////////////////////////////////////////////////
/////////////////// MODULO trunk_badge_cylindrical ()  ///////////

module trunk_badge_cylindrical (	trunk=[45,32,45],		// [d1,d2,h] medida del cuerpo
								shoulder=[16,2,2],	// [d,daux,h]
								badge=[20,2.5,3,5],	// [d,h base, b, n lados]
								badgeposition=[1,180],	// [dist b, ang] 
								PFbadge=COS11		// tipo de botón automático
								){

badged=lim(20,badge[0],35)+0.3;		// diámetro del círculo-base donde se inscribe la pirámide
badgeh=badge[1]+0.2;					// profundidad del rebaje
badgen=lim(4,badge[3],50);			// nº lados de la base de la pirámide
badgeb=lim(1,badge[2],5);				// borde del alojamiento del badge

td1=lim(20,trunk[0],70);		// medida del cuerpo: diametro base || limitado [20:100]
td2=lim(20,trunk[1],td1); 	// medida del cuerpo: diametro punta ||  limitado [20:td1]
th=lim(24,trunk[2],80);		// medida del cuerpo: altura ||  limitado [20:80]

tang=atan2(th,(td1-td2)/2);	// ángulo de la pared del cono-cilindro

sd1=lim(12,shoulder[0],th*sin(tang));	// diámetro del hombro ||  limitado [10:th/2]
sdaux=lim(0,shoulder[1],10);				// diámetro del hombro intersección cono
sh=lim(0,shoulder[2],td2/2);

sd2=sd1+sdaux;
sd2v=sd2*sin(tang);
sd1v=sd1*sin(tang);

ths=th-sd2v/2;					// altura intermedia del cono para la posición del hombro
tds=di_cone(td1,td2,th,ths);		// diámetro intermedio del cono para la posición del hombro

	shi=td2/2-(sqrt(pow(td2/2,2)-pow(sd2/2,2)));
shaux=sh+shi;

thb=th-3-badgeposition[0]-(badged+2*badgeb)*0.5*sin(tang);	// altura intermedia del tronco para la posición del badge
tdb=di_cone(td1,td2,th,thb);				// diámetro intermedio del tronco para la posición del badge


difference(){
	union(){
		trunk_cylindrical (trunk=trunk,shoulder=shoulder);
		translate([0,tdb/2,thb])
			rotate([-tang,0,0])
				translate([0,0,-10])
					rotate([0,0,badgeposition[1]])
					rotate([0,0,180/badgen])
						prism_circumscribed(d=badged+2*badgeb,h=10,n=badgen);
		}
	translate([0,tdb/2,thb])
			rotate([-tang,0,0])
				rotate([0,0,badgeposition[1]])
				rotate([0,180,180/badgen])
					badge_subtraction(badge=[badged,badgeh,badgen],PF=PFbadge,correction=0.1);
	}
}

// -- Fin del módulo trunk_badge_cylindrical(); --------
// -----------------------------------------------------

////////////////////////////////////////////////////////////////////////
/////////////////// MODULO trunk_badge_union_cylindrical ()  ///////////

module trunk_badge_union_cylindrical (	trunk=[40,37,40],		// [d1,d2,h] medida del cuerpo
									shoulder=[18,5,1],	// [d,daux,h]
									pin=[10,15,,TABFINE],	// [d,h] medidas del pin (para macho y hembra)
									neck=[30,25,1],		// [d1,d2,h] medidas y forma de la base. Opcional
									PF=NULL,				// tipo de botón automático
									correction=-0.3,		// valor de corrección del hueco del botón
									badge=[20,2.5,2,7],	// [d,h base, b, n lados]
									badgeposition=[0,0],	// [dist b, ang] 
									PFbadge=COS11		// tipo de botón automático
									){

pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin

td1=lim(20,trunk[0],70);		// medida del cuerpo: diametro base || limitado [20:100]
td2=lim(20,trunk[1],td1); 	// medida del cuerpo: diametro punta ||  limitado [20:td1]
th=lim(24,trunk[2],80);		// medida del cuerpo: altura ||  limitado [24:80]

tang=atan2(th,(td1-td2)/2);	// ángulo de la pared del cono-cilindro

sd1=lim(pind+3,shoulder[0],th*sin(tang));	// diámetro del hombro ||  limitado [10:th/2]
sdaux=lim(0,shoulder[1],10);				// diámetro del hombro intersección cono
sh=lim(0,shoulder[2],td2/2);

sd2=sd1+sdaux;
sd2v=sd2*sin(tang);
sd1v=sd1*sin(tang);

ths=th-sd2v/2;
tds=di_cone(td1,td2,th,ths);	// diámetro intermedio del cono

	shi=td2/2-(sqrt(pow(td2/2,2)-pow(sd2/2,2)));
shaux=sh+shi;

union(){
	difference(){
		trunk_badge_cylindrical(	trunk=trunk,
								shoulder=shoulder,
								badge=badge,
								badgeposition=badgeposition,
								PFbadge=COS11);
	
		// Para unión mediante pin expandible
		if(PF==NULL){
			// hembras para la cadera
			socket (pin=pin);
	
			// hembras para los brazos
			for(i=[0,1]){
				mirror([i,0,0])
					translate([-(tds/2+sh),0,th-(sd1v/2)])
						rotate([0,180-tang,0])
							socket (pin=pin);		
				}
			}
	
		// Para unión mediante botón automático
		else{
			// hembras para la cadera
			gap_button_female(PF=PF,correction=0.1);
	
			// hembras para los brazos
			for(i=[0,1]){
				mirror([i,0,0])
					translate([-(tds/2+sh),0,th-(sd1v/2)])
						rotate([0,180-tang,0])
							gap_button_female(PF=PF,correction=0.1);		
				}
			}
		}

	if(PF==NULL){
		translate([0,0,trunk[2]])
			pin (pin=pin,base=[neck[0],neck[1],neck[2],50],correction=correction);
		}
	else{
		translate([0,0,trunk[2]])
			gap_button_male_base (PF=PF,base=[neck[0],neck[1],neck[2],50],correction=0.1);
		}
}
}


// -- Fin del módulo trunk_badge_union_cylindrical(); --------
// -----------------------------------------------------

//////////////////////////////////////////////////////////////////
/////////////////// MODULO trunk_quadrangle  /////////////////////

module trunk_quadrangle (	trunk=[42,20,32],	// medida del cuerpo: [ ancho (x), fondo (y), altura (z) ]
						T=1				// Tipo de hombro:	1 -> 3 chaflanes
										//					2 -> 4 chaflanes
						){
$fn=50;

trx=lim(20,trunk[0],90);
try=lim(20,trunk[1],90);
trz=lim(24,trunk[2],90);

shx=trx/10;
shy=try;
shz=max(24,trz/2);

// --------- Volumen ----------------

union(){
	translate ([0,0,trz/2])
		cube ([trx,try,trz],center=true);

	// hombros
	for(i=[0,1]){
		mirror([i,0,0])
			translate([-trx/2,0,trz-shz])
				shoulder (S=T,sh=[shx,shy,shz]);
		}	
	}

// ----- Modulos auxiliares ------------

module shoulder(S,sh){

shx=sh[0];
shy=sh[1];
shz=sh[2];

ang=45;		//[0:45]

// paralepipedo achflanado en 3 lados	
if(S<=1){
	rotate([0,-90,0])translate ([shz/2,0,0])
	hull(){
		translate ([0,0,-0.05])
			cube([shz,shy,0.1],center=true);
		translate ([shx*cos(ang)/2,0,shx/2])
			cube([shz-shx*cos(ang),shy-2*shx*cos(ang),shx],center=true);
		}
	}

// paralepipedo achflanado en 4 lados
	else{
		if(S>=2){
			rotate([0,-90,0])translate ([shz/2,0,0])
			hull(){
				translate ([0,0,-0.05])
					cube([shz,shy,0.1],center=true);
				translate ([0,0,shx/2])
					cube([shz-2*shx*cos(ang),shy-2*shx*cos(ang),shx],center=true);
			}
		}	
	}
}
// ----- Fin de los módulos auxiliares ------------
}

// ---- Fin del módulo trunk_quadrangle(trunk=[x,x,x],T=1); ---------------
// ------------------------------------------------------------------------


//////////////////////////////////////////////////////////////////
///////////// MODULO trunk_union_quadrangle  /////////////////////

module trunk_union_quadrangle	(	trunk=[42,25,40],		// medida del cuerpo: [ancho(x),fondo(y),altura(z)]
								T=1,					// Tipo de hombro:	1 -> 3 chaflanes
													//					2 -> 4 chaflanes
								pin=[10,15,SIMPLE],			// [d,h] medidas del pin (para macho y hembra)
								neck=[20,15,1,2],		// [d1,d2,h,n] medidas y forma de la base. Opcional
								PF=NULL,				// tipo de botón automático
								correction=0		// valor de corrección del hueco del botón
								){
trx=lim(20,trunk[0],90);
try=lim(20,trunk[1],90);
trz=lim(24,trunk[2],90);

union(){
difference(){
	trunk_quadrangle (trunk=trunk,T=T);
	
	// Para unión mediante pin expandible
	if(PF==NULL){
		// hembras para la cadera
		socket (pin=pin);

		// hembras para los brazos
		for(i=[-1,1]){
			if(T<=1){
				translate([-i*(trx/2+trx/10),0,trz-max(24,trz/2)/2+trx/20])
					rotate([0,i*90,0])
						socket (pin=pin);
				}	
			else{
				if(T>=2){
					translate([-i*(trx/2+trx/10),0,trz-max(24,trz/2)/2])
						rotate([0,i*90,0])
							socket (pin=pin);
					}
				}
			}
		}
	
	// Para unión mediante botón automático
	else{
		// hembras para la cadera
		gap_button_female(PF=PF,correction=0.1);

		// hembras para los brazos
		for(i=[-1,1]){
			if(T<=1){
				translate([-i*(trx/2+trx/10),0,trz-max(24,trz/2)/2+trx/20])
					rotate([0,i*90,0])
						gap_button_female(PF=PF,correction=0.1);
				}	
			else{
				if(T>=2){
					translate([-i*(trx/2+trx/10),0,trz-max(24,trz/2)/2])
						rotate([0,i*90,0])
							gap_button_female(PF=PF,correction=0.1);
					}
				}
			}
		}
	}
	if(PF==NULL){
		translate([0,0,trz])
			pin (	pin=pin,base=neck,correction=correction);
		}
	else{
		translate([0,0,trz])
			gap_button_male_base (PF=PF,base=neck,correction=0.1);
		}
	}	
}

// ---- Fin del módulo trunk_union_quadrangle(); ---------
// ------------------------------------------------------------------------

//////////////////////////////////////////////////////////////////
///////////// MODULO trunk_badge_union_quadrangle  ///////////////

module trunk_badge_union_quadrangle	(	trunk=[42,25,40],		// medida del cuerpo: [ancho(x),fondo(y),altura(z)]
										T=2,					// Tipo de hombro:	1 -> 3 chaflanes
															//					2 -> 4 chaflanes
										pin=[8,15,SIMPLE],	// [d,h] medidas del pin (para macho y hembra)
										neck=[20,15,1,2],		// [d1,d2,h,n] medidas y forma de la base. Opcional
										PF=NULL,				// tipo de botón automático
										correction=0,		// valor de corrección del pin/botón
										badge=[20,2.5,8],		 
										badgeposition=[3,0],	// [dist b, ang]
										PFbadge=COS11
										){

trx=lim(20,trunk[0],90);
try=lim(20,trunk[1],90);
trz=lim(24,trunk[2],90);

badged=lim(20,badge[0],35);	

difference(){
	trunk_union_quadrangle (trunk=trunk,T=T,pin=pin,neck=neck,PF=PF,correction=correction);
	if(PF==NULL){
		translate([0,try/2,trz-badged/2-2.5-badgeposition[0]])
			rotate([-90,0,180])
			rotate([0,0,+badgeposition[1]])
			badge_subtraction (badge=badge,PF=PFbadge,correction=0.1);
			}
	else{
		translate([0,try/2,trz-badged/2-2.5-badgeposition[0]])
			rotate([-90,0,180])
			rotate([0,0,+badgeposition[1]])
			badge_subtraction (badge=badge,PF=PF,correction=0.1);
			}
	}
}

// ---- Fin del módulo trunk_badge_quadrangle(); ---------
// -------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

i=70;

// Con forma de caja
trunk_quadrangle(trunk=[42,20,32],T=1);

translate([0,i,0])
	trunk_union_quadrangle(	trunk=[42,25,40],	
							T=1,	
							pin=[10,15,SIMPLE],	
							neck=[25,15,4,4],	
							PF=NULL,	
							correction=-0.3);

translate([-i,i,0])
	trunk_badge_union_quadrangle(	trunk=[42,25,40],	
								T=2,	
								pin=[8,15,TABNORMAL],	
								neck=[20,15,1,2],	
								PF=NULL,	
								correction=-0.3,
								badge=[20,2.5,8],		 
								badgeposition=[3,0],
								PFbadge=COS11);

// Conicos y cilindricos
translate([i,0,0])
	trunk_cylindrical(trunk=[42,28,35],shoulder=[15,5,3]);

translate([i,i,0])
	trunk_union_cylindrical(	trunk=[45,30,40],	
							shoulder=[13,3,3],
							pin=[10,15,TABFINE],
							neck=[25,15,5],
							PF=NULL,	
							correction=-0.3);

translate([2*i,0,0])
	trunk_badge_cylindrical(	trunk=[45,32,45],	
							shoulder=[16,2,2],
							badge=[20,2.5,3,5],
							badgeposition=[1,180],
							PFbadge=COS11);

translate([2*i,i,0])
	trunk_badge_union_cylindrical(	trunk=[40,30,40],	
									shoulder=[18,5,1],	
									pin=[12,15,TABFINE],
									neck=[25,18,4],
									PF=NULL,
									correction=-0.3,
									badge=[20,2.5,2,7],
									badgeposition=[0,0],
									PFbadge=COS11);



