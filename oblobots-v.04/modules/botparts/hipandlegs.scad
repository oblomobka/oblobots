//////////////////////////////////////////////////////////////////////////////////////////////////
// hipandlegs[OBLOBOTS] 
//
// v.04
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Sep 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

use <plus/union.scad>
use <plus/parts.scad>

//////////////////////////////////////////////////////////////////
/////////////////// MÓDULO hipQ()  ///////////////////////////////

module hipQ (	hip=[35,20,12,5],		// [ ancho(x), fondo(y), altura(z), chaflán ] Medida de la cadera
				legdrill=8,			// diametro del taladro (define el alojamiento de las piernas)				
				legb=100				// [0:100] factor de separación entre piernas						
				){


hipx=hip[0];			// medida de la cadera: ancho
hipy=hip[1];			// medida de la cadera: fondo
hipz=hip[2];			// medida de la cadera: alto
hipb=hip[3];			// medida de la cadera: chaflán

legdrillh=10;		// medida de la profundidad del taladro !!! Debe coincidir con pinh de legsQ()

$fn=50;
			
// --------- Volumen ----------------

translate([0,0,-hipz])
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

		legsposition(s=hipx, legb=legb)		
			drill2(d=legdrill,h=legdrillh);
	}



// ----- Modulos auxiliares ------------

// --- Posición de las piernas

module legsposition(	s=40,	// Normalmente el ancho de la cadera
					legb=100	// [0:100] factor de separación entre piernas
					){

legb=max(3,min(legb,100))*(s/3.5)/100;				// factor de separación entre piernas

	translate([legb,0,0])
		child(0);
	mirror([1,0,0])
		translate([legb,0,0])
			child(0);
}

// ----- Fin de los módulos auxiliares ------------

}

// -------------------------- fin módulo hipQ() ----------------------------
// -------------------------------------------------------------------------


//////////////////////////////////////////////////////////////////
/////////////////// MÓDULO legsQ()  //////////////////////////////

module legsQ (	hipx=40,			// medida de la cadera: ancho	
				legd=8,			// medida de la pierna: grosor
				legh=20,			// medida de la pierna: longitud
				legp=4,			// nº de lados de las piernas
				legb=80,			// [0:100] factor de separación entre piernas
				foot=25,			// medida del pie: longitud
				){

pinh=10;				// altura del pin de las piernas !!! Debe coincidir con drillh de hipQ()

//translate([0,0,-2*pinh])
legsposition(s=hipx, legb=legb)	
		leg (d=legd,h=legh,fl=foot,pinh=pinh,legp=legp);

// ----- Modulos auxiliares ------------

// Posición de las piernas
module legsposition(	s=40,	// Normalmente el ancho de la cadera
					legb=100	// [0:100] factor de separación entre piernas
					){

legb=max(3,min(legb,100))*(s/3.5)/100;				// factor de separación entre piernas

	translate([legb,0,0])
		child(0);
	mirror([1,0,0])
		translate([legb,0,0])
			child(0);
}

// Formas auxiliares
module leg (	d=8,			// medida de la pierna: grosor (diametro del pin)
			h=20,		// medida de la pierna: longitud
			fl=25,		// medida del pie: longitud			
			pinh=10,		// altura del pin de las pierna
			legp=5			// nº de lados de las piernas
			){

ang=125;			//angulo de los pies
fw=d+3;			//medida del pie: ancho
fh=3;			//medida del pie: altura
	
union(){
	rotate([0,180,ang])
		pyramid_C (n=max(4,legp),d1=d+1,d2=d-2,h=h);
	rotate([0,0,ang])translate([-fl/2+(d+2)/2,0,-(h+fh/2)])
		difference(){
			cube([fl,fw,fh],center=true);
			translate([0,0,-2])cube([fl-2,fw-2,fh],center=true);
		}
	pin2(d=d,h=pinh,k=0.3,s=0.1);
	}
}

// ----- Fin de los módulos auxiliares ------------

}

// -------------- Fin del módulo legsQ() ----------------------------------
// ------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////


hipx=35; 		// (Q) medida de la cadera: ancho
hipy=20;			// (Q) medida de la cadera: fondo
hipz=15;			// (Q) medida de la cadera: alto
hipb=5;			// (Q) medida de la cadera: chaflán

legd=8;			// medida de la pierna: grosor || También del pin que entra en la cadera
c=0;				// correción (puede ser necesario para ajustar el pin al drill)
legdrill=legd+c;	// diametro del taladro (define el alojamiento de las piernas)

legh=20;			// medida de la pierna: longitud

legb=80;		// [0:100] factor de separación entre piernas
legp=4;			// nº de lados de las piernas

foot=40;			// medida del pie: longitud


// variables auxiliares

hiph1=hiph-max(0,min(hipf,100))*hiph/110;

hipd1=max(3*hipd/4,(hipd-2*hiph1));



hipQ(hipx=hipx,hipy=hipy,hipz=hipz,hipb=hipb,legdrill=legdrill,legb=legb);

translate([0,0,-hipz-20])
	legsQ(legd=legd,legh=legh,legp=legp,hipx=hipx,legb=legb,foot=foot);
