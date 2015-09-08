// arm [OBLOBOTS] v.12
// pre-form
// (c) Jorge Medal (@oblomobka) 2015.09
// GPL license

include <../2_helpers/external_elements.scad>
include <../2_helpers/presets_oblobots.scad>
include <../2_helpers/limits_oblobots.scad>

use <oblomobka/functions.scad>
use <oblomobka/shapes.scad>
use <oblomobka/solids.scad>

// Módulos
module arm_cylindrical (	arm=[18,6,45],		// [d,h,l]
                            hand=[27,4,120]		// [d,h,ang]
                            ){

// valores con límites: acotados entre un máximo y un mínimo (los valores límite están en <limits_oblobots.scad>)
d_arm=lim(d_arm_minmax[0],arm[0],d_arm_minmax[1]);			// medida del brazo: fondo
h_arm=lim(h_arm_minmax[0],arm[1],h_arm_minmax[1]);			// medida del brazo: ancho

d_hand=lim(d_hand_minmax[0],hand[0],d_hand_minmax[1]);
h_hand=lim(h_hand_minmax[0],hand[1],h_arm-0.5);
angle_hand=lim(angle_hand_minmax[0],hand[2]/2,angle_hand_minmax[1]);			//max(0,min(180,hand[2]/2));

l_arm=lim(d_arm+d_hand,arm[2],l_arm_minmax[1]);			// medida del brazo: longitud

// variables condicionadas a los valores de entrada
d_i_hand=d_hand/2;
d2_arm=d_arm-h_arm;
wrist=d_hand/3;
h_i_arm=h_arm/2;
l_i_arm=l_arm-d_arm/2-d_hand/2;

$fn=50;

// Volumen 
union(){
	difference(){
		union(){
			// brazo
			hull(){
				translate([0,0,h_arm-h_i_arm])
					cylinder(r=d_arm/2,h=h_i_arm);
				translate([0,0,0])
					cylinder(r=d2_arm/2,h=h_arm-h_i_arm);
				translate([l_i_arm-d_hand/2+wrist/2,0,0])
					cylinder(r=wrist/2,h=h_hand-1.5);
				}
			// mano
			translate([l_i_arm,0,0])
				cylinder(r1=d_hand/2,r2=(d_hand/2)*1,h=h_hand);
			}
			// hueco de la mano
			translate([l_i_arm,0,0])
				cylinder(r=d_i_hand/2,h=h_arm*2+2,center=true);
			// Garra
			for(i=[0,1]){
				mirror([0,i,0])		
					difference(){
						translate([l_i_arm,-0.01,-2])
							cube([d_hand,d_hand,2*h_arm-2]);
						translate([l_i_arm,0,-2])
							rotate([0,0,angle_hand])
								cube([d_hand,d_hand,2*h_arm-2]);
						}
				}
		}

	if(hand[2]>=180){
		for(i=[0,1]){
			mirror([0,i,0])
				translate([l_i_arm+d_hand/4,3*(d_hand-d_i_hand)/4,h_hand/2])
					cube([d_hand/2,(d_hand-d_i_hand)/2,h_hand],center=true);
			}
		}
	}
}

module arm_quadrangle (	arm=[10,15,70],		// [ grosor(x), fondo(y), longitud(z) ] Medidas de los Brazo
						hand=[20,5,8]
						){

x_arm=lim(x_arm_minmax[0],arm[1],x_arm_minmax[1]);					// medida del brazo: grosor
y_arm=lim(y_arm_minmax[0],arm[0],y_arm_minmax[1]);					// medida del brazo: fondo

d_hand=lim(d_hand_minmax[0],hand[0],d_hand_minmax[1]);
h_hand=lim(h_hand_minmax[0],hand[1],x_arm-0.5);
n_hand=lim(n_hand_minmax[0],2*floor(hand[2]/2),n_hand_minmax[1]);	// [4,6,8,10,12] nº de lados del polígono de la mano

z_arm=lim(y_arm+5+d_hand,arm[2],z_arm_minmax[1]);					// medida del brazo: longitud



//side=2*tan(180/tn)*td/2;		// medida del lado

wrist=2*(d_hand/2)*tan(180/max(6,n_hand));
h_wrist=h_hand-1;
z_i_arm=z_arm-(y_arm/2)-d_hand-(wrist/2);

translate([0,0,x_arm])
mirror([0,0,1])
union(){
	difference(){
		hull(){
			translate([0,0,x_arm/2])
				cube([y_arm,y_arm,x_arm],center=true);
			translate([z_i_arm,0,x_arm-h_wrist/2])
				cube([wrist,wrist,h_wrist],center=true);
			}
		// rebaje del hombro / forma poligonal
		//translate([0,0,x_arm/2+2])
			//prism_circumscribed (n=n_hand,d=2*y_arm/4,h=x_arm/2);
		}
	// Mano
	difference(){
		translate([z_i_arm+wrist/2+d_hand/2,0,x_arm-h_hand])
			prism_circumscribed (n=n_hand,d=d_hand,h=h_hand);
		translate([z_i_arm+wrist/2+d_hand/2,0,0])
			prism_circumscribed (n=n_hand,d=d_hand/2,h=x_arm*2);
		translate([z_i_arm+wrist/2+3*d_hand/4,0,x_arm])
			cube([d_hand/2+1,d_hand/3,2*x_arm],center=true);
		}
	}
}

// Ejemplos

i=20;

translate([0,-i,0])
	arm_cylindrical(	arm=[25,15,60],hand=[20,8,180]);

translate([0,i,0])
	arm_quadrangle(arm=[22,8,70],hand=[20,5,8]);


