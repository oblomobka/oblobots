//////////////////////////////////////////////////////////////////////////////////////////////////
// union [OBLOBOTS] 
// v.06 
// elementos de unión entre las partes del cuerpo de los oblobots
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Oct 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <external_elements.scad>
include <presets.scad>

use <parts.scad>
use <functions.scad>

//////////////////////////////////////////////////////
////////// MÓDULOS TIPO PIN /////////////////

/////////// MACHOS ///////////

// ---- Pin cilíndrico simple. Tiene un ligero achafalnado en la punta
module pin_simple(	pin=[12,20,SIMPLE],		// [d,h]	medidas generales del pin
					base=[0,0,0,0],			// [d1,d2,h,n] medidas y forma de la base. Opcional
					correction=0.0			// ajuste del diámetro. Suma o resta al diámetro del pin[0]
					){
					
$fn=50;

defaultcorrection=-0.1;

dp=lim(4,pin[0],20)+defaultcorrection+correction;	// diámetro del pin
hp=lim(5,pin[1],30);								// longitud del pin
db1=lim(dp,base[0],100);							// diámetro de la base1
db2=lim(dp,base[1],db1);							// diámetro de la base2 si es =db1 es un prisma rectangular
hb=base[2];										// longitud de la base
nb=lim(4,base[3],50);								// lim:(4<-->50) nº de lados del prisma base	

hp1=1;								// rebaje de la punta
hp2=hp-hp1;

translate([0,0,hb])
	union(){
		cylinder(r=dp/2, h=hp2);
		translate([0,0,hp2])
			cylinder (r1=dp/2,r2=(dp-2)/2,h=hp1);
		if(hb==0){
				translate([0,0,-hb])
					pyramid_circumscribed(d1=db1,d2=db2,h=hb,n=0);
				}
			else{
				translate([0,0,-hb])
					pyramid_circumscribed(d1=db1,d2=db2,h=hb,n=nb);
				}
		}
}

// ------ Fin del módulo pin_simple(pin=[d,h,[TAB]],base=[d1,d2,h,n],correction=x); ------------


// --- pin que se ensancha en la punta
module pin_expand (	pin=[12,20,TABNORMAL],	// [d,h,[tab]]	medidas generales del pin
											// [tab] representa las medidas de la pestaña [d,cruz,expand]
					base=[0,0,0,0],			// [d1,d2,h,n] medidas y forma de la base. Opcional
					correction=0.0			// ajuste del diámetro. Suma o resta al diámetro del pin[0]
					){

$fn=50;
defaultcorrection=-0.3;

dp=lim(4,pin[0],20)+defaultcorrection+correction;		// diámetro del pin
hp=lim(5,pin[1],30);								// longitud del pin
db1=max(dp,base[0]);								// diámetro de la base1
db2=lim(dp,base[1],db1);				// diámetro de la base2 si es =db1 es un prisma rectangular
hb=base[2];							// longitud de la base
nb=lim(4,base[3],50);					// lim:(4<-->50) nº de lados del prisma base							


cross=dp*(lim(25,pin[2][1],100)/400);
core=dp*(lim(25,pin[2][0],100)/100);
expand=lim(30,pin[2][2],100)/100;		// valor de la expansión del pin en la punta

dpe=dp+expand;
hpe=hp/15;


translate([0,0,hb])
	difference(){
		union(){
			cylinder(r=dp/2,h=hp/2);
			translate([0,0,hp/2])
				cylinder(r1=dp/2,r2=dpe/2,h=hp/2-hpe);
			translate([0,0,hp-hpe])
				cylinder (r1=dpe/2,r2=(dp-1)/2,h=hpe-0.05);
			if(hb==0){
				translate([0,0,-hb])
					pyramid_circumscribed(d1=db1,d2=db2,h=hb,n=0);
				}
			else{
				translate([0,0,-hb])
					pyramid_circumscribed(d1=db1,d2=db2,h=hb,n=nb);
				}
			}

		translate([0,0,hp])
			for(i=[90,180]){
				rotate([0,0,i])
					union(){
						cube([2*dp,cross,hp],center=true);
						translate([0,0,-hp/2])rotate([90,0,0])
							cylinder(r=cross/2,h=2*pin[0],center=true);
						}
				}
		cylinder(r=core/2,h=3*hp, center=true);
		}
	}

// ------ Fin del módulo pin_expand(pin=[d,h,[TAB]],base=[d1,d2,h,n],correction=x); ------------


// --- pin general - si SIMPLE el pin será un cilindro, si se define TAB-- será un pin expandible en la punta
module pin (	pin=[12,20,TABNORMAL],	// [d,h,[tab]]	medidas generales del pin
									// [tab] representa las medidas de la pestaña [d,cruz,expand]
			base=[0,0,0,0],			// [d1,d2,h,n] medidas y forma de la base. Opcional
			correction=0.0			// ajuste del diámetro. Suma o resta al diámetro del pin[0]
			){

if(pin[2]==SIMPLE){
	pin_simple(pin=pin,base=base,correction=correction);
	}
	else{
		pin_expand(pin=pin,base=base,correction=correction);
	}
}

// ------ Fin del módulo pin(pin=[d,h,[TAB]],base=[d1,d2,h,n],correction=x); ------------

////////// HEMBRAS ////////////////////

// --- Taladro poligonal para volumen macizo.
// --- Dibuja el volumen, se hace el taladro mediante difference(){}

module socket_polygonal (pin=[12,6,SIMPLE]){

$fn=50;
s=6;			// Nº de lados del taladro (el taladro es poligonal, normalmente será hexagonal)

dp=lim(4,pin[0],20);	// diámetro del taladro
hp=lim(5,pin[1],30);	// profundidad del taladro

translate([0,0,-0.2])
	intersection(){
		cylinder (r=(dp/cos(180/s))/2,h=hp+0.2,$fn=s);
		cylinder (r=(dp+dp/20)/2,h=hp+0.2);
		}
}

// ------ Fin del módulo drill_polygonal (pin=[d,h]); ------------


// --- Taladro poligonal para volumen hueco - Añade una caña donde alojar el pin de espesor e.
// --- Funciona como una transformación

module socket_polygonal_pod (	pin=[12,6,SIMPLE],		// [d,h]	medidas generales del pin
							t=3					// espesor de la caña donde se alojará el pin correspondiente
							){

$fn=50;
s=6;			// Nº de lados del taladro (el taladro es poligonal, normalmente será hexagonal)

dp=lim(4,pin[0],20);	// diámetro del taladro
hp=lim(5,pin[1],30);	// profundidad del taladro


difference(){
	child (0);
	cylinder (r=(dp+2*t)/2,h=2*hp,center=true);	
	}

color("red")
difference(){
	cylinder (r=(dp+2*t)/2,h=hp+t);
	translate([0,0,-0.2])
		intersection(){
			cylinder (r=(dp/cos(180/s))/2,h=hp+0.2,$fn=s);
			cylinder (r=(dp+dp/20)/2,h=hp+0.2);
		}
	}
}

// ------ Fin del módulo drill_polygonal_pod (pin=[d,h],e=e); ------------


// --- Taladro que se ensancha en la punta
// --- Dibuja el volumen, se hace el taladro mediante difference(){}

module socket_expand (pin=[12,6,TABNORMAL]){

$fn=50;

dp=lim(4,pin[0],20);				// diámetro del taladro
hp=lim(5,pin[1],30);				// profundidad del taladro

expand=lim(30,pin[2][2],100)/100;				// valor de la expansión del pin en la punta
dpe=dp+expand;
hpe=hp/15;

translate([0,0,-0.05])
union(){
	translate([0,0,-0.5])
		cylinder(r=dp/2,h=0.5+hp/2);
	translate([0,0,(hp-0.05)/2])
		cylinder(r1=dp/2,r2=dpe/2,h=hp/2-hpe);
	translate([0,0,hp-hpe-0.05])
		cylinder (r1=dpe/2,r2=(dp-1)/2,h=hpe);
	}
}

// ------ Fin del módulo drill_expand (pin=[d,h]); ------------


// --- Taladro que se ensancha en la punta con caña
// --- Funciona como una transformación

module socket_expand_pod (	pin=[12,6,TABNORMAL],	// [d,h]	medidas generales del pin
							t=3					// espesor de la caña donde se alojará el pin correspondiente
							){
$fn=50;
dp=lim(4,pin[0],20);				// diámetro del taladro
hp=lim(5,pin[1],30);				// profundidad del taladro

expand=lim(30,pin[2][2],100)/100;		// valor de la expansión del pin en la punta
dpe=dp+expand;
hpe=hp/15;

//color("green")
difference(){
	child (0);	
		cylinder (r=(dp+2*t)/2,h=2*hp,center=true);	
	}

//color("green")
	difference(){
		cylinder (r=(dp+2*t)/2,h=hp+t);
		union(){
			translate([0,0,-0.5])
				cylinder(r=dp/2,h=0.5+hp/2);
			translate([0,0,(hp-0.05)/2])
				cylinder(r1=dp/2,r2=dpe/2,h=hp/2-hpe+0.05);
			translate([0,0,hp-hpe])
				cylinder (r1=dpe/2,r2=(dp-1)/2,h=hpe);
			}
		}
}

// --------- Fin del módulo drill_expand_pod (pin=[d,h],e=e); ------------

// --- alojamiento del pin - si SIMPLE el pin será un cilindro, si se define TAB-- será un pin expandible en la punta
module socket (	pin=[12,20,TABNORMAL]		// [d,h,[tab]]	medidas generales del pin
										// [tab] representa las medidas de la pestaña [d,cruz,expand]
				){

if(pin[2]==SIMPLE){
	socket_polygonal(pin=pin);
	}
	else{
		socket_expand(pin=pin);
	}
}

// ------ Fin del módulo socket(pin=[d,h,[TAB]]); ------------

// --- alojamiento del pin - si SIMPLE el pin será un cilindro, si se define TAB-- será un pin expandible en la punta
module socket_pod (	pin=[12,20,TABNORMAL],	// [d,h,[tab]]	medidas generales del pin
											// [tab] representa las medidas de la pestaña [d,cruz,expand]
					t=3						// espesor de la caña donde se alojará el pin correspondiente
					){

if(pin[2]==SIMPLE){
	socket_polygonal_pod(pin=pin,t=t)
		child (0);
	}
	else{
		socket_expand_pod(pin=pin,t=t)
			child (0);
	}
}

// ------ Fin del módulo socket_pod(pin=[d,h,[TAB]],t=t); ------------



// -------------- Fin de los módulos tipo PIN --------------------
// ------------------------------------------------------------------------



//////////////////////////////////////////////////////
////////// MÓDULOS TIPO BOTÓN AUTOMÁTICO /////////////

////////// HEMBRAS ////////////////////

// Dibuja un cilindro que se debe restar del bloque principal donde se colocará el botón

module gap_button_female (	PF,					// (Press Fastenner) Tipo de botón automático
							correction=0			// corrección, para ajustar el diámetro
							){
$fn=50;

h=PF[1];
d=PF[0]+0.1+correction;

d2=PF[2];

hs=max(0,PF[3]-h);


translate([0,0,-0.1])
	union(){
		cylinder (r=d/2,h=h+0.1);
		translate([0,0,h+0.1+0.3])
			cylinder (r=d2/2,h=hs);
		}	
}

// --- Genera el hueco donde encajará el botón automático. Para usar en paredes finas
// --- Funciona como una transformación. 

module gap_button_female_pod (	PF,					// (Press Fastenner) Tipo de botón automático
								correction=0,		// corrección, para ajustar el diámetro
								t=1					// espesor de la caña donde se alojará el botón
								){
$fn=50;

h1=PF[1];
d1=PF[0]+0.1+correction;

h2=PF[3];
d2=PF[2];

hs=max(0,h2-h1);

difference(){
	child (0);
	union(){
		translate([0,0,-0.1])
			cylinder (r1=(d1+2*h1+4*t+0.1)/2,r2=(d1+2*t)/2,h=(h1+t)+0.1);
		translate([0,0,h1+t])
			cylinder (r1=(d1+2*t)/2,r2=(d2+2*t)/2,h=hs);
		}	
	}

difference(){
	union(){
		cylinder (r1=(d1+2*h1+4*t)/2,r2=(d1+2*t)/2,h=(h1+t));
		translate([0,0,h1+t])
			cylinder (r1=(d1+2*t)/2,r2=(d2+2*t)/2,h=hs);
		}
	translate([0,0,-0.1])
		union(){
			cylinder (r=d1/2,h=h1+0.1);
			translate([0,0,h1+0.1+0.3])
				cylinder (r=d2/2,h=hs);
			}
	}
}

module gap_button_female_base (	PF,					// (Press Fastenner) Tipo de botón automático
								base=[15,15,4,6],		// [d1,d2,h,n] medidas y forma de la base. Opcional
								correction=0,		// corrección, para ajustar el diámetro
								){
$fn=50;

h1=PF[1]+0.2;
d1=PF[0]+0.1+correction;

h2=PF[3];
d2=PF[2];

hs=max(0,h2-h1);

db1=max(d1+2,base[0]);				// diámetro de la base1
db2=min(db1,max(d1+2,base[1]));		// diámetro de la base2 si es =db1 es un prisma rectangular
hb=base[2]+0.3;						// longitud de la base
nb=lim(4,base[3],50);					// número de lados del prisma base

ht=h2+hb;

difference(){
	pyramid_circumscribed(d1=db1,d2=db2,h=ht,n=nb);
	union(){
		translate([0,0,hb+hs])
			cylinder (r=d1/2,h=h1+0.05);
		translate([0,0,hb+hs-0.3-hs])
			cylinder(r=d2/2,h=hs);
		}	
	}	
}


/////////// MACHOS ///////////

// Dibuja un cilindro que se debe restar del bloque principal donde se colocará el botón

module gap_button_male (	PF,					// (Press Fastenner) Tipo de botón automático
						correction=0,		// corrección, para ajustar el diámetro
						){

h=PF[5]+0.2;
d=PF[4]+0.1+correction;

$fn=50;

translate([0,0,-0.1])
	cylinder (r=d/2,h=h+0.1);			
}

// --- Genera el hueco donde encajará el botón automático. Para usar en paredes finas
// --- Funciona como una transformación. 

module gap_button_male_pod (	PF,					// (Press Fastenner) Tipo de botón automático
							correction=0,		// corrección, para ajustar el diámetro
							t=1					// espesor de la caña donde se alojará el botón
							){

h=PF[5];
d=PF[4]+0.1+correction;

$fn=50;

difference(){
	child (0);
	translate([0,0,-0.1])
		cylinder (r1=(d+2*h+4*t+0.1)/2,r2=(d+2*t)/2,h=(h+t)+0.1);	
	}

difference(){
	cylinder (r1=(d+2*h+4*t)/2,r2=(d+2*t)/2,h=(h+t));
	translate([0,0,-0.1])
		cylinder (r=d/2,h=h+0.1);
			
		}
}

// Dibuja un prisma donde se resta el hueco donde irá el botón

module gap_button_male_base (	PF,					// (Press Fastenner) Tipo de botón automático
							base=[15,15,4,6],		// [d1,d2,h,n] medidas y forma de la base. Opcional
							correction=0,		// corrección, para ajustar el diámetro
							){
$fn=50;

h=PF[5]+0.2;
d=PF[4]+0.1+correction;

db1=max(d+2,base[0]);					// diámetro de la base1
db2=min(db1,max(d+2,base[1]));		// diámetro de la base2 si es =db1 es un prisma rectangular
hb=base[2];							// longitud de la base
nb=lim(4,base[3],50);					// número de lados del prisma base

ht=h+hb;

difference(){
	pyramid_circumscribed(d1=db1,d2=db2,h=ht,n=nb);
	translate([0,0,hb])
		cylinder (r=d/2,h=h+0.1);	
	}
}

/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

i=25;

// ------ Ejemplos de pines -------------------------------

// pines machos
pin_simple(pin=[10,18,SIMPLE],base=[12,11,3,0],correction=0);

translate([i,0,0])
	pin_expand(pin=[10,15,TABNORMAL],base=[15,0,3,6],correction=0);

translate([2*i,0,0])
	pin(pin=[8,12,TABNORMAL],base=[20,12,3,8],correction=0);

// pines hembra - volumenes a restar
%translate([0,i,0])
	socket_polygonal(pin=[10,18,SIMPLE]);
		
translate([0,i,-1])
	pin_simple(pin=[10,18,SIMPLE],base=[12,12,1,50],correction=0);

translate([i,i,0])
	socket_expand(pin=[10,22,TABNORMAL]);

translate([2*i,i,0])
	socket(pin=[10,22,TABNORMAL]);

// Conjunto pin simple dentro de vaina simple
translate([0,2*i,0])
difference(){
	color("red")
	rotate([0,0,90])
	socket_polygonal_pod(pin=[12,18,SIMPLE],t=2)
		translate([0,0,2.5])
			cube([19,19,5],center=true);
	color("green")
	translate([0,12.5,32])
		cube([25,25,50],center=true);
	}
translate([0,2*i,0])
	pin_simple(pin=[12,18,SIMPLE],base=[0,0,0,0],correction=0.0);

// Conjunto pin que se expande en la punta dentro de la vaina
translate([i,2*i,0])
difference(){
	color("green")
	socket_expand_pod(pin=[10,18,TABNORMAL],t=2)
		translate([0,0,2.5])
			cube([19,19,5],center=true);
	color("red")
	translate([0,12.5,32])
		cube([25,25,50],center=true);
	}
translate([i,2*i,0])
	rotate([0,0,45])
	pin_expand(pin=[10,18,TABNORMAL],base=[0,0,0,0],correction=0);

// Conjunto pin general
translate([2*i,2*i,0])
difference(){
	color("blue")
	rotate([0,0,90])
	socket_pod(pin=[15,18,TABFINE],t=1)
		translate([0,0,2.5])
			cube([19,19,5],center=true);
	color("orange")
	translate([0,12.5,32])
		cube([25,25,50],center=true);
	}
translate([2*i,2*i,0])
	rotate([0,0,45])
	pin(pin=[15,18,TABFINE],base=[0,0,0,0],correction=0);




// ------ Ejemplos de alojamiento para botones automáticos ----------------

translate([-i,0,0])
	gap_button_female(PF=PON,correction=0.2);

translate([-i,i,0])
	gap_button_female_pod(PF=COS11,correction=0.1,t=1.5)
		translate([0,0,1])
			cube([24,24,2],center=true);

translate([-i*2,0,0])
	gap_button_male(PF=COS11,correction=0.2);

translate([-i*2,i,0])
	gap_button_male_pod(PF=PON,correction=0.1,t=2)
		translate([0,0,1])
			cube([24,24,2],center=true);

translate([-i,i*2,0])
	gap_button_male_base(PF=PON,correction=0.1,base=[22,10,1,8]);

translate([-i*2,i*2,0])
	gap_button_female_base(PF=COS11,correction=0.1,base=[22,10,2,5]);
		

