///////////////////////////////////////////////////////////////////////////////////////////////
// head [OBLOBOTS] 
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
/////////// MODULO head_cylindrical () ///////////////////////////

module head_cylindrical (		H=1,
							head=[30,35,40], 			//
							headt=2,					// medida de la cabeza: altura 
							E=4,						// Tipo de ojo:	1 -> hueco rebajado
													//				2 -> alojamiento para led 5mm
													//				3 -> cono ciego
													//				4 -> hueco con reborde
							eye=[12,5],				// [d,h]
							expression=[-45,50,20],		// [exp1,exp2,sep] valores de expresión de los ojos	
							){

headh=lim(20,head[2],90);						// medida de la cabeza: altura
headd1=lim(20,head[0],60);					// medida de la cabeza: diámetro de base del cono
headd2=lim(15,head[1],2*headh+headd1);			// medida de la cabeza: diámetro de la punta del cono

headdi=di_cone(headd1,headd2,headh,headh/2);	// hdi

eyed1=lim(5,eye[0],headdi/2);					// Diámetro ojo (para tipos 1 y 3) //////edlim
eyeh=lim(3,eye[1],8);							// lo que sobresale el ojo (para tipos 2 y 3)

exp1=expression[0];							// factor de expresión de los ojos (para tipo 2)
exp2=lim(0,expression[1],100);				// factor de expresión de los ojos (para tipo 2)
eyeb=lim(0,expression[2],100);				// [0:100] factor de separación entre ojos.


eyer=r_circle_intersection(headdi,eyed);

ledn=5;						// medida del led. ojos tipo 2
eyeled=ledn+2;
eyed2=eyeled+2+2*eyeh;			// edledn


headdi1=headd1-2*headt;
headdi2=headd2-2*headt;

headhi1b=headh/2-0.75;
headdi1b=di_cone(headdi1,headdi2,headh,headhi1b);//headdi2+(headdi1-hdi2)*(1-hhi1b/hh);

headhi2a=headh/2+0.75;
headdi2a=di_cone(headdi1,headdi2,headh,headhi2a);//hdi2+(hdi1-hdi2)*(1-hhi2a/hh);


$fn=50;

if(E<=1){
	difference(){
		cylinder(r1=headd1/2,r2=headd2/2,h=headh);
		moveEyes (d=eyed1,bridge=eyeb)
				difference(){
					cylinder(r=eyed1/2,h=eyeh);
						rotate([0,0,exp1])
					translate([0,(2+(2*exp2/100))*eyed1/4,headh/2])
						cube([eyed1,eyed1,headh],center=true);
					}
			lower(cone=[headd1,headd2,headh],lower=[1,headt]);
		}
	}
	else{
	if(E==2){
			union(){
				difference(){
					union(){
						difference(){
							cylinder(r1=headd1/2,r2=headd2/2,h=headh);
							moveEyes (d=eyed2,bridge=eyeb)
								translate([0,0,5])
									rotate([0,180,0])
										cylinder(r=eyeled/2,h=5*headt);
							}
						moveEyes (d=eyed2,bridge=eyeb)
							rotate([0,180,0])			
								ledsocket_press(ledn=ledn,h=eyeh,expression=[exp1,exp2]);			
						}
					emptyhead_close(head=[headd1,headd2,headh],t=headt);
					}
				translate([0,0,headh/2-0.75])
					cylinder(r1=headdi1b/2,r2=headdi2a/2,h=1.5);
				}			
			}
			else{
				if(E==3){
					difference(){
						union(){
							cylinder(r1=headd1/2,r2=headd2/2,h=headh);
							moveEyes (d=eyed1,bridge=eyeb)
								rotate([0,180,0])
								blindcone(d=eyed1);
							}
					lower(cone=[headd1,headd2,headh],lower=[1,headt]);
					}
				}
				else{
					if(E>=4){
						difference(){
							union(){
								difference(){
									cylinder(r1=headd1/2,r2=headd2/2,h=headh);
									moveEyes (d=eyed1,bridge=eyeb)
										cylinder(r=eyed1/2,h=eyeh);
									}
								moveEyes (d=eyed1,bridge=eyeb)
									difference(){
										cylinder(r=eyed1/2,h=eyeh);
										cylinder(r=(eyed1-headt*1.5)/2,h=2*eyeh,center=true);
										}
								}
							lower(cone=[headd1,headd2,headh],lower=[headh/2-eyed1/2-2,headt]);
							}
						}
					}
				}
}
	



// ----- Modulos auxiliares ------------

module moveEyes(d,bridge){

eyeang=bridge*(50-atan2(d/2,headdi/2)-5)/100;

	if(E==1 || E>=4){
		for(i=[0,1]){
			mirror([i,0,0])
				rotate ([0,0,eyeang+atan2(d/2,headdi/2)+5])
					translate ([0,headdi/2+0.05,headh/2])
						rotate ([atan2(headh,(headd2-headd1)/2),0,0])
							child(0);
			}
	}
	else{
		if(E==2|| E==3){
			for(i=[0,1]){
				mirror([i,0,0])
					rotate ([0,0,eyeang+atan2(d/2,headdi/2)+5])
						translate ([0,r_circle_intersection(headdi,d),headh/2])
							rotate ([atan2(headh,(headd2-headd1)/2),0,0])
								child(0);
				}
			}
	}

}

module emptyhead_close(head=head,t=headt){

d1=head[0];
d2=head[1];
h=head[2];

di1=d1-2*t;
di2=d2-2*t;

hi=h-2*t;

hi1a=t;
di1a=di_cone(di1,di2,h,hi1a);

hi2b=h-t;
di2b=di_cone(di1,di2,h,hi2b);

translate([0,0,t])
	cylinder(r1=di1a/2,r2=min(di2b,2*h+di1a)/2,h=hi);
}


module lower(	cone,				// [ d1,d2,h ]
				lower				// [ rebaje, borde ]	
				){
coned1=cone[0];
coned2=cone[1];
coneh=cone[2];

lowerh=lower[0];
lowerb=lower[1];

lowerd2=coned2-2*lowerb;
lowerd1=coned1-2*lowerb;

lowerdi=di_cone(lowerd1,lowerd2,coneh,coneh-lowerh);//vd2+(vd1-vd2)*(1-((hh-vh)/hh));


translate([0,0,headh-lowerh+0.05])
	cylinder(r2=lowerd2/2,r1=lowerdi/2,h=lowerh);
}


}

// -------------- Fin del módulo head_cylindrical () --------
// ----------------------------------------------------------

///////////////////////////////////////////////////////////////////////////
/////////////////// MODULO head_union_cylindrical ()  //////////////////////

module head_union_cylindrical ( 	H=1,	
								head=[30,30,42],			// [d1,d2,h] medidas cono
								headt=2,					// grosor de la pared del cubo (si el cubo está vacío)
								E=4,						// Tipo de ojo:	1 -> hueco rebajado
														//				2 -> alojamiento para led 5mm		
														//				3 -> cono ciego
								eye=[15,5],				// [d,h]
								expression=[50,80,50],	// [exp1,exp2,sep] valores de expresión de los ojos
								pin=[10,15,TABNORMAL],	// [d,h]	medidas generales del pin
								PF=NULL,
								correction=0
								){

color(head_color)
if(E==2){
	if(PF==NULL){
		socket_pod (pin=pin,t=headt)
			head_cylindrical(H=H,head=head,headt=headt,E=E,eye=eye,expression=expression);
		}
	else{
		gap_button_female_pod (PF=PF,correction=correction,t=headt)
			head_quadrangle(H=H,head=head,headt=headt,E=E,eye=eye,expression=expression);
		}
	}
else{
	if(PF==NULL){
		difference(){
			head_cylindrical(H=H,head=head,headt=headt,E=E,eye=eye,expression=expression);
			socket(pin=pin);
			}
		}
	else{
		difference(){
			head_cylindrical(H=H,head=head,headt=headt,E=E,eye=eye,expression=expression);
			gap_button_female (PF=PF,correction=correction);
			}
		}
	}
	
}

// -------------- Fin del módulo head_union_cylindrical () -----------------------
// ------------------------------------------------------------------------------


///////////////////////////////////////////////////////////////////////////
/////////////////// MODULO head_quadrangle ()  ////////////////////////////

module head_quadrangle(	H=2,							// H=1 -> Cabeza cerrada
													// H=2 -> Cabeza abierta
						head=[40,40,40],				// [x,y,z] Aristas del cubo
						headt=2,						// grosor de la pared del cubo (si el cubo está vacío)
						E=3,							// Tipo de ojo:	1 -> hueco rebajado
													//				2 -> alojamiento para led 5mm		
													//				3 -> cono ciego
						eye=[15,8],					// [d,h]
						expression=[25,50,100],		// [exp1,exp2,sep] valores de expresión de los ojos
						){

$fn=50;

lowerh=0.6;					// rebaje de las caras de la cabeza
lowerb=3;					// borde sin rebajar


headx=lim(20,head[0],80);			// Arista X del cubo
heady=lim(20,head[1],80);			// Arista Y del cubo
headz=lim(20,head[2],80);			// Arista Z del cubo

eyed=lim(5,eye[0],headx/2-2*lowerh-1);		// Diámetro ojo (para tipos 1 y 3)
eyeh=lim(3,eye[1],8);						// lo que sobresale el ojo (para tipos 2 y 3)

exp1=180+expression[0];					// factor de expresión de los ojos (para tipo 2)
exp2=lim(0,expression[1],100);			// factor de expresión de los ojos (para tipo 2)
eyeb=lim(0,expression[2],100);			// [0:100] factor de separación entre ojos. Mayor valor -> Mayor separación

ledn=5;									// Diámetro nominal del led
eyeled=ledn+2;
eyed2=eyeled+2;
//eyeh2=min(eyeh,(headx-eyeled)/4);

eyeb1=eyeb*(headx/2-eyed-2*lowerh-1)/100;		// factor de separación para ojos rebajados
eyeb2=eyeb*(headx/2-eyed2-2*headt-1)/100;


// --------- Volumen ----------------
		
if(H<=1){	
if(E<=1){
	difference(){
		translate([0,0,headz/2])
			cube([headx,heady,headz],center=true);
			
		// -- Cuencas de los ojos				
		moveEyes(d=eyed,bridge=eyeb1)
			translate([0,0,-eyeh+0.1])
				difference(){
					cylinder (r=eyed/2,h=eyeh);
					rotate([0,0,exp1])
						translate([0,(2+(2*exp2/100))*eyed/4,eyeh/2])
							cube([eyed,eyed,2*eyeh],center=true);
					}
		lower(box=[headx,heady,headz],lower=[lowerh,lowerb]);				
		}
	}		
	else{
		if(E==2){
			union(){
				difference(){				
					emptyhead_close(head=[headx,heady,headz],t=headt);
						moveEyes(d=eyed2,bridge=eyeb2)
							cylinder (r=eyeled/2,h=headt*3,center=true);
					}
				moveEyes(d=eyed2,bridge=eyeb2)			
					ledsocket_press(ledn=ledn,h=3,expression=[exp1,exp2]);
				moveEars()
					blindcone(d=1.3*min(heady,headz)/2);
				translate([0,0,headz/2])
					cube([headx-2*headt,heady-2*headt,1.5],center=true);			
				}
			}
		else{
			if(E>=3){
				union(){
					translate([0,0,headz/2])
						cube([headx,heady,headz],center=true);
					moveEyes(d=eyed,bridge=eyeb1)
						blindcone(d=eyed);
					moveEars()
						blindcone(d=1.3*min(heady,headz)/2);
					}
				}
			}
	}	
}
else{
	union(){
		difference(){				
			emptyhead_open(head=[headx,heady,headz],t=headt);
			moveEyes(d=eyed2,bridge=eyeb2)
				cylinder (r=eyeled/2,h=headt*3,center=true);
			}
		moveEyes(d=eyed2,bridge=eyeb2)			
			ledsocket_press(ledn=ledn,h=3,expression=[exp1,exp2]);
		moveEars()
			blindcone(d=1.3*min(heady,headz)/2);
		translate([0,0,headz/2])
			cube([headx-2*headt,heady-2*headt,1.5],center=true);			
		}
}
	

// ----- Modulos auxiliares ------------

module moveEars(){

	for(i=[1,-1]){
		translate ([i*headx/2-0.1*i,0,headz/2])
			rotate ([0,i*90,0])
				child(0);				
	}
}

module moveEyes(d,bridge){

for(i=[0,1]){
	mirror([i,0,0])
		translate ([((d/2)+bridge+1),heady/2,headz/2])
			rotate ([-90,0,0])
				child(0);				
	}
}

module lower(	box,					// [ x,y,z ]
				lower				// [ rebaje, borde ]	
				){
boxx=box[0];
boxy=box[1];
boxz=box[2];

lowerh=lower[0];
lowerb=lower[1];

translate([0,0,boxz])
	translate([0,0,-lowerh/2+0.05])
		cube([boxx-2*lowerb,boxy-2*lowerb,lowerh],center=true);
translate([0,-boxy/2,boxz/2])
	rotate([90,0,0])
		translate([0,0,-lowerh/2+0.05])
			cube([boxx-2*lowerb,boxz-2*lowerb,lowerh],center=true);
translate([-boxx/2,0,boxz/2])
	rotate([0,-90,0])
		translate([0,0,-lowerh/2+0.05])
			cube([boxz-2*lowerb,boxy-2*lowerb,lowerh],center=true);
translate([boxx/2,0,boxz/2])
	rotate([0,90,0])
		translate([0,0,-lowerh/2+0.05])
			cube([boxz-2*lowerb,boxy-2*lowerb,lowerh],center=true);

}

// ------ Formas auxiliares --------------
module emptyhead_close(head=head,t=headt){

sx=head[0];
sy=head[1];
sz=head[2];

sxint=sx-2*t;		// Variables auxiliares
syint=sy-2*t;		// Variables auxiliares
szint=sz-2*t;		// Variables auxiliares

	difference(){
	translate([0,0,sz/2])
		cube([sx,sy,sz],center=true);
	translate([0,0,szint/2+t])
		cube([sxint,syint,szint],center=true);
	}
}

module emptyhead_open(head=head,t=headt){

sx=head[0];
sy=head[1];
sz=head[2];

sxint=sx-2*t;		// Variables auxiliares
syint=sy-2*t;		// Variables auxiliares
szint=sz-2*t;		// Variables auxiliares

h1=sz/2-t-1.5/2;
h2=sz/2;

difference(){
	translate([0,0,sz/2])
		cube([sx,sy,sz],center=true);
	translate([0,-t,h1/2+t])
		cube([sxint,sy,h1],center=true);
	translate([0,0,3*sz/4+1.5/2])
		cube([sxint,syint,sz/2],center=true);
	}
}
// ----- fin módulos auxiliares ------------
}

// -------------- Fin del módulo head_quadrangle () -----------------------------
// ------------------------------------------------------------------------------

///////////////////////////////////////////////////////////////////////////
/////////////////// MODULO head_union_quadrangle ()  //////////////////////

module head_union_quadrangle ( 	H=2,							// H=1 -> Cabeza cerrada
															// H=2 -> Cabeza abierta
								head=[30,30,30],				// [x,y,z] Aristas del cubo
								headt=2,						// grosor de la pared del cubo (si el cubo está vacío)
								E=2,							// Tipo de ojo:	1 -> hueco rebajado
														//				2 -> alojamiento para led 5mm		
														//				3 -> cono ciego
								eye=[10,5],				// [d,h]
								expression=[50,80,0],	// [exp1,exp2,sep] valores de expresión de los ojos
								pin=[10,15,SIMPLE],				// [d,h]	medidas generales del pin
								PF=NULL,
								correction=0
								){

color(head_color)
if(H>=2 || E==2){
	if(PF==NULL){
		socket_pod (pin=pin,t=headt)
			head_quadrangle(H=H,head=head,headt=headt,E=E,eye=eye,expression=expression);
		}
	else{
		gap_button_female_pod (PF=PF,correction=correction,t=headt)
			head_quadrangle(H=H,head=head,headt=headt,E=E,eye=eye,expression=expression);
		}
	}
else{
	if(PF==NULL){
		difference(){
			head_quadrangle(H=H,head=head,headt=headt,E=E,eye=eye,expression=expression);
			socket(pin=pin);
			}
		}
	else{
		difference(){
			head_quadrangle(H=H,head=head,headt=headt,E=E,eye=eye,expression=expression);
			gap_button_female (PF=PF,correction=correction);
			}
		}
	}
	
}

// -------------- Fin del módulo head_union_quadrangle () -----------------------
// ------------------------------------------------------------------------------

/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

i=80;

translate([0*i,0*i,0])
	head_quadrangle(		H=2,	
						head=[30,30,30],
						headt=2,
						E=3,	
						eye=[13,5],
						expression=[50,80,0]);

translate([1*i,0*i,0])
	head_cylindrical(		H=1,	
						head=[30,30,30],
						headt=2,
						E=2,	
						eye=[13,5],
						expression=[50,80,0]);

translate([0*i,1*i,0])
head_union_quadrangle(	H=2,	
						head=[40,30,30],
						headt=2,
						E=1,	
						eye=[13,5],
						expression=[-45,50,0],
						pin=[10,15,SIMPLE],
						PF=NULL,
						correction=0);

translate([1*i,1*i,0])
head_union_cylindrical(	H=1,	
						head=[30,30,30],
						headt=2,
						E=4,	
						eye=[13,5],
						expression=[50,80,0],
						pin=[10,15,SIMPLE],
						PF=NULL,
						correction=0);
