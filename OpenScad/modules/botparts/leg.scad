//////////////////////////////////////////////////////////////////////////////////////////////////
// LEG[OBLOBOTS] 
//
// v.06
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Oct 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <plus/external_elements.scad>
include <plus/presets.scad>

use <plus/functions.scad>
use <plus/union.scad>
use <plus/parts.scad>
use <hip.scad>


/////////////////////////////////////////////////////////////////
/////////////////// MÓDULO leg_cylindrical()  ///////////////////

module leg_cylindrical (	leg=[12,45],		// [d,h] Medidas de la pierna (la altura incluye el pie)
						foot=[40,5]		// [long,h] Medidas del pie
						){
$fn=50;

legd=lim(6,leg[0],20);			// medida de la pierna: diámetro
legh=lim(20,leg[1],70);			// medida de la pierna: longitud

footl=lim(24,foot[0],55);			// medida del pie: longitud	
footh=lim(0,foot[1],40);			// medida del pie: altura (sin contar la altura de la base (heel))

legdtop=legd+1;					// medida de la pierna: grosor superior 
legdbot=legd-1.5;					// medida de la pierna: grosor inferior

footd=legdbot+5;					// medida del pie: ancho en el talón
pointfootd=footd*0.7;				// medida del pie: ancho en la punta

footli=footl-(pointfootd+footd)/2;

heel=3;

leghi=legh-footh-heel;

rotate([0,0,90])
	union(){
		translate([0,0,heel+footh])
			cylinder (r2=legdtop/2,r1=legdbot/2,h=leghi);				
				difference(){
					hull(){
						cylinder (r=footd/2,h=heel);
						translate([0,-footli,0])
							cylinder (r=pointfootd/2,h=2);
						translate([0,0,heel])
							cylinder(r=legdbot/2,h=footh);
						}
					hull(){
						cylinder (r=(footd-2)/2,h=2,center=true);
						translate([0,-footli,0])
							cylinder (r=(pointfootd-2)/2,h=2,center=true);
						}
					}
		}
}
// -------------- Fin del módulo leg_cylindrical() ------------------------
// ------------------------------------------------------------------------

//////////////////////////////////////////////////////////////////
/////////////////// MÓDULO legs_union_cylindrical()  //////////////

module legs_union_cylindrical (	
		hip=[40,15,80],				// [ d,h,f ] Medidas de la cadera donde van las piernas
		legs=[30,100],				// medida de las piernas: altura (incluye la altura del pie)
		pin=[10,15,TABNORMAL],		// [ d, h ] medidas del pin. Existe si PF=NULL. Por defecto
//		legsposition=100,				// [0:100] factor que posiciona las piernas en la cadera
		foots=[30,3],					// medida del pie: longitud, altura
		PF=NULL,						// Opcional, define el botón aut., si existe se anula el pin[],
		correction=0,				// Normalmente 	si se usa pin será negativo
									// 				si se usa botón será positivo
		angle=45						//angulo de los pies
								){

pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin

legh=lim(20,legs[0],60);
legsposition=lim(0,legs[1],100);

hipd=lim(25,hip[0],80);
hiph=lim(pinh+2,hip[1],70);
hipf=lim(0,hip[2],100);

hiph1=hiph-hipf*hiph/110;
hiph2=hiph-hiph1;

hipd1=max(3*hipd/4,(hipd-2*hiph1));  // diámetro inferior de la cadera

legs_position(s=hipd1, pos=legsposition)	
	leg_union (	legh=legh,pin=[pind,pinh,pin[2]],foot=foots,PF=PF,correction=correction,angle=angle);

// ----- Modulos auxiliares ------------

// Formas auxiliares
module leg_union (	legh, 				// medida de la pierna: longitud
					pin,
					foot,
					PF,
					correction,
					angle									//angulo de los pies
					){

dpress=PF[4]+1+correction;				// medida de la pierna: grosor (diametro del pin)

footl=lim(24,foot[0],55);							// medida del pie: longitud	
footh=lim(0,foot[1],40);							// medida del pie: altura


// Caso en el que no se define un botón automático (por defecto) se dibujará un pin que se expande en la punta
if(PF==NULL){	
	rotate([0,0,angle])
		union(){
			leg_cylindrical(leg=[pind,legh],foot=[footl,footh]);
			translate([0,0,legh])
				pin(pin=pin,correction=correction);
			}
	}
	else{
		rotate([0,0,angle])
			union(){
				leg_cylindrical(leg=[dpress,legh-PF[5]],foot=[footl,footh]);
				rotate([0,0,90])
					translate([0,0,legh-PF[5]])
						gap_button_male_base(	PF=PF,
											base=[dpress,dpress,0,50],
											correction=correction);	
				}
		}
	}
// ----- Fin de los módulos auxiliares ------------
}

// -------------- Fin del módulo legs_union_cylindrical() ------------------
// ------------------------------------------------------------------------

//////////////////////////////////////////////////////////////////
///////////// MÓDULO leg_quadrangle ();  ////////////////////

module leg_quadrangle (	leg=[10,15,8], 		// [ d, h, num de lados ] Medidas de la pierna (incluye el pie)
						foot	=[35,4]			// [ long, h ] Medidas dele pie
						){

legd=lim(6,leg[0],20);
legh=lim(20,leg[1],70);					// medida de la pierna: longitud
legn=lim(4,leg[2],16);					// lim:(4<-->16) nº de lados de las piernas

footl=lim(24,foot[0],55);			// medida del pie: longitud	
footh=lim(0,foot[1],40);			// medida del pie: altura (sin contar la altura de la base (heel))

legdtop=legd+1;					// medida de la pierna: grosor superior 
legdbot=legd-1.5;					// medida de la pierna: grosor inferior

footw=legdbot+5;					// medida del pie: ancho en el talón
pointfootw=footw*0.7;				// medida del pie: ancho en la punta

footli=footl-(pointfootw+footw)/2;

heel=3;

leghi=legh-footh-heel;

rotate([0,0,90])
	union(){
		translate([0,0,heel+footh])
			pyramid_circumscribed (n=legn,d2=legdtop,d1=legdbot,h=leghi);				
				difference(){
					hull(){
						translate([0,0,heel/2])
							cube([footw,footw,heel],center=true);
						translate([0,-footli,1])
							cube([pointfootw,pointfootw,2],center=true);
						translate([0,0,heel])
							prism_circumscribed(d=legdbot,h=footh,n=legn);
						}
						hull(){
							cube([footw-2,footw-2,1.5],center=true);
							translate([0,-footli,0])								
								cube([pointfootw-2,pointfootw-2,1.5],center=true);
							}
						}
		}
}

// ------ Fin del módulo leg_quadrangle(leg=[d,h,n],foot=[l,h]) --------
// ----------------------------------------------------------------------


//////////////////////////////////////////////////////////////////
/////////////////// MÓDULO legs_union_quadrangle()  //////////////

module legs_union_quadrangle (	
		hipx=40,						// medida de la cadera: ancho	
		legs=[40,7,100],				// medida de las piernas [ longitud, número de lados]
		pin=[10,15,TABNORMAL],		// [ d, h ] medidas del pin. Existe si PF=NULL. Por defecto
		foots=[32,6],					// medida del pie: longitud
		PF=NULL,						// Opcional, define el botón aut., si existe se anulan el pin[],
		correction=0,				// Normalmente 	si se usa pin será negativo
									// 				si se usa botón será positivo
		angle=45						//angulo de los pies
		){

hipx1=lim(20,hipx,80);

legh=lim(20,legs[0],70);					// medida de la pierna: longitud
legn=lim(4,legs[1],16);					// lim:(4<-->16) nº de lados de las piernas
legsposition=lim(0,legs[2],100);

legs_position(s=hipx1, pos=legsposition)	
	leg_union (	leg=[legh,legn],
				pin=pin,
				foot=foots,
				PF=PF,
				correction=correction,
				angle=angle);

// ----- Modulos auxiliares ------------

// Formas auxiliares
module leg_union (	leg, 
					pin,
					foot,
					PF,
					correction,
					angle=45				//angulo de los pies
					){

pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin

dpress=PF[4]+1+correction;			// medida de la pierna: grosor

footl=lim(24,foot[0],55);			// medida del pie: longitud	
footh=lim(0,foot[1],40);			// medida del pie: altura


// Caso en el que no se define un botón automático (por defecto) se dibujará un pin que se expande en la punta
if(PF==[0,0,0,0,0,0]){	
	rotate([0,0,angle])
		union(){
			leg_quadrangle(leg=[pind,leg[0],leg[1]],foot=[footl,footh]);
			translate([0,0,leg[0]])
				pin(pin=pin,correction=correction);
			}
	}
	else{
		rotate([0,0,angle])
			union(){
				leg_quadrangle(leg=[dpress,leg[0]-PF[5],leg[1]],foot=[footl,footh]);
				rotate([0,0,90])
					translate([0,0,leg[0]-PF[5]])
						gap_button_male_base(	PF=PF,
											base=[dpress,dpress,0,leg[1]],
											correction=correction);	
				}
		}
	}
// ----- Fin de los módulos auxiliares ------------
}

// -------------- Fin del módulo legs_union_quadrangle() ------------------------
// ------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

// Preformas cilindricas

translate([145,0,0])
	legs_union_cylindrical(	hip=[40,15,80],
							legs=[40,100],
							foots=[35,3],
							pin=[10,15,SIMPLE],
							PF=NULL,
							correction=0,
							angle=30	);


translate([85,0,0])
	legs_union_cylindrical(	hip=[40,15,80],
							legs=[30,100],
							foots=[45,3],
							pin=[12,15,TABFINE],
							PF=NULL,
							correction=0,
							angle=75	);

translate([20,0,0])
	rotate([0,0,90])
		leg_cylindrical(leg=[12,45],foot=[40,5]);

// Preformas rectangulares
translate([-245,0,0])
	legs_union_quadrangle(	hipx=45,
							legs=[35,7,80],
							pin=[8,20,TABNORMAL],
							foots=[35,0],
							PF=NULL,	
							correction=0,
							angle=10);

translate([-165,0,0])
	legs_union_quadrangle(	hipx=50,
							legs=[35,5,80],
							pin=[10,15,SIMPLE],
							foots=[25,15],
							PF=NULL,	
							correction=0,
							angle=38);

translate([-85,0,0])
	legs_union_quadrangle(	hipx=40,
							legs=[40,7,100],
							pin=[10,15,SIMPLE],
							foots=[45,6],
							PF=COS11,	
							correction=0,
							angle=70);
translate([-20,0,0])
	rotate([0,0,90])
		leg_quadrangle(leg=[8,40,5],foot=[35,5]);

