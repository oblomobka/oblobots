///////////////////////////////////////////////////////////////////////////////////////////////
// arm [OBLOBOTS] 
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

//////////////////////////////////////////////////////////////////
///////////// MODULO arm_cylindrical()  //////////////////////////

module arm_cylindrical (	arm=[18,6,45],		// [d,h,l]
						hand=[27,4,120]		// [d,h,ang]
						){

armd=lim(10,arm[0],40);				// medida del brazo: fondo
armh=lim(5,arm[1],25);				// medida del brazo: ancho

handd=lim(10,hand[0],60);
handdi=handd/2;
handh=lim(3,hand[1],armh-0.5);
handang=lim(0,hand[2]/2,180);	//max(0,min(180,hand[2]/2));

arml=lim(armd+handd,arm[2],120);		// medida del brazo: longitud


armd2=armd-armh;
wrist=handd/3;
armhi=armh/2;
armli=arml-armd/2-handd/2;



$fn=50;

// --------- Volumen ----------------

union(){
	difference(){
		union(){
			// brazo
			hull(){
				translate([0,0,armh-armhi])
					cylinder(r=armd/2,h=armhi);
				translate([0,0,0])
					cylinder(r=armd2/2,h=armh-armhi);
				translate([armli-handd/2+wrist/2,0,0])
					cylinder(r=wrist/2,h=handh-1.5);
				}
			// mano
			translate([armli,0,0])
				cylinder(r1=handd/2,r2=(handd/2)*1,h=handh);
			}
			// hueco de la mano
			translate([armli,0,0])
				cylinder(r=handdi/2,h=armh*2+2,center=true);
			// Garra
			for(i=[0,1]){
				mirror([0,i,0])		
					difference(){
						translate([armli,-0.01,-2])
							cube([handd,handd,2*armh-2]);
						translate([armli,0,-2])
							rotate([0,0,handang])
								cube([handd,handd,2*armh-2]);
						}
				}
		}

	if(hand[2]>=180){
		for(i=[0,1]){
			mirror([0,i,0])
				translate([armli+handd/4,3*(handd-handdi)/4,handh/2])
					cube([handd/2,(handd-handdi)/2,handh],center=true);
			}
		}
	}
}

// -------------- Fin del módulo arm_cylindrical () -----------------------
// ------------------------------------------------------------------------

//////////////////////////////////////////////////////////////////
///////////// MODULO arm_union_cylindrical()  ////////////////////

module arm_union_cylindrical (	arm=[18,10,2,65],			// [d,h,l]
								hand=[22,8,120],			// [d,h,ang]
								pin=[8,15,TABNORMAL],		// [d,h,TAB]	medidas generales del pin
								PF=NULL,					// Opcional, define el botón aut., si existe se anula el pin[],	
								correction=0
								){

pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin

armd=lim(pind+1,arm[0],40);			// medida del brazo: fondo
armh=lim(5,arm[1],25);				// medida del brazo: ancho
armpit=lim(0,arm[2],60);				// medida de la axila

handd=lim(10,hand[0],60);

arml=lim(armd+handd,arm[3],120);		// medida del brazo: longitud
armlim=[armd,armh,arml];

//color(arms_color)
union(){
	arm_cylindrical(arm=armlim,hand=hand);
	if(PF==NULL){
		if(armpit==0){
			translate([0,0,armh])
				pin(pin=pin,base=[armd,pind+1,armpit,0],correction=correction);
			}
		else{
			translate([0,0,armh])
				pin(pin=pin,base=[armd,pind+1,armpit,50],correction=correction);
			}
		}
	else{
		translate([0,0,armh])
			gap_button_male_base(PF=PF,base=[armd,PF[5],armpit,50],correction=correction);
		}
	}
}


// -------------- Fin del módulo arm_union_cylindrical () -----------------
// ------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////
/////////////////// MODULO arm_quadrangle()  ///////////////////////////

module arm_quadrangle (	arm=[10,15,70],		// [ grosor(x), fondo(y), longitud(z) ] Medidas de los Brazo
						hand=[20,5,8]
						){

armx=lim(5,arm[1],25);			// medida del brazo: grosor
army=lim(4,arm[0],40);			// medida del brazo: fondo

handd=lim(10,hand[0],60);
handh=lim(3,hand[1],armx-0.5);
handnreal=lim(4,2*floor(hand[2]/2),12);		// [4,6,8,10,12] nº de lados del polígono de la mano

arml=lim(army+5+handd,arm[2],120);		// medida del brazo: longitud



//side=2*tan(180/tn)*td/2;		// medida del lado

wrist=2*(handd/2)*tan(180/max(6,handnreal));
wristh=handh-1;
armli=arml-(army/2)-handd-(wrist/2);

translate([0,0,armx])
mirror([0,0,1])
union(){
	difference(){
		hull(){
			translate([0,0,armx/2])
				cube([army,army,armx],center=true);
			translate([armli,0,armx-wristh/2])
				cube([wrist,wrist,wristh],center=true);
			}
		// rebaje del hombro / forma poligonal
		translate([0,0,armx/2+0.5])
			prism_circumscribed (n=handnreal,d=2.5*army/4,h=armx/2);
		}
	difference(){
		translate([armli+wrist/2+handd/2,0,armx-handh])
			prism_circumscribed (n=handnreal,d=handd,h=handh);
		translate([armli+wrist/2+handd/2,0,0])
			prism_circumscribed (n=handnreal,d=handd/2,h=armx*2);
		translate([armli+wrist/2+3*handd/4,0,armx])
			cube([handd/2+1,handd/3,2*armx],center=true);
		}
	}
}

// -------------- Fin del módulo arm_quadrangle() -------------------------------
// ------------------------------------------------------------------------------

//////////////////////////////////////////////////////////////////
///////////// MODULO arm_union_quadrangle()  ////////////////////

module arm_union_quadrangle (	arm=[18,10,2,65],			// [grosor(x),fondo(y),armpit,longitud(z)] Medidas de los Brazo
							hand=[22,8,8],			// [d,h,n lados]
							pin=[8,15,TABNORMAL],		// [d,h]	medidas generales del pin
							PF=NULL,					// Opcional, define el botón aut., si existe se anula el pin[],
							correction=0	
							){

pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin

armx=lim(5,arm[1],25);				// medida del brazo: grosor
army=lim(pind+1,arm[0],40);			// medida del brazo: fondo
armpit=lim(0,arm[2],60);				// medida de la axila

handd=lim(10,hand[0],60);
handh=lim(3,hand[1],armx-0.5);
handnreal=lim(4,2*floor(hand[2]/2),12);		// [4,6,8,10,12] nº de lados del polígono de la mano

arml=lim(army+5+handd,arm[3],120);		// medida del brazo: longitud
armlim=[army,armx,arml];


//color(arms_color)
union(){
	arm_quadrangle(arm=armlim,hand=hand);
	if(PF==NULL){
		if(armpit==0){
			translate([0,0,armx])
				pin(pin=pin,base=[army,pind+1,armpit,0],correction=correction);
			}
		else{
			translate([0,0,armx])
				pin(pin=pin,base=[army,pind+1,armpit,4],correction=correction);
			}
		}
	else{
		translate([0,0,armx])
			gap_button_male_base(PF=PF,base=[army,PF[5],armpit,4],correction=correction);
		}
	}
}


// -------------- Fin del módulo arm_union_quadrangle () -----------------
// ------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

i=20;

translate([0,-i,0])
	arm_cylindrical(	arm=[18,7,55],hand=[24,6,180]);

translate([0,-3*i,0])
	arm_union_cylindrical (	arm=[18,10,3,65],
							hand=[22,8,75],
							pin=[8,15,SIMPLE],	
							PF=NULL,				
							correction=0);
translate([0,-5*i,0])
	arm_union_cylindrical (	arm=[30,10,5,65],
							hand=[22,8,75],
							pin=[8,18,TABNORMAL],	
							PF=NULL,				
							correction=0);

translate([0,-7*i,0])
	arm_union_cylindrical (	arm=[22,10,0,55],
							hand=[18,6,180],
							pin=[8,15,SIMPLE],	
							PF=COS11,				
							correction=0);

translate([0,i,0])
	arm_quadrangle(arm=[20,8,80],hand=[27,6,8]);

translate([0,3*i,0])
	arm_union_quadrangle (	arm=[18,8,2,55],
							hand=[18,6,4],
							pin=[8,15],	
							PF=COS11,				
							correction=0);

translate([0,5*i,0])
	arm_union_quadrangle (	arm=[20,12,1,75],
							hand=[28,8,10],
							pin=[12,15,SIMPLE],
							PF=NULL,				
							correction=0);

translate([0,7*i,0])
	arm_union_quadrangle (	arm=[25,10,1,70],
							hand=[20,8,8],
							pin=[8,18,TABFINE],
							PF=NULL,				
							correction=0);


