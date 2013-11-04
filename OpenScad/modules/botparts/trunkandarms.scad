//////////////////////////////////////////////////////////////////////////////////////////////
// Trunk and Arms [OBLOBOTS] 
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

use <trunk.scad>
use <arm.scad>

//////////////////////////////////////////////////////////
//////////// MODULO trunkandarms_quadrangle ()  //////////

module trunkandarms_quadrangle (	T=1,	
								trunk=[45,22,45],	
								arm=[18,10,2,80],
								hand=[25,6,8],
								pin=[8,15,TABNORMAL],	
								neck=[20,15,3,2],	
								PF=NULL,	
								correction=0,
								badge=[20,2.5,5],		 
								badgeposition=[3,0],
								badgeunits=[1,2,3],
								PFbadge=COS11,
								representation=2){

pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin

trx=lim(20,trunk[0],90);
try=lim(20,trunk[1],90);
trz=lim(24,trunk[2],90);

badged=lim(20,badge[0],35);
badgen=lim(4,badge[2],50);

angaux= badgen%2==0? 360 : 180;

armx=lim(5,arm[1],25);				// medida del brazo: grosor
army=lim(pind+1,arm[0],40);			// medida del brazo: fondo
armpit=lim(0,arm[2],60);				// medida de la axila

handd=lim(10,hand[0],60);
handh=lim(3,hand[1],armx-0.5);
handnreal=lim(4,2*floor(hand[2]/2),12);		// [4,6,8,10,12] nº de lados del polígono de la mano

arml=lim(army+5+handd,arm[3],120);		// medida del brazo: longitud
armlim=[army,armx,armpit,arml];

ang=0;

color(trunk_color)
trunk_badge_union_quadrangle(	trunk=trunk,	
							T=T,	
							pin=pin,	
							neck=neck,	
							PF=PF,	
							correction=correction,
							badge=badge,		 
							badgeposition=badgeposition,
							PFbadge=PFbadge);


if(representation==0){
	color(arms_color)
	if(T<=1){	
		for(i=[0,1]){
			mirror([i,0,0])
				translate([-(trx/2+trx/10+armx+armpit),0,trz-max(24,trz/2)/2+trx/20])
					rotate([0,90,0])
						rotate([0,0,ang*i])
							arm_union_quadrangle (	arm=arm,
													hand=hand,
													pin=[pind,pinh,pin[2]],	
													PF=PF,				
													correction=correction);
			}
		}
		else{
			for(i=[0,1]){
				mirror([i,0,0])
					translate([-(trx/2+trx/10+armx+armpit),0,trz-max(24,trz/2)/2])
						rotate([0,90,0])
							rotate([0,0,ang*i])
								arm_union_quadrangle (	arm=arm,
														hand=hand,
														pin=[pind,pinh,pin[2]],	
														PF=PF,				
														correction=correction);
				}
			}
	
		translate([0,try/2,trz-badged/2-2.5-badgeposition[0]])
			rotate([0,angaux/badgen-badgeposition[1],0])
					badge_family (units=badgeunits,badge=badge,PF=PFbadge,representation=representation);


	}
	else{
		if(representation==1){
			color(arms_color)
			if(T<=1){
				for(i=[0,1]){
					mirror([i,0,0])
						translate([-(trx/2+trx/10+armx+armpit+pinh+10),0,trz-max(24,trz/2)/2+trx/20])
							rotate([0,90,0])
								rotate([0,0,ang*i])
									arm_union_quadrangle (	arm=arm,
															hand=hand,
															pin=[pind,pinh,pin[2]],	
															PF=PF,				
															correction=correction);
					}
				}
			else{
				for(i=[0,1]){
					mirror([i,0,0])
						translate([-(trx/2+trx/10+armx+armpit+pinh+10),0,trz-max(24,trz/2)/2])
							rotate([0,90,0])
								rotate([0,0,ang*i])
									arm_union_quadrangle (	arm=arm,
															hand=hand,
															pin=[pind,pinh,pin[2]],	
															PF=PF,				
															correction=correction);
					}
				}
		translate([0,try/2+badged+3,trz-badged/2-2.5-badgeposition[0]])
				rotate([0,angaux/badgen-badgeposition[1],0])
					badge_family (units=badgeunits,badge=badge,PF=PFbadge,representation=representation);
}
else{
	if(representation==2){
		translate([trx/2+max(army,handd)+5,-1*arml/3,0])
			rotate([0,0,90])
				for(i=[0,1]){
					color(arms_color)
					mirror([0,i,0])
						translate([i*2*arml/3,max(army+5,handd)/2,0])
							rotate([0,0,180*i])
								arm_union_quadrangle (	arm=arm,
														hand=hand,
														pin=[pind,pinh,pin[2]],	
														PF=PF,				
														correction=correction);
					}
		translate([-(trx/2+badged),+badged,0])
					badge_family (units=badgeunits,badge=badge,PF=PFbadge,representation=representation);

		}
	}	
}
}

// -------------- Fin del módulo trunkandarms_quadrangle ()------------
// --------------------------------------------------------------------

//////////////////////////////////////////////////////////
//////////// MODULO trunkandarms_cylindrical ()  //////////

module trunkandarms_cylindrical (	trunk=[40,35,50],	
								shoulder=[20,5,3],
								arm=[20,8,3,65],
								hand=[20,6,180],	
								pin=[10,15,TABNORMAL],
								neck=[23,18,5],
								PF=NULL,
								correction=0,
								badge=[20,2.5,2,7],
								badgeposition=[0,0],
								badgeunits=[1,2,3],
								PFbadge=COS11,
								representation=2){

pind=lim(4,pin[0],20);					// diámetro del pin
pinh=lim(5,pin[1],30);					// longitud del pin

armd=lim(pind+1,arm[0],40);			// medida del brazo: fondo
armh=lim(5,arm[1],25);				// medida del brazo: ancho
armpit=lim(0,arm[2],60);				// medida de la axila

handd=lim(10,hand[0],60);
handh=lim(3,hand[1],armh-0.5);
handang=lim(0,hand[2]/2,180);			//max(0,min(180,hand[2]/2));

arml=lim(armd+handd,arm[3],120);		// medida del brazo: longitud
armlim=[armd,armh,arml];

td1=lim(20,trunk[0],70);		// medida del cuerpo: diametro base || limitado [20:100]
td2=lim(20,trunk[1],td1); 	// medida del cuerpo: diametro punta ||  limitado [20:td1]
th=lim(24,trunk[2],80);		// medida del cuerpo: altura ||  limitado [20:80]

badged=lim(20,badge[0],35);
badgeh=lim(1,badge[1],5);
badgen=lim(4,badge[3],50);
badgeb=lim(1,badge[2],5);				// borde del alojamiento del badge

tang=atan2(th,(td1-td2)/2);	// ángulo de la pared del cono-cilindro

sd1=lim(12,shoulder[0],th*sin(tang));	// diámetro del hombro ||  limitado [10:th/2]
sdaux=lim(0,shoulder[1],10);				// diámetro del hombro intersección cono
sh=lim(0,shoulder[2],td2/2);

sd2=sd1+sdaux;
sd2v=sd2*sin(tang);
sd1v=sd1*sin(tang);

ths=th-sd2v/2;
tds=di_cone(td1,td2,th,ths);	// diámetro intermedio del cono

thb=th-3-badgeposition[0]-(badged+2*badgeb)*0.5*sin(tang);	// altura intermedia del tronco para la posición del badge
tdb=di_cone(td1,td2,th,thb);				// diámetro intermedio del tronco para la posición del badge

	shi=td2/2-(sqrt(pow(td2/2,2)-pow(sd2/2,2)));
shaux=sh+shi;

angaux= badgen%2==0? 180 : 360;

ang=0;


color(trunk_color)
trunk_badge_union_cylindrical(	trunk=trunk,	
									shoulder=shoulder,	
									pin=pin,
									neck=neck,
									PF=PF,
									correction=correction,
									badge=badge,
									badgeposition=badgeposition,
									PFbadge=PFbadge);

if(representation==0){
	for(i=[0,1]){
		color(arms_color)
		mirror([i,0,0])
			translate([-(tds/2+sh),0,th-(sd1v/2)])
				rotate([0,180-tang,0])
					translate([0,0,-(armh+armpit)])
						rotate([0,0,ang*i])
							arm_union_cylindrical (	arm=arm,
													hand=hand,
													pin=pin,		
													PF=PF,				
													correction=correction);
		}
	translate([0,tdb/2,thb])
			rotate([90-tang,0,0])
				rotate([0,angaux/badgen+badgeposition[1],0])
						badge_family (	units=badgeunits,
										badge=[badged,badgeh,badgen],
										PF=PFbadge,
										representation=representation);
	}
	else{
		if(representation==1){
			for(i=[0,1]){
				color(arms_color)
				mirror([i,0,0])
					translate([-(tds/2+sh),0,th-(sd1v/2)])
						rotate([0,180-tang,0])
							translate([0,0,-(armh+armpit+pinh+5)])
								arm_union_cylindrical (	arm=arm,
														hand=hand,
														pin=[pind,pinh,pin[2]],
														PF=PF,				
														correction=correction);
				}
		translate([0,tdb/2+badged+3,thb])
			rotate([90-tang,0,0])
				rotate([0,angaux/badgen+badgeposition[1],0])
					badge_family (	units=badgeunits,
									badge=[badged,badgeh,badgen],
									PF=PFbadge,
									representation=representation);
		
		}
		else{
			if(representation==2){
				translate([td1+10,-1*arml/3,0])
					rotate([0,0,90])
						for(i=[0,1]){
							color(arms_color)
							mirror([0,i,0])
								translate([i*2*arml/3,max(armd+5,handd)/2,0])
									rotate([0,0,180*i])
										arm_union_cylindrical (	arm=arm,
																hand=hand,
																pin=[pind,pinh,pin[2]],	
																PF=PF,				
																correction=correction);
							}
				translate([-(td1/2+badged),+badged,0])
					badge_family (	units=badgeunits,
									badge=[badged,badgeh,badgen],
									PF=PFbadge,
									representation=representation);
				}
			}
		}

}



// -------------- Fin del módulo trunkandarms_cylindrical ()------------
// --------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

i=150;

translate([i/2,0,0])
trunkandarms_quadrangle(	T=2,	
						trunk=[35,22,55],
						arm=[18,7,2,80],
						hand=[22,6,4],
						pin=[8,15,TABNORMAL],	
						neck=[20,15,3,2],	
						PF=NULL,	
						correction=0,
						badge=[20,2.5,6],		 
						badgeposition=[3,50],
						badgeunits=[1,2,3],
						PFbadge=COS11,
						representation=0);

translate([-i/2,0,0])
trunkandarms_cylindrical(	trunk=[45,30,50],	
							shoulder=[20,5,3],
							arm=[20,8,3,65],
							hand=[20,6,180],	
							pin=[10,15,TABNORMAL],
							neck=[23,18,5],
							PF=NULL,
							correction=0,
							badge=[20,2.5,2,9],
							badgeposition=[4,0],
							badgeunits=[1,3,2],
							PFbadge=COS11,
							representation=0);

translate([3*i/2,0,0])
trunkandarms_quadrangle(	T=1,	
						trunk=[45,22,45],
						arm=[18,10,6,80],
						hand=[25,6,8],
						pin=[8,15,TABNORMAL],	
						neck=[20,15,3,2],	
						PF=NULL,	
						correction=0,
						badge=[20,2.5,5],		 
						badgeposition=[3,0],
						badgeunits=[1,2,3],
						PFbadge=COS11,
						representation=1);

translate([-3*i/2,0,0])
trunkandarms_cylindrical(	trunk=[40,35,50],	
							shoulder=[20,5,3],
							arm=[20,8,4,65],
							hand=[20,6,180],	
							pin=[10,15,TABNORMAL],
							neck=[23,18,5],
							PF=NULL,
							correction=0,
							badge=[20,2.5,2,7],
							badgeposition=[0,0],
							badgeunits=[1,2,3],
							PFbadge=COS11,
							representation=1);

translate([5*i/2,0,0])
trunkandarms_quadrangle(	T=1,	
						trunk=[45,22,45],	
						arm=[18,10,3,80],
						hand=[25,6,8],
						pin=[8,15,TABNORMAL],	
						neck=[20,15,3,2],	
						PF=NULL,	
						correction=0,
						badge=[20,2.5,5],		 
						badgeposition=[3,0],
						badgeunits=[1,2,3],
						PFbadge=COS11,
						representation=2);

translate([-5*i/2,0,0])
trunkandarms_cylindrical(	trunk=[40,35,50],	
							shoulder=[20,5,3],
							arm=[20,8,3,65],,
							hand=[20,6,180],	
							pin=[10,15,TABNORMAL],
							neck=[23,18,5],
							PF=NULL,
							correction=0,
							badge=[20,2.5,2,7],
							badgeposition=[0,0],
							badgeunits=[1,2,3],
							PFbadge=COS11,
							representation=2);


