//////////////////////////////////////////////////////////////////////////////////////////////
// Trunk and Arms gap[OBLOBOTS] 
// 
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) 2014-04 - v.10
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

include <../../../utilities/external_elements_oblobots.scad>
include <../../../utilities/presets_oblobots.scad>
include <../../../utilities/limits_oblobots.scad>

use <../../../utilities/functions_oblomobka.scad>
use <../../../utilities/shapes_oblomobka.scad>

use <badges_gap.scad>
use <trunk_gap.scad>
use <arm_gap.scad>

//////////////////////////////////////////////////////////
//////////// MODULO trunkandarms_quadrangle ()  //////////

module trunkandarms_quadrangle (	T=1,	
								trunk=[45,22,45],	
								arm=[18,10,2,80],
								hand=[25,6,8],
								pin=DOWEL_6,	
								neck=[20,15,3,2],	
								badge=[20,2.5,5],		 
								badgeposition=[3,0],
								badgeunits=[1,2,3],
								play=0,
								resolution=12,
								representation=2){

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);			
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);

x_trunk=lim(x_trunk_minmax[0],trunk[0],x_trunk_minmax[1]);
y_trunk=lim(d_pin+1+x_trunk/5,trunk[1],y_trunk_minmax[1]);
z_trunk=lim(z_trunk_minmax[0],trunk[2],z_trunk_minmax[1]);

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);
n_badge=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);

aux_angle = n_badge%2==0? 360 : 180;

x_arm=lim(x_arm_minmax[0],arm[1],x_arm_minmax[1]);
y_arm=lim(d_pin+1,arm[0],y_arm_minmax[1]);
armpit=lim(armpit_minmax[0],arm[2],armpit_minmax[1]);

d_hand=lim(d_hand_minmax[0],hand[0],d_hand_minmax[1]);
h_hand=lim(h_hand_minmax[0],hand[1],x_arm-0.5);
n_hand=lim(n_hand_minmax[0],2*floor(hand[2]/2),n_hand_minmax[1]);		// [4,6,8,10,12] nº de lados del polígono de la mano

z_arm=lim(y_arm+5+d_hand,arm[3],z_arm_minmax[1]);		// medida del brazo: longitud

angle=0;

q_badges=len(badgeunits);

color(trunk_color)
	for(i=q_badges-1){
		if(badgeunits[0]==0&&badgeunits[i]==0){
			trunk_union_quadrangle(	trunk=trunk,	
									T=T,	
									pin=pin,	
									neck=neck,	
									play=play,
									resolution=resolution);
			}
		else{
			trunk_badge_union_quadrangle(	trunk=trunk,	
										T=T,	
										pin=pin,	
										neck=neck,	
										badge=badge,		 
										badgeposition=badgeposition,
										play=play,
										resolution=resolution);
			}
	}


if(representation==0){
	color(arms_color)
	if(T<=1){	
		for(i=[0,1]){
			mirror([i,0,0])
				translate([-(x_trunk/2+x_trunk/10+x_arm+armpit),0,z_trunk-max(26,3*z_trunk/5)/2+x_trunk/20])
					rotate([0,90,0])
						rotate([0,0,angle*i])
							arm_union_quadrangle (	arm=arm,
													hand=hand,
													pin=pin,	
													play=play,
													resolution=resolution);
			}
		}
		else{
			for(i=[0,1]){
				mirror([i,0,0])
					translate([-(x_trunk/2+x_trunk/10+x_arm+armpit),0,z_trunk-max(26,3*z_trunk/5)/2])
						rotate([0,90,0])
							rotate([0,0,angle*i])
								arm_union_quadrangle (	arm=arm,
														hand=hand,
														pin=pin,	
														play=play,
														resolution=resolution);
				}
			}
	
		translate([0,y_trunk/2,z_trunk-d_badge/2-2.5-badgeposition[0]])
			rotate([0,aux_angle/n_badge-badgeposition[1],0])
					badge_family (	units=badgeunits,
									badge=badge,
									pin=pin,
									representation=representation);

					

	}
	else{
		if(representation==1){
			color(arms_color)
			if(T<=1){
				for(i=[0,1]){
					mirror([i,0,0])
						translate([-(x_trunk/2+x_trunk/10+x_arm+armpit+h_pin+10),0,z_trunk-max(26,3*z_trunk/5)/2+x_trunk/20])
							rotate([0,90,0])
								rotate([0,0,angle*i])
									arm_union_quadrangle (	arm=arm,
															hand=hand,
															pin=pin,	
															play=play,
															resolution=resolution);
					}
				}
			else{
				for(i=[0,1]){
					mirror([i,0,0])
						translate([-(x_trunk/2+x_trunk/10+x_arm+armpit+h_pin+10),0,z_trunk-max(26,3*z_trunk/5)/2])
							rotate([0,90,0])
								rotate([0,0,angle*i])
									arm_union_quadrangle (	arm=arm,
															hand=hand,
															pin=pin,	
															play=play,
															resolution=resolution);
					}
				}
		translate([0,y_trunk/2+d_badge+3,z_trunk-d_badge/2-2.5-badgeposition[0]])
				rotate([0,aux_angle/n_badge-badgeposition[1],0])
					badge_family (	units=badgeunits,
									badge=badge,
									pin=pin,
									play=play,
									representation=representation);

}
else{
	if(representation==2){
		translate([x_trunk/2+max(y_arm,d_hand)+10,-1*z_arm/3,0])
			rotate([0,0,90])
				for(i=[0,1]){
					color(arms_color)
					mirror([0,i,0])
						translate([i*2*z_arm/3,max(y_arm+5,d_hand)/2,0])
							rotate([0,0,180*i])
								arm_union_quadrangle (	arm=arm,
														hand=hand,
														pin=pin,	
														play=play,
														resolution=resolution);
					}
		translate([-(x_trunk/2+d_badge),+d_badge,0])
					badge_family (	units=badgeunits,
									badge=badge,
									pin=pin,
									play=play,
									representation=representation);
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
								pin=DOWEL_6,
								neck=[23,18,5],
								badge=[20,2.5,2,7],
								badgeposition=[0,0],
								badgeunits=[1,2,3],
								play=0,
								resolution=12,
								representation=2){

	
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);						// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);						// longitud del pin

d_arm=lim(d_pin+1,arm[0],d_arm_minmax[1]);				// medida del brazo: fondo
h_arm=lim(h_arm_minmax[0],arm[1],h_arm_minmax[1]);		// medida del brazo: ancho
armpit=lim(armpit_minmax[0],arm[2],armpit_minmax[1]);	// medida de la axila

d_hand=lim(d_hand_minmax[0],hand[0],d_hand_minmax[1]);
h_hand=lim(h_hand_minmax[0],hand[1],h_arm-0.5);
angle_hand=lim(angle_hand_minmax[0],hand[2]/2,angle_hand_minmax[1]);

l_arm=lim(d_arm+d_hand,arm[3],l_arm_minmax[1]);	

d1_trunk=lim(d1_trunk_minmax[0],trunk[0],d1_trunk_minmax[1]); 
d2_trunk=lim(d2_trunk_minmax[0],trunk[1],d1_trunk);
h_trunk=lim(h_trunk_minmax[0],trunk[2],h_trunk_minmax[1]);

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);
n_badge=lim(n_badge_minmax[0],badge[3],n_badge_minmax[1]);
edge_badge=lim(edge_badge_minmax[0],badge[2],edge_badge_minmax[1]);

angle_trunk=atan2(h_trunk,(d1_trunk-d2_trunk)/2);	// ángulo de la pared del cono-cilindro

d1_shoulder=lim(d1_shoulder_minmax[0],shoulder[0],h_trunk*sin(angle_trunk));
d_aux_shoulder=lim(d_aux_shoulder_minmax[0],shoulder[1],d_aux_shoulder_minmax[1]);
h_shoulder=lim(h_shoulder_minmax[0],shoulder[2],d2_trunk/2);


d2_shoulder=d1_shoulder+d_aux_shoulder;
d2_v_shoulder=d2_shoulder*sin(angle_trunk);
d1_v_shoulder=d1_shoulder*sin(angle_trunk);

h_shoulder_trunk=h_trunk-d2_v_shoulder/2;
d_shoulder_trunk=di_cone(d1_trunk,d2_trunk,h_trunk,h_shoulder_trunk);		// diámetro intermedio del cono

h_badge_trunk=h_trunk-3-badgeposition[0]-(d_badge+2*edge_badge)*0.5*sin(angle_trunk);
d_badge_trunk=di_cone(d1_trunk,d2_trunk,h_trunk,h_badge_trunk);

h_i_shoulder=d2_trunk/2-(sqrt(pow(d2-trunk/2,2)-pow(d2_shoulder/2,2)));
h_aux_shoulder=h_shoulder+h_i_shoulder;

aux_angle= n_badge%2==0? 180 : 360;

angle=0;

q_badges=len(badgeunits);


color(trunk_color)
for(i=q_badges-1){
if(badgeunits[0]==0&&badgeunits[i]==0){
trunk_union_cylindrical(	trunk=trunk,	
						shoulder=shoulder,	
						pin=pin,
						neck=neck,
						play=play,
						resolution=resolution);
}
else{
trunk_badge_union_cylindrical(	trunk=trunk,	
								shoulder=shoulder,	
								pin=pin,
								neck=neck,
								badge=badge,
								badgeposition=badgeposition,
								play=play,
								resolution=resolution);
}}

if(representation==0){
	for(i=[0,1]){
		color(arms_color)
		mirror([i,0,0])
			translate([-(d_shoulder_trunk/2+h_shoulder),0,h_trunk-(d1_v_shoulder/2)])
				rotate([0,180-angle_trunk,0])
					translate([0,0,-(h_arm+armpit)])
						rotate([0,0,angle*i])
							arm_union_cylindrical (	arm=arm,
													hand=hand,
													pin=pin,				
													play=play,
													resolution=resolution);
		}
	translate([0,d_badge_trunk/2,h_badge_trunk])
			rotate([90-angle_trunk,0,0])
				rotate([0,aux_angle/n_badge+badgeposition[1],0])
						badge_family (	units=badgeunits,
										badge=[d_badge,h_badge,n_badge],
										pin=pin,
										play=play,
										representation=representation);
	}
	else{
		if(representation==1){
			for(i=[0,1]){
				color(arms_color)
				mirror([i,0,0])
					translate([-(d_shoulder_trunk/2+h_shoulder),0,h_trunk-(d1_v_shoulder/2)])
						rotate([0,180-angle_trunk,0])
							translate([0,0,-(h_arm+armpit+h_pin+24)])
								arm_union_cylindrical (	arm=arm,
														hand=hand,
														pin=pin,				
														play=play,
														resolution=resolution);
				}
		translate([0,d_badge_trunk/2+d_badge+3,h_badge_trunk])
			rotate([90-angle_trunk,0,0])
				rotate([0,aux_angle/n_badge+badgeposition[1],0])
					badge_family (	units=badgeunits,
									badge=[d_badge,h_badge,n_badge],
									pin=pin,
									play=play,
									representation=representation);
		
		}
		else{
			if(representation==2){
				translate([d1_trunk+10,-1*l_arm/3,0])
					rotate([0,0,90])
						for(i=[0,1]){
							color(arms_color)
							mirror([0,i,0])
								translate([i*2*l_arm/3,max(d_arm+5,d_hand)/2,0])
									rotate([0,0,180*i])
										arm_union_cylindrical (	arm=arm,
														hand=hand,
														pin=pin,				
														play=play,
														resolution=resolution);
							}
				translate([-(d1_trunk/2+d_badge),+d_badge,0])
					badge_family (	units=badgeunits,
									badge=[d_badge,h_badge,n_badge],
									pin=pin,
									play=play,
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
trunkandarms_quadrangle (		T=1,	
							trunk=[55,25,45],	
							arm=[18,10,2,80],
							hand=[25,6,8],
							pin=DOWEL_6,	
							neck=[20,15,3,2],	
							badge=[24,2,7],		 
							badgeposition=[2,180],
							badgeunits=[3,2,3],
							play=0,
							resolution=4,
							representation=1);

translate([-5*i/2,0,0])
trunkandarms_cylindrical (		trunk=[40,35,50],	
								shoulder=[22,5,3],
								arm=[22,6,1,65],
								hand=[20,6,180],	
								pin=DOWEL_6,
								neck=[23,18,5],
								badge=[20,2.5,2,7],
								badgeposition=[0,0],
								badgeunits=[1,2,3],
								play=0,
								resolution=4,
								representation=0);

translate([3*i/2,0,0])
trunkandarms_quadrangle (		T=1,	
							trunk=[55,25,45],	
							arm=[18,10,2,80],
							hand=[25,6,8],
							pin=DOWEL_6,
							neck=[20,15,3,2],	
							badge=[24,2,7],		 
							badgeposition=[2,180],
							badgeunits=[3,2,3],
							play=0,
							resolution=4,
							representation=0);

translate([-3*i/2,0,0])
trunkandarms_cylindrical (		trunk=[40,35,50],	
								shoulder=[22,5,3],
								arm=[22,6,1,65],
								hand=[20,6,180],	
								pin=DOWEL_6,
								neck=[23,18,5],
								badge=[24,2.5,2,7],
								badgeposition=[0,0],
								badgeunits=[1,2,3],
								play=0,
								resolution=8,
								representation=1);

translate([5*i/2,0,0])
trunkandarms_quadrangle (		T=1,	
							trunk=[45,30,50],	
							arm=[25,10,5,85],
							hand=[35,8,6],
							pin=DOWEL_6,
							neck=[24,1,3,6],	
							badge=[24,3,7],		 
							badgeposition=[2,180],
							badgeunits=[1,0,0],
							play=0,
							resolution=12,
							representation=2);

translate([-1*i/2,0,0])
trunkandarms_cylindrical (		trunk=[40,35,50],	
								shoulder=[22,5,3],
								arm=[22,6,1,65],
								hand=[20,6,180],	
								pin=DOWEL_6,
								neck=[23,18,5],
								badge=[24,2.5,2,7],
								badgeposition=[0,6*360/14],
								badgeunits=[0,2,1],
								play=0,
								resolution=8,
								representation=2);


