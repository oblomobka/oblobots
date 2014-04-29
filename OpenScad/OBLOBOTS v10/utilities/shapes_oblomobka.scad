// Shapes
// (C) @oblomobka - 2014
// GPL3

include <constants_oblomobka.scad>
include <functions_oblomobka.scad>
include <functions_ext.scad>

use <transformations_oblomobka.scad>

// --- Piramide con base circunscrita en un círculo definido en las variables
module pyramid_circumscribed (	n=4,			// nº lados de la base de la pirámide	
								d1=20,		// diámetro del círculo-base donde se circunscribe la pirámide
								d2=0,		// diámetro del círculo-punta donde se circunscribe la pirámide
								h=10			// altura de la pirámide
								){

if(n%2==0){
	rotate([0,0,180/n])
		cylinder (r1=d1/2/cos(180/n), r2=d2/2/cos(180/n), h=h, $fn=n);
	}
	else{
		rotate([0,0,90/n])
			cylinder (r1=d1/2/cos(180/n), r2=d2/2/cos(180/n), h=h, $fn=n);
		}

}
// ------- pyramid_circumscribed (n=n,d1=d1,d2=d2,h=h); -----------------

// --- Prisma con base circunscrita en un círculo definido en las variables
module prism_circumscribed (	n=4,			// nº lados de la base del prisma
							d=20,		// diámetro del círculo donde se circunscribe el prisma
							h=10			// altura del prisma
							){
if(n%2==0){
	rotate([0,0,180/n])
		cylinder (r=d/2/cos(180/n), h=h, $fn=n);
	}
	else{
		rotate([0,0,90/n])
			cylinder (r=d/2/cos(180/n), h=h, $fn=n);
		}
}
// ------- prism_circumscribed (n=n,d=d,h=h); -----------------



// Toros

// Definido por el diámetro exterior y el diámetro del círculo en revolución
module torusOD (d1,d2,resolution){
$fn=resolution;	
rotate_extrude(){
	translate([d1/2-d2/2,0,0])
		circle(r=d2/2);
	}
}

// Definido por el diámetro exterior y el diámetro interior
module torusOI (d1,d2,resolution){
$fn=resolution;	
d=(d1-d2)/2;
rotate_extrude(){
	translate([d1/2-d/2,0,0])
		circle(r=d/2);
	}
}

// Definido por el diámetro de la línea neutra y el diámetro del círculo en revolución
module torusND (d1,d2,resolution){
$fn=resolution;	
rotate_extrude(){
	translate([d1/2,0,0])
		circle(r=d2/2);
	}
}

module torus_sector(d1,d2,angle=360,mode=1,extreme=true,resolution=32){

if(angle<=0 || angle>=360){
	if(mode==1){torusOD(d1,d2,resolution=resolution);}
	else{if(mode==2){torusND(d1,d2,resolution=resolution);}
	else{if(mode==3){torusOI(d1,d2,resolution=resolution);}}}
	}

else{
	if(mode==1){
		union(){
			sector(angle,d1,d2/2)torusOD(d1,d2,resolution=resolution);
			if(extreme==true){
				translate([d1/2-d2/2,0,0])sphere(d2/2,$fn=resolution);
				translate([(d1/2-d2/2)*cos(angle),(d1/2-d2/2)*sin(angle),0])sphere(d2/2,$fn=resolution);
				}
			}
		}
	else{
		if(mode==2){
			union(){
				sector(angle,d1+d2,d2/2)torusND(d1,d2,resolution=resolution);
				if(extreme==true){
					translate([d1/2,0,0])sphere(d2/2,$fn=resolution);
					translate([d1/2*cos(angle),d1/2*sin(angle),0])sphere(d2/2,$fn=resolution);
					}
				}
			}
		else{
			if(mode==3){
				union(){
					sector(angle,d1,(d1-d2)/4)torusOI(d1,d2,resolution=resolution);
					if(extreme==true){
						translate([d1/2-(d1-d2)/4,0,0])sphere((d1-d2)/4,$fn=resolution);
						translate([(d1/2-(d1-d2)/4)*cos(angle),(d1/2-(d1-d2)/4)*sin(angle),0])sphere((d1-d2)/4,$fn=resolution);
						}
					}
				}
			}
		}
	}
}


// Tubos

module tubeOT (d,t,h,resolution=resolution){	
	difference(){
		cylinder(r=d/2,h=h,$fn=resolution);
		cylinder(r=(d-2*t)/2,h=3*h,center=true,$fn=resolution);
		}
}

// Definido por el diámetro exterior y el diámetro interior
module tubeOI (d1,d2,h,resolution=resolution){
	difference(){
		cylinder(r=d1/2,h=h,$fn=resolution);
		cylinder(r=d2/2,h=3*h,center=true,$fn=resolution);	
		}
}

// Definido por el diámetro de la línea neutra y el diámetro del círculo en revolución
module tubeNT (d,t,h,resolution=resolution){
	difference(){
		cylinder(r=(d+t)/2,h=h,$fn=resolution);
		cylinder(r=(d-t)/2,h=3*h,center=true,$fn=resolution);
	}
}

module tube_sector(d=25,t=2,h=1,angle=360,mode=1,extreme=true,resolution=32){

if(angle<=0 || angle>=360){
	if(mode==1){tubeOT(d,t,h,resolution=resolution);}
	else{if(mode==2){tubeNT(d,t,h,resolution=resolution);}
	else{if(mode==3){tubeOI(d,t,h,resolution=resolution);}}}
	}

else{
	if(mode==1){
		union(){
			sector(angle,d,h)tubeOT(d,t,h,resolution=resolution);
			if(extreme==true){
				translate([d/2-t/2,0,0])cylinder(r=t/2,h=h,$fn=resolution);
				translate([(d/2-t/2)*cos(angle),(d/2-t/2)*sin(angle),0])cylinder(r=t/2,h=h,$fn=resolution);;
				}
			}
		}
	else{
		if(mode==2){
			union(){
				sector(angle,d+t,h)tubeNT(d,t,h,resolution=resolution);
				if(extreme==true){
					translate([d/2,0,0])cylinder(r=t/2,h=h,$fn=resolution);
					translate([d/2*cos(angle),d/2*sin(angle),0])cylinder(r=t/2,h=h,$fn=resolution);
					}
				}
			}
		else{
			if(mode==3){
				union(){
					sector(angle,d,h)tubeOI(d,t,h,resolution=resolution);
					if(extreme==true){
						translate([d/2-(d-t)/4,0,0])cylinder(r=(d-t)/4,h=h,$fn=resolution);
						translate([(d/2-(d-t)/4)*cos(angle),(d/2-(d-t)/4)*sin(angle),0])cylinder(r=(d-t)/4,h=h,$fn=resolution);
						}
					}
				}
			}
		}
	}
}

//torus_sector(d1=15,d2=4,angle=215,mode=3,extreme=true,resolution=50);
//tube_sector(d=24,t=11,h=15,angle=250,mode=1,extreme=true,resolution=50);

pyramid_circumscribed(n=10,d=8,h=4);
