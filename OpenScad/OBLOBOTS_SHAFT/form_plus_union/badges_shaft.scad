// Badge shaft [OBLOBOTS] v.12
// form + union
// (c) Jorge Medal (@oblomobka) 2015.09
// GPL license

include <../../2_helpers/external_elements.scad>
include <../../2_helpers/presets_oblobots.scad>
include <../../2_helpers/limits_oblobots.scad>

use <../../1_unions/shaft.scad>
use <../../0_forms/badges.scad>

use <oblomobka/functions.scad>
use <oblomobka/shapes.scad>
use <oblomobka/solids.scad>


// Volumen que debe rebajarse del cuerpo principal donde se colocará el badge();
module badge_subtraction_shaft (	badge=[20,3,8],				// medidas del badge
                                    pin=[6,30],
                                    play=0			
                                    ){

d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);							// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);							// longitud del pin

h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1])+play_h_badge;		// profundidad del rebaje
                                        
badge_subtraction (badge=badge);
// Union                                     
translate([0,0,h_badge])
    shaft (shaft=[pin[0],5],play=play);
}


// Volumen que representa una columna donde se rebaja la base del badge
// su perímetro lo define el tamaño y la forma del badge al que se le añade un borde parametrizable

module badge_column_shaft (	column=[3,20],			// [borde, h] medidas de la columna donde se incrusta el badge
                        badge=[20,2,5],			// medidas del badge
                        pin=[6,30],
                        play=0.1
                        ){

d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);					// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);					// longitud del pin
                            
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1])+play_h_badge;		// profundidad del rebaje
h_column=max(column[1],h_badge+1+1+0.1);
                            
difference(){
	badge_column (column=column, badge=badge);
	translate([0,0,h_column-h_badge])
		mirror([0,0,1])
			shaft (shaft=[d_pin,h_pin-5],play=play);
	}
}

// Volumen que representa una piramide truncada donde se rebaja la base del badge
// el perímetro del exremo superior lo define el tamaño y la forma del badge

module badge_pyramid_shaft (	pyramid=[2,40,20],		// [borde, h] medidas de la columna donde se incrusta el badge
						badge=[20,3,8],			// medidas del badge
						pin=[6,30],
						play=0
						){

d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);					// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);					// longitud del pin
                            
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1])+play_h_badge;		// profundidad del rebaje
h_pyramid=max(pyramid[2],h_badge+1+1+0.1);
                            
difference(){
	badge_pyramid (pyramid=pyramid, badge=badge);
	translate([0,0,h_pyramid-h_badge])
		mirror([0,0,1])
			shaft (shaft=[d_pin,h_pin-5],play=play);
	}
}

// ---- Volumen del badge(), la parte inferior podrá alojar un botón automático
// --- Se disponen de varias opciones para la parte superior

module badge_shaft (	B=2,								// Tipo de badge
                        badge=[20,3,5],					// medidas del badge
                        pin=[8,30],
                        play=0
                        ){

$fn=50;
d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);			// diámetro del pin
h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);			// longitud del pin

d=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);		// diámetro del círculo-base donde se inscribe el badge                            
h=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);		// altura de la base

if(B==1||B==2||B==3){
    difference(){
        badge (B=B, badge=badge);
        translate([0,0,h])
            mirror([0,0,1])
                shaft (shaft=[d_pin,h+d/8-2],play=play);
        }
    }
}

module badge_family_shaft (	units=[1,3,2],
                            badge=[20,3,8],			// [d,h base,n lados] medidas del badge
                            pin=[6,30],
                            play=0,
                            representation=2
                            ){

d=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);		// diámetro del círculo-base donde se inscribe la pirámide
h=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);		// altura de la base


if(representation==0){
	rotate([90,0,0])
		badge (B=units[0],badge=badge,pin=pin,play=play);
	}
else{
	if(representation==1){	
		for(i=[0:len(units)-1]){
			translate([0,i*(d+3),0])
				rotate([90,0,0])
					badge_shaft (B=units[i],badge=badge,pin=pin,play=play);
			}
		}
	else{
		if(representation==2){
			for(i=[0:len(units)-1]){
				translate([0,-i*(d+d/4),h])
					rotate([0,180,0])
						badge_shaft (B=units[i],badge=badge,pin=pin,play=play);
				}
			}
		}
	}
}


module badge_family_compact_shaft 	(	units=[1,2,3],
                                        badge=[25,3,6],
                                        pin=[6,30],
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
		badge_shaft (B=units[0],badge=badge,pin=pin,play=play);
	
	for(i=[0:u-2]){
		rotate([0,0,i*60])	
			translate([r_apothem(d_badge,n_badge)+1,0,0])
				translate([0,0,h_badge])
					rotate([0,180,i*aux/n_badge])
						badge_shaft (B=units[i+1],badge=badge,pin=pin,play=play);
		}
}
// Ejemplos

i=40;

translate ([-i*6,0,0])
	badge_family_shaft (	units=[0,2,0,1,2,3,3],
					badge=[28,2,6],
					pin=DOWEL_6,
					play=0,
					representation=1);

translate ([-i*7,0,0])
	badge_family_shaft (	units=[2,1,3],
					badge=[24,3,5],
					pin=DOWEL_6,
					play=0,
					representation=2);

translate ([-i*2,0,0])
	rotate([0,180,0])
		badge_shaft(B=1, badge=[24,1,6],pin=DOWEL_6,play=0);
translate ([-i*2,i,0])
	rotate([0,180,0])
		badge_shaft(B=2,badge=[25,3,8],pin=DOWEL_6,play=0);
translate ([-i*2,2*i,0])
	rotate([0,180,0])
		badge_shaft(B=3,badge=[25,3,50],pin=DOWEL_6,play=0);

translate ([-i*3,0,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([i-2,i-2,10],center=true);
		rotate([0,180,50])
			badge_subtraction_shaft(badge=[25,2,5],pin=DOWEL_6);
		}
translate ([-i*3,i,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([i-2,i-2,10],center=true);
		rotate([0,180,0])
			badge_subtraction_shaft(badge=[25,3,8],pin=DOWEL_6);
		}
translate ([-i*3,2*i,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([i-2,i-2,10],center=true);
		rotate([0,180,0])
			badge_subtraction_shaft(badge=[25,3,4],pin=DOWEL_6);
		}

// Conjunto posicion del Badge
translate ([-i*3,3*i,0])
	color("yellow")
	difference(){
		rotate([0,180,0])
			badge_shaft(B=1,badge=[22,3,6],pin=DOWEL_6);
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
			badge_subtraction_shaft(badge=[22,3,6],pin=DOWEL_6);
		}
	translate([0,25,0])
			cube([50,50,50],center=true);
	}

translate ([-i*4.5,2*i,0])
	badge_pyramid_shaft (pyramid=[3,35,10],badge=[22,2.5,8],pin=DOWEL_6,play=0);
translate ([-i*4.5,3*i,0])
	badge_pyramid_shaft (pyramid=[1,40,25],badge=[25,2.5,5],pin=DOWEL_6,play=0);

translate ([-i*4.5,i,0])
	badge_column_shaft (column=[3,10],badge=[25,2.5,50],pin=DOWEL_6,play=0);

translate ([-i*4.5,0,0])
	badge_column_shaft (column=[0,40],badge=[25,3,5],pin=DOWEL_6,play=0);

badge_family_compact_shaft (units=[1,2,3],badge=[25,2,5],pin=DOWEL_6);