// Badges [OBLOBOTS] v.12
// preforms
// (c) Jorge Medal (@oblomobka) 2015.09
// GPL license

include <../2_helpers/external_elements.scad>
include <../2_helpers/presets_oblobots.scad>
include <../2_helpers/limits_oblobots.scad>

use <oblomobka/functions.scad>
use <oblomobka/shapes.scad>
use <oblomobka/solids.scad>


// Volumen que debe rebajarse del cuerpo principal donde se colocará el badge();
module badge_subtraction (	badge=[20,3,8],				// medidas del badge		
							){

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1])+play_d_badge;		// diámetro del círculo-base 
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1])+play_h_badge;		// profundidad del rebaje
n_badge=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);					// nº lados de la base de la pirámide	

d2_badge=d_badge-2*h_badge;

translate([0,0,-0.05])
if(n_badge%2==0){
	rotate([0,0,180/n_badge])
		cylinder (r1=d_badge/2/cos(180/n_badge), r2=d2_badge/2/cos(180/n_badge), h=h_badge, $fn=n_badge);
	}
	else{
		rotate([0,0,90/n_badge]){
			cylinder (r1=d_badge/2/cos(180/n_badge), r2=d2_badge/2/cos(180/n_badge), h=h_badge, $fn=n_badge);
		}
    }
}

// Volumen que representa una columna donde se rebaja la base del badge
// su perímetro lo define el tamaño y la forma del badge al que se le añade un borde parametrizable

module badge_column (	column=[3,20],			// [borde, h] medidas de la columna donde se incrusta el badge
                        badge=[20,3,8],			// medidas del badge
                        ){

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1])+play_d_badge;		// diámetro del círculo-base 
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1])+play_h_badge;		// profundidad del rebaje
n_badge=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);			        // nº lados de la base de la pirámide	

edge=max(column[0],1);
h_column=max(column[1],h_badge+1+1+0.1);

difference(){
	prism_circumscribed(n=n_badge,d=d_badge+2*edge,h=h_column);
	translate([0,0,h_column])
		rotate([0,180,0])
			badge_subtraction(badge=badge);
	}
}

// Volumen que representa una piramide truncada donde se rebaja la base del badge
// el perímetro del exremo superior lo define el tamaño y la forma del badge
module badge_pyramid (	pyramid=[3,30,20],		// [borde, d base pirámide, h] medidas de la columna donde se incrusta el badge
						badge=[25,3,8],			// medidas del badge
						){

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1])+play_d_badge;		// diámetro del círculo-base 
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1])+play_h_badge;		// profundidad del rebaje
n_badge=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);			// nº lados de la base de la pirámide	

edge=max(pyramid[0],1);
basis_pyramid=max(pyramid[1],d_badge+2*edge);
h_pyramid=max(pyramid[2],h_badge+1+1+0.1);

difference(){
	pyramid_circumscribed(n=n_badge,d1=basis_pyramid,d2=d_badge+2*edge,h=h_pyramid);
	translate([0,0,h_pyramid])
		rotate([0,180,0])
			badge_subtraction(badge=badge);
	}
}

// Volumen del badge()
// Se disponen de varias opciones para la parte superior
module badge (	B=1,								// Tipo de badge
				badge=[20,3,8],					    // medidas del badge
				){

$fn=50;
d=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);		// diámetro del círculo-base donde se inscribe el badge
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
                            cylinder(r=d/4,h=d/20);
                            }
                        else{
                            if(B==2){ sphere(d/4); }
                            }
                }
            }
		if(B==3){
            pyramid_circumscribed (n=n,d1=d,d2=d2,h=h);
            mirror([0,0,1])
            difference(){
                prism_circumscribed(d=d,h=d/4,n=n);
                translate ([0,0,d/8])
                    prism_circumscribed(d=d-d/6,h=d,n=n);
                }
            }
        }
        
        if(B==1){
            translate([0,0,-(d/4+d/20+0.1)])
                prism_circumscribed(d=d/3,h=d/8,n=n);
            } 
        
    }
}

module badge_family (	units=[1,2,3],
						badge=[20,3,8],			// [d,h base,n lados] medidas del badge
						representation=2
						){

d=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);		// diámetro del círculo-base donde se inscribe la pirámide
h=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);		// altura de la base
n=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);		// nº lados del badge


if(representation==0){
	rotate([90,0,0])
		badge (B=units[0],badge=badge);
	}
	if(representation==1){	
		for(i=[0:len(units)-1]){
			translate([0,i*(d+3),0])
				rotate([90,0,0])
					badge (B=units[i],badge=badge);
			}
		}
		if(representation==2){
			for(i=[0:len(units)-1]){
				translate([0,-i*(d+d/4),h])
					rotate([0,180,0])
						badge (B=units[i],badge=badge);
				}
			}
}

module badge_family_compact 	(	units=[3,3,3],
                                    badge=[20,3,6]
                                    ){
$fn=50;

d_badge=lim(d_badge_minmax[0],badge[0],d_badge_minmax[1]);		// diámetro del círculo-base 
h_badge=lim(h_badge_minmax[0],badge[1],h_badge_minmax[1]);		// profundidad del rebaje
n_badge=lim(n_badge_minmax[0],badge[2],n_badge_minmax[1]);		// nº lados de la base de la pirámide	

u=lim(1,len(units),7);

aux= n_badge%2==0 ? 360:180;

translate([0,0,h_badge])
	rotate([0,180,0])
		badge (B=units[0],badge=badge);
	
	for(i=[0:u-2]){
		rotate([0,0,i*60])	
			translate([r_apothem(d_badge,n_badge)+1,0,0])
				translate([0,0,h_badge])
					rotate([0,180,i*aux/n_badge])
						badge (B=units[i+1],badge=badge);
		}
}

// Ejemplos

i=40;



translate ([-i*6,0,0])
	badge_family (	units=[0,2,0,1,2,3,3],
					badge=[28,2,6],
					representation=1);

translate ([-i*7,0,0])
	badge_family (	units=[2,1,3],
					badge=[24,3,5],
					representation=2);

translate ([-i*2,0,0])
	rotate([0,180,0])
		badge(B=1, badge=[24,1,6]);
translate ([-i*2,i,0])
	rotate([0,180,0])
		badge(B=2,badge=[25,3,8]);
translate ([-i*2,2*i,0])
	rotate([0,180,0])
		badge(B=3,badge=[25,3,50]);

translate ([-i*3,0,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([i-2,i-2,10],center=true);
		rotate([0,180,50])
			badge_subtraction(badge=[25,2,5]);
		}
translate ([-i*3,i,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([i-2,i-2,10],center=true);
		rotate([0,180,0])
			badge_subtraction(badge=[25,3,8]);
		}
translate ([-i*3,2*i,0])
	difference(){
		color("green")
		translate([0,0,-5])
			cube([i-2,i-2,10],center=true);
		rotate([0,180,0])
			badge_subtraction(badge=[25,3,4]);
		}

// Conjunto posicion del Badge
translate ([-i*3,3*i,0])
	color("yellow")
	difference(){
		rotate([0,180,0])
			badge(B=3,badge=[22,2.5,6]);
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
			badge_subtraction(badge=[22,2.5,6]);
		}
	translate([0,25,0])
			cube([50,50,50],center=true);
	}

translate ([-i*4.5,2*i,0])
	badge_pyramid (pyramid=[3,35,10],badge=[22,2.5,8]);
translate ([-i*4.5,3*i,0])
	badge_pyramid (pyramid=[1,40,25],badge=[25,2.5,5]);

translate ([-i*4.5,i,0])
	badge_column (column=[3,10],badge=[25,2.5,50]);

translate ([-i*4.5,0,0])
	badge_column (column=[0,40],badge=[25,3,5]);


badge_family_compact (units=[1,2,3],badge=[25,2,5]);



