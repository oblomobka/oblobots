//////////////////////////////////////////////////////////////////////////////////////////////////
// HIP[OBLOBOTS] 
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
use <plus/functions.scad>


///////////////////////////////////////////////////////////
///////////// MÓDULO legs_position ()  ////////////////////

// Colocación relativa de 2 piernas en línea

module legs_position(		s,		// Normalmente el ancho de la cadera
						pos		// [0:100] factor de separación entre piernas
						){

pose=lim(3,pos,100)*(s/3.5)/100;				// factor de separación entre piernas

for(i=[0,1]){
	mirror([i,0,0])
		translate([pose,0,0])
			child(0);
	}
}

// -------------- Fin del módulo legs_position (s=x,pos=x) --------------
// ----------------------------------------------------------------------



//////////////////////////////////////////////////////////////////
/////////////////// MODULO hip_cylindrical  ///////////////////////

module hip_cylindrical(hip=[40,15,80]){	// [ d,h,f ] Medidas de la cadera


hipd=lim(25,hip[0],80);				// medida de la cadera: diámetro
hiph=lim(12,hip[1],70);				// medida de la cadera: altura
hipf=lim(0,hip[2],100);				// [0:100] factor que determina la posición del anillo intermedio 

hiph1=hiph-hipf*hiph/110;
hiph2=hiph-hiph1;

hipd1=max(3*hipd/4,(hipd-2*hiph1));  // diámetro inferior de la cadera

$fn=50;

// --------- Volumen ----------------

union(){
	cylinder(r1=hipd1/2,r2=hipd/2,h=hiph1);
	translate([0,0,hiph1])
		cylinder (r=hipd/2,h=hiph2);	
	}
}
// -------------- Fin del módulo hip_cylindrical() ------------------------
// ------------------------------------------------------------------------

//////////////////////////////////////////////////////////////////
/////////////////// MÓDULO hip_union_cylindrical()  ///////////////

module hip_union_cylindrical (
		hip=[45,22,80],			// [ d,h,f ] Medida de la cadera
		pin=[10,15,TABNORMAL],	// [ d, h ] medidas del pin
		waist=[0,0,0],			// [d1,d2,h] medidas y forma de la base del pin o del botón. Opcional
		legsposition=100,			// [0:100] factor que posiciona las piernas en la cadera
		PF=NULL,					// Opcional, define el botón aut., si existe se anula el pin[],
		correction=0				// corrección paa el botón automático
		){

pind=lim(4,pin[0],20);			// diametro del taladro (define el alojamiento de las piernas)
pinh=lim(5,pin[1],30);			// medida de la profundidad del taladro

hipd=lim(25,hip[0],80);
hiph=lim(pinh+2,hip[1],70);
hipf=lim(0,hip[2],100);
hiplim=[hipd,hiph,hipf];

hiph1=hiph-hipf*hiph/110;
hiph2=hiph-hiph1;

hipd1=max(3*hipd/4,(hipd-2*hiph1));		// diámetro inferior de la cadera

$fn=50;

union(){
	difference(){
		hip_cylindrical(hip=hiplim);
		legs_position(s=hipd1, pos=legsposition)
			if(PF!=NULL){
				gap_button_female(PF=PF,correction=correction);
				}
			else{			
				socket(pin=[pind,pinh,pin[2]]);
				}
		}
	if(PF==NULL){
			translate([0,0,hiph])
				pin(pin=[pind,pinh,pin[2]],base=[waist[0],waist[1],waist[2],50],correction=correction);
		}
	else{
		translate([0,0,hiph])
			gap_button_male_base(PF=PF,base=[waist[0],waist[1],waist[2],50],correction=correction);
		}
	}	
}
// ---------------- fin módulo hip_union_cylindrical() ---------------------
// -------------------------------------------------------------------------


//////////////////////////////////////////////////////////////////
/////////////////// MÓDULO hip_quadrangle()  /////////////////////

module hip_quadrangle (hip=[40,22,18]){			// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera


hipx=lim(20,hip[0],80);		// medida de la cadera: ancho
hipy=lim(15,hip[1],60);		// medida de la cadera: fondo
hipz=lim(10,hip[2],50);		// medida de la cadera: alto
hipb=hip[3];					// medida de la cadera: chaflán
hiplim=[hipx,hipy,hipz,hipb];

difference(){
	translate([0,0,hipz/2])
		cube ([hipx,hipy,hipz],center=true);
	for(i=[	[1,1,0],
			[1,-1,-90],
			[-1,1,90],
			[-1,-1,180]]){
		translate([i[0]*hipx,i[1]*hipy,0]/2)
			rotate([0,0,i[2]])rotate(45*[0,1,1])
				cube([min(2*hipb,((hipy-1)/2)),hipx,hipx],center=true);
		}
	}
}
// ------------ Fin del módulo hip_quadrangle(hip[x,y,z,b]) -------------
// ----------------------------------------------------------------------


//////////////////////////////////////////////////////////////////
/////////////////// MÓDULO hip_union_quadrangle()  ///////////////

module hip_union_quadrangle (	
		hip=[35,20,25,5],			// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
		pin=[10,15,TABNORMAL],	// [ d, h ] medidas del pin
		waist=[0,0,0,0],			// [d1,d2,h,n] medidas y forma de la base del pin o del botón. Opcional
		legsposition=100,			// [0:100] factor que posiciona las piernas en la cadera
		PF=NULL,					// Opcional, define el botón aut., si existe se anulan el pin[],
		correction=0				// corrección paa el botón automático
		){

pind=lim(4,pin[0],20);			// diametro del taladro (define el alojamiento de las piernas)
pinh=lim(5,pin[1],30);			// medida de la profundidad del taladro 

hipx=lim(20,hip[0],80);		// medida de la cadera: ancho
hipy=lim(pind+5,hip[1],60);		// medida de la cadera: fondo
hipz=lim(pinh+2,hip[2],50);	// medida de la cadera: alto
hipb=hip[3];					// medida de la cadera: chaflán
hiplim=[hipx,hipy,hipz,hipb];

//nbase=min(50,max(4,base[3]));			// lim:(4<-->50) nº de lados de las piernas
//basereal=[base[0],base[1],base[2],nbase];

$fn=50;
			
// --------- Volumen ----------------

union(){
	difference(){
		hip_quadrangle(hip=hiplim);
		legs_position(s=hipx, pos=legsposition)
			if(PF!=NULL){
				gap_button_female(PF=PF,correction=correction);
				}
			else{		
				socket(pin=[pind,pinh,pin[2]]);
				}
		}
	if(PF==NULL){
		translate([0,0,hipz])
			pin(pin=[pind,pinh,pin[2]],base=waist,correction=correction);
		}
	else{
		translate([0,0,hipz])
			gap_button_male_base(PF=PF,base=waist,correction=correction);
		}
	}	
}

// ---------------- fin módulo hip_union_quadrangle() ----------------------
// -------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

// Preformas cilindricas
translate([175,0,0])
	hip_union_cylindrical(	hip=[38,20,5],
							pin=[10,15,SIMPLE],
							waist=[20,11,0],
							legsposition=100,
							PF=COS11,
							correction=0);

translate([100,80,0])
	hip_union_cylindrical(	hip=[45,22,80],
							pin=[10,15,TABNORMAL],
							waist=[40,35,3],
							legsposition=100,
							PF=NULL,
							correction=0);

translate([100,0,0])
	hip_union_cylindrical(	hip=[45,22,80],
							pin=[10,15,SIMPLE],
							waist=[40,35,3],
							legsposition=100,
							PF=NULL,
							correction=0);

translate([35,0,0])
	hip_cylindrical(hip=[40,15,80]);


// Preformas rectangulares
translate([-175,80,0])
	hip_union_quadrangle(	hip=[42,25,10,3],	
						pin=[10,15,TABNORMAL],
						waist=[15,12,5,8],
						legsposition=100,	
						PF=NULL,
						correction=0);

translate([-175,0,0])
	hip_union_quadrangle(	hip=[35,20,25,5],	
						pin=[10,15,SIMPLE],
						waist=[16,12,5,4],
						legsposition=100,	
						PF=NULL,
						correction=0);

translate([-100,0,0])
	hip_union_quadrangle(	hip=[35,20,25,5],	
						pin=[10,15,SIMPLE],
						waist=[16,12,1,5],
						legsposition=100,	
						PF=PON,
						correction=0);

translate([-35,0,0])
	hip_quadrangle(hip=[40,23,20,5]);

