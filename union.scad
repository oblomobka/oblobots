//////////////////////////////////////////////////////////////////////////////////////////////////
// union [OBLOBOTS] 
// v.04 
// elementos de unión entre las partes del cuerpo de los oblobots
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Sep 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license ???
//////////////////////////////////////////////////////////////////////////////////////////////////

use <parts.scad>

//////////////////////////////////////////////////////
////////// MÓDULOS TIPO MACHO-HEMBRA /////////////////

/////////// MACHOS ///////////

// ---- Pin cilíndrico simple. Tiene un ligero achafalnado en la punta
module pin0(	d=15,	// diámetro del pin
			h=10	,	// longitud del pin
			db1=0,	// diámetro de la base1
			db2=0,	// diámetro de la base2 si es =db1 es un cilindro
			hb=0	,	// longitud de la base
			n=32		// número de lados del prisma base
			){
$fn=50;
h1=1;
h2=h-h1;

translate([0,0,hb])
union(){
	cylinder(r=d/2, h=h2);
	translate([0,0,h2])
		cylinder (r1=d/2,r2=(d-2)/2,h=h1);
	translate([0,0,-hb])
	pyramid_C(d1=db1,d2=db2,h=hb,n=n);
	}
	
}

// --- pin que se ensancha en la punta
module pin2 (	d=8,	// diámetro del taladro
				h=20	,	// longitud del pin
				db1=0,	// diámetro de la base1
				db2=0,	// diámetro de la base2 si es =db1 es un cilindro
				hb=0	,	// longitud de la base
				n=0,		// número de lados del prisma base
				k=0.3,	// marca el espesor de la pestaña
				s=0.3	// holgura
				){
$fn=50;

dp=d+0.8;
hp=h/10;
space=s;
k1=d*k;

translate([0,0,hb])
difference(){
union(){
cylinder(r=(d-space)/2,h=h/2);
translate([0,0,h/2])
cylinder(r1=(d-space)/2,r2=(dp-space)/2,h=h/2-h/10);
translate([0,0,h-h/10])
	cylinder (r1=(dp-space)/2,r2=(d-1)/2,h=h/10-0.5);
translate([0,0,-hb])
	pyramid_C(d1=db1,d2=db2,h=hb,n=n);
}

translate([0,0,h])
for(i=[90,180]){
	rotate([0,0,i])
		union(){
			cube([2*d,d/8,h],center=true);
			translate([0,0,-h/2])rotate([90,0,0])
				cylinder(r=d/16,h=2*d,center=true);
			}
	}

cylinder(r=k1/2,h=3*h, center=true);
}

}


////////// HEMBRAS ////////////////////

// --- Taladro poligonal para volumen macizo
module drill0 (	d=12,	// diámetro del taladro
				h=6		// profundidad del taladro
				){
$fn=50;
s=6;			// Nº de lados del taladro (el taladro es poligonal, normalmente será hexagonal)

translate([0,0,-0.2])
	intersection(){
		cylinder (r=(d/cos(180/s))/2,h=h,$fn=s);
		cylinder (r=(d+d/20)/2,h=h);
	}
}

// --- Taladro poligonal para volumen hueco - Añade una caña donde alojar el pin
module drill1 (	d=12,	// diámetro del taladro
				h=15		// profundidad del taladro
				){
$fn=50;
s=6;			// Nº de lados del taladro (el taladro es poligonal, normalmente será hexagonal)
e=3;			// espesor de la caña donde se alojará el pin correspondiente

difference(){
	child (0);
	cylinder (r=(d+2*e)/2,h=2*h,center=true);	
	}

difference(){
	cylinder (r=(d+e)/2,h=h);
	translate([0,0,-1])
		intersection(){
			cylinder (r=(d/cos(180/s))/2,h=h,$fn=s);
			cylinder (r=(d+d/20)/2,h=h);
		}
	}
}


// --- Taladro que se ensancha en la punta
module drill2 (	d=12,	// diámetro del taladro
				h=25		// profundidad del taladro
				){
$fn=50;

dp=d+0.8;
hp=h/10;

union(){
	translate([0,0,-0.5])
		cylinder(r=d/2,h=0.5+h/2);
	translate([0,0,(h-0.05)/2])
		cylinder(r1=d/2,r2=dp/2,h=h/2-h/10);
	translate([0,0,h-h/10-0.025])
		cylinder (r1=dp/2,r2=(d-1)/2,h=h/10);
	}
}

// --- Taladro que se ensancha en la punta con caña
module drill3 (	d=12,	// diámetro del taladro
				h=25		// profundidad del taladro
				){
$fn=50;

dp=d+0.8;
hp=h/10;
e=1.5;				// espesor de la caña donde se alojará el pin correspondiente

difference(){
	child (0);
	color("red")
	cylinder (r=(d+2*e)/2,h=2*h,center=true);	
	}

color("green")
difference(){
	cylinder (r=(d+2*e)/2,h=h);
	union(){
	translate([0,0,-0.5])
		cylinder(r=d/2,h=0.5+h/2);
	translate([0,0,(h-0.05)/2])
		cylinder(r1=d/2,r2=dp/2,h=h/2-h/10);
	translate([0,0,h-h/10-0.025])
		cylinder (r1=dp/2,r2=(d-1)/2,h=h/10);
	}
}
}

// -------------- Fin de los módulos tipo macho-hembra --------------------
// ------------------------------------------------------------------------

//////////////////////////////////////////////////////
////////// MÓDULOS TIPO BOTÓN AUTOMÁTICO /////////////

////////// HEMBRAS ////////////////////

// Dibuja un cilindro que se debe restar del bloque principal donde se colocará el botón

module auto_button_f0 (	typ,		// Tipo de botón
						c=0.1		// corrección, para ajustar el diámetro
						){

e=2;			// pared

h=typ[1]+0.1;
d=typ[0]+c;

hs=max(0,typ[3]-h);
ds=typ[2];

$fn=50;

translate([0,0,-0.1])
union(){
cylinder (r=d/2,h=h);
translate([0,0,h+0.3])
cylinder (r=ds/2,h=hs);
}	
}

// Asociado al modelo principal (como si fuera una modificación) resta y añade el alojamiento del botón
module auto_button_f1 (	typ,		// Tipo de botón
						c=0		// corrección, para ajustar el diámetro

						){

e=2;			// pared
	
h=typ[1];
d=typ[0]+c;

$fn=50;

difference(){
	child (0);
	cylinder (r=(d+2*e)/2,h=2*(h+e),center=true);	
	}

difference(){
	cylinder (r=(d+2*e)/2,h=h+e);
	translate([0,0,-0.1])
		cylinder (r=d/2,h=h);
			
		}
}


/////////// MACHOS ///////////

// Dibuja un cilindro que se debe restar del bloque principal donde se colocará el botón
module auto_button_m0 (	typ,		// Tipo de botón
						c=0		// corrección, para ajustar el diámetro
						){

h=typ[5]+0.3;
d=typ[4]+c;

$fn=50;

translate([0,0,-0.1])
cylinder (r=d/2,h=h);			
}

// Asociado al modelo principal (como si fuera una modificación) resta y añade el alojamiento del botón
module auto_button_m1 (	typ,		// Tipo de botón
						c=0		// corrección, para ajustar el diámetro
						){

e=2;			// pared	

h=typ[5];
d=typ[4]+c;

$fn=50;

difference(){
	child (0);
	cylinder (r=(d+2*e)/2,h=2*(h+e),center=true);	
	}

difference(){
	cylinder (r=(d+2*e)/2,h=h+e);
	translate([0,0,-0.1])
		cylinder (r=d/2,h=h);
			
		}
}

// Asociado al modelo principal (como si fuera una modificación) resta y añade el alojamiento del botón
// añade un pedestal en el volumen principal

module auto_button_m2 (	typ,		// Tipo de botón
						c=0,		// corrección, para ajustar el diámetro
						hb=0,	// longitud de la base
						db=15,	// diámetro de la base
						n=8,		// número de lados del prisma base
						z=0		// posiciona la pieza en altura
						){

//e=2;			// pared	

h=typ[5]+0.3;;
d=typ[4]+c;


ht=h+hb;

$fn=50;

difference(){
	child (0);
	translate([0,0,z+0.05])
	translate([0,0,-h+hb])
		cylinder (r=d/2,h=h);	
	}


translate([0,0,z-h])
difference(){
	prism_C(d=db,h=ht,n=n);
	translate([0,0,+0.05+hb])
		cylinder (r=d/2,h=h);	
	}
}

/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////


//-- sizes Buttons

PON = [11.7,2.35,0,0,11.7,1.6 ];	// [ diametro H, espesor H, d centro H, saliente H, diámetro M, espesor M]
PRY = [11,2.2,0,0,11,2.0 ];		// [ diametro H, espesor H, d centro H, saliente H, diámetro M, espesor M]
COS11 = [10,1.3,3.5,3,9.6,0.7];	// [ diámetro H, espesor H, d centro H, saliente H, diámetro M, espesor M]
