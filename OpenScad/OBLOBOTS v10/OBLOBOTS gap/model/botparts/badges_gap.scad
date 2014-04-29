//////////////////////////////////////////////////////////////////////////////////////////////////
// badges gap[OBLOBOTS] 
// joint_gap
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) 2014-04 - v.10
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license 
//////////////////////////////////////////////////////////////////////////////////////////////////

include <../../../utilities/external_elements_oblobots.scad>
include <../../../utilities/presets_oblobots.scad>
include <../../../utilities/limits_oblobots.scad>

use <../../../utilities/shapes_oblomobka.scad>
use <../../../utilities/functions_oblomobka.scad>

use <../../../joints/gap_oblobots.scad>

// ---

play_d_badge=0.4;
play_h_badge=0.15;

// ---- Volumen que debe rebajarse del cuerpo principal donde se colocará el badge();
module badge_subtraction (	badge=[20,3,8],				// medidas del badge
							pin=DOWEL_6,
							play=0			
							){

d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);							// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);							// longitud del pin

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1])+play_d_badge;		// diámetro del círculo-base 
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1])+play_h_badge;		// profundidad del rebaje
n_badge=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);					// nº lados de la base de la pirámide	

d2_badge=d_badge-2*h_badge;

translate([0,0,-0.05])
if(n_badge%2==0){
	rotate([0,0,180/n_badge]){
		cylinder (r1=d_badge/2/cos(180/n_badge), r2=d2_badge/2/cos(180/n_badge), h=h_badge, $fn=n_badge);
		translate([0,0,h_badge])
			gap(gap=pin,deep=3*pin[1]/4,play=play);}
	}
	else{
		rotate([0,0,90/n_badge]){
			cylinder (r1=d_badge/2/cos(180/n_badge), r2=d2_badge/2/cos(180/n_badge), h=h_badge, $fn=n_badge);
			translate([0,0,h_badge])
				gap(gap=pin,deep=3*pin[1]/4,play=play);}
		}
// Hueco para introducir una espiga de madera
	//translate([0,0,h_badge])
		//gap_dowel(dowel=pin,deep=3*pin[1]/4,play=play);
}

// ------- badge_subtraction (badge=[d,h,n],pin=[d,h],play); -----------------

// Volumen que representa una columna donde se rebaja la base del badge
// su perímetro lo define el tamaño y la forma del badge al que se le añade un borde parametrizable

module badge_column (	column=[3,20],			// [borde, h] medidas de la columna donde se incrusta el badge
					badge=[20,3,8],			// medidas del badge
					pin=DOWEL_6,
					play=0
					){

d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);					// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);					// longitud del pin

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1])+play_d_badge;		// diámetro del círculo-base 
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1])+play_h_badge;		// profundidad del rebaje
n_badge=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);			// nº lados de la base de la pirámide	

edge=max(column[0],1);
h_column=max(column[1],h_badge+h_pin+1+1+0.1);

difference(){
	prism_circumscribed(n=n_badge,d=d_badge+2*edge,h=h_column);
	translate([0,0,h_column])
		rotate([0,180,0])
			badge_subtraction(badge=badge,pin=pin,play=play);
	}
}

// ------- badge_column (column=[b,h],badge=[d,h,n],pin=[d,h],play); -----------------

// Volumen que representa una piramide truncada donde se rebaja la base del badge
// el perímetro del exremo superior lo define el tamaño y la forma del badge

module badge_pyramid (	pyramid=[3,30,20],		// [borde, h] medidas de la columna donde se incrusta el badge
						badge=[25,3,8],			// medidas del badge
						pin=DOWEL_6,
						play=0
						){

d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);					// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);					// longitud del pin

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1])+play_d_badge;		// diámetro del círculo-base 
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1])+play_h_badge;		// profundidad del rebaje
n_badge=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);			// nº lados de la base de la pirámide	

edge=max(pyramid[0],1);
basis_pyramid=max(pyramid[1],d_badge+2*edge);
h_pyramid=max(pyramid[2],h_badge+h_pin+1+1+0.1);

difference(){
	pyramid_circumscribed(n=n_badge,d1=basis_pyramid,d2=d_badge+2*edge,h=h_pyramid);
	translate([0,0,h_pyramid])
		rotate([0,180,0])
			badge_subtraction(badge=badge,pin=pin,play=play);
	}
}

// ------- badge_pyramid (pyramid=[borde,base,h]],badge=[d,h,n],pin=[d,h],play); -----------------


// ---- Volumen del badge(), la parte inferior podrá alojar un botón automático
// --- Se disponen de varias opciones para la parte superior

module badge (	B=1,								// Tipo de badge
				badge=[20,3,8],					// medidas del badge
				pin=DOWEL_6,
				play=0
				){

$fn=50;
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);			// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);			// longitud del pin

d=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);		// diámetro del círculo-base donde se inscribe la pirámide
h=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);		// altura de la base
n=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);		// nº lados del badge

d2=d-2*h;

difference(){
	union(){
		if(B==1||B==2){
		pyramid_circumscribed (n=n,d1=d,d2=d2,h=h);
			mirror([0,0,1])
				hull(){
					prism_circumscribed (n=n,d=d,h=0.5);
					translate([0,0,d/4])
						if(B==1){
							cylinder(r=d/4,h=1);
							}
						else{
							if(B==2){
								sphere(d/4);
								}
							}
					}
			}
		else{
		if(B>=3){
		pyramid_circumscribed (n=n,d1=d,d2=d2,h=h);
			mirror([0,0,1])
				difference(){
					prism_circumscribed(d=d,h=6,n=n);
					translate ([0,0,4])
						prism_circumscribed(d=d-5,h=5,n=n);
					}
			}	
		}
	}
	if(B==1||B==2||B>=3){
	translate([0,0,h])		
		rotate([0,180,0])
			gap(gap=pin,deep=5,play=play);
	}
	if(B==1){
		translate([0,0,-(d/4+3)])
			prism_circumscribed(d=d/3,h=5,n=n);
		}
	}
}

// ------- badge (B=B,badge,PF,correction); -----------------

module badge_family (		units=[1,2,3],
						badge=[20,3,8],			// [d,h base,n lados] medidas del badge
						pin=DOWEL_6,
						play=0,
						representation=2
						){

d=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);		// diámetro del círculo-base donde se inscribe la pirámide
h=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);		// altura de la base
n=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);		// nº lados del badge


if(representation==0){
	rotate([90,0,0])
		badge (B=units[0],badge=badge,pin=pin,play=play);
	}
else{
	if(representation==1){	
		for(i=[0:len(units)-1]){
			translate([0,i*(d+3),0])
				rotate([90,0,0])
					badge (B=units[i],badge=badge,pin=pin,play=play);
			}
		}
	else{
		if(representation==2){
			for(i=[0:len(units)-1]){
				translate([0,-i*(d+d/4),h])
					rotate([0,180,0])
						badge (B=units[i],badge=badge,pin=pin,play=play);
				}
			}
		}
	}
}


module badge_family_compact 	(	units=[3,3,3],
								badge=[20,3,6],
								pin=DOWEL_6,
								play=0
								){
$fn=50;

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);		// diámetro del círculo-base 
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);		// profundidad del rebaje
n_badge=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);			// nº lados de la base de la pirámide	

u=lim(1,len(units),7);

aux= n_badge%2==0 ? 360:180;

translate([0,0,h_badge])
	rotate([0,180,0])
		badge (B=units[0],badge=badge,pin=pin,play=play);
	
	for(i=[0:u-2]){
		rotate([0,0,i*60])	
			translate([radius_apothem(d_badge,n_badge)+1,0,0])
				translate([0,0,h_badge])
					rotate([0,180,i*aux/n_badge])
						badge (B=units[i+1],badge=badge,pin=pin,play=play);
		}
}


// ------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////

i=40;

translate ([-i*6,0,0])
	badge_family (	units=[0,2,0,1,2,3,3],
					badge=[28,2,6],
					pin=DOWEL_6,
					play=0,
					representation=1);

translate ([-i*7,0,0])
	badge_family (	units=[2,1,3],
					badge=[24,3,5],
					pin=DOWEL_6,
					play=0,
					representation=2);

translate ([-i*2,0,0])
	rotate([0,180,0])
		badge(B=1, badge=[24,1,6],pin=DOWEL_6,play=0);
translate ([-i*2,i,0])
	rotate([0,180,0])
		badge(B=2,badge=[25,3,8],pin=DOWEL_6,play=0);
translate ([-i*2,2*i,0])
	rotate([0,180,0])
		badge(B=3,badge=[25,3,50],pin=DOWEL_6,play=0);

translate ([-i*3,0,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([i-2,i-2,10],center=true);
		rotate([0,180,50])
			badge_subtraction(badge=[25,2,5],pin=DOWEL_6);
		}
translate ([-i*3,i,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([i-2,i-2,10],center=true);
		rotate([0,180,0])
			badge_subtraction(badge=[25,3,8],pin=DOWEL_6);
		}
translate ([-i*3,2*i,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([i-2,i-2,10],center=true);
		rotate([0,180,0])
			badge_subtraction(badge=[25,3,4],pin=DOWEL_6);
		}

// Conjunto posicion del Badge
translate ([-i*3,3*i,0])
	color("yellow")
	difference(){
		rotate([0,180,0])
			badge(B=3,badge=[22,2.5,6],pin=DOWEL_6);
		translate([0,25,0])
			cube([50,50,50],center=true);
		}

translate ([-i*3,3*i,0])
	difference(){
	color("red")
	difference(){
		translate([0,0,-5])
			cube([28,28,10],center=true);
		rotate([0,180,0])
			badge_subtraction(badge=[22,2.5,6],pin=DOWEL_6);
		}
	translate([0,25,0])
			cube([50,50,50],center=true);
	}

translate ([-i*4.5,2*i,0])
	badge_pyramid (pyramid=[3,35,10],badge=[22,2.5,8],pin=DOWEL_6,play=0);
translate ([-i*4.5,3*i,0])
	badge_pyramid (pyramid=[1,40,25],badge=[25,2.5,5],pin=DOWEL_6,play=0);

translate ([-i*4.5,i,0])
	badge_column (column=[3,10],badge=[25,2.5,50],pin=DOWEL_6,play=0);

translate ([-i*4.5,0,0])
	badge_column (column=[0,40],badge=[25,3,5],pin=DOWEL_6,play=0);


badge_family_compact (units=[1,2,3],badge=[25,2,5],pin=DOWEL_6);



