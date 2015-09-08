// total_joint [UNIONS] v.03
// (C) @oblomobka - 2015.08
// GPL license

// Librerías que siguen una ruta relativa a este archivo
include <../2_helpers/external_elements.scad>
use <../2_helpers/external_elements_modules.scad>

// Librerías que deben instalarse en Built-In library location
// según https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries 
// Se pueden encontrar aquí -> https://github.com/oblomobka/OpenSCAD/tree/master/libraries
include <oblomobka/constants.scad>
use <oblomobka/functions.scad>
use <oblomobka/transformations.scad>
use <oblomobka/solids.scad>

//	Límites
d_pin_minmax=[10,30];			//	d_pin=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);			
h_pin_minmax=[0,10];			//	h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);

// TOTAL JOINTS
{
// Uniones sueltas.
// Piezas utiles para colocar manualmente en cualquier volumen que dispongan del hueco necesario (shaft_base() definido en shaft.scad)
{
module total_joint_sphere (	pin=[15,4],		// Medidas generales de la union [diámetro total, altura y diámetro del pin]
							angle=360,
							mode=2,			// 1-> La posición de entrada es enfrente del pin
											// 2-> Hay dos entradas en los extremos del rail
							play=0.0,		
							polygonal=8,	// Forma del contenedor del Pin. Cilindrico por defecto. El valor marca el polígono (circunscrito en la circunferencia de diametro_total pin[0]
							res=24)
							{

d_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);
h_pin=d_pin;		// h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);

d_total=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);	// Representa el diámetro de la unión completa, no sólo el pin

r_neck=d_pin*cos(45)/2;

d_rail=d_total-d_pin-2;	// La cifra marca el espesor de la pared (/2) de la pieza. Se podría parametrizar también
d_pin_hole=d_pin+play;	// el valor play permite hacer piezas mas o menos ajustadas

angle_enter=2*atan2(d_pin/2+0.0,sqrt(pow((d_rail/2),2)-pow(d_pin/2+0.1,2)));		// angulo de entrada en los extremos
angle_max=360-4*atan2(r_neck+0.1,sqrt(pow((d_rail/2),2)-pow(r_neck+0.1,2)));		// Tope de giro que lo marca el diametro del pin
angle_minmax=[1,angle_max];
angle_rail=lim(angle_minmax[0],angle,angle_minmax[1]);

angle_extreme=max(180-angle_rail/2,angle_enter);

// Describe la cabeza del pin. Una esfera con cuello. 
module pin_head (d,h,res){
	cylinder (r=r_neck,h=h-d+(d/2-d*cos(45)/2),$fn=res);
		translate([0,0,h-d/2])sphere(r=d/2,$fn=res);
}

// Dibuja el pin
translate([d_rail/2,0,0])pin_head(d=d_pin,h=h_pin,res=res);

difference(){
	// La siguiente condicional hace que cuando el contenedor es poligonal el pin siempre coincida con una cara plana
	if(polygonal%2!=0){
		rotate([0,0,90/polygonal])
		// Dibuja el cuerpo del contenedor donde se resta el rail y el pin
		union(){
			translate([0,0,-h_pin-1])pyramid_circumscribed(n=polygonal,d2=d_total,d1=(d_total-1),h=1); // 1 es el valor de suelo. Se podría parametrizar
			translate([0,0,-h_pin])prism_circumscribed(n=polygonal,d=d_total,h=h_pin);
		}
	}
	else{
		rotate([0,0,0])
		// Dibuja el cuerpo del contenedor donde se resta el rail y el pin
		union(){
			translate([0,0,-h_pin-1])pyramid_circumscribed(n=polygonal,d2=d_total,d1=(d_total-1),h=1);
			translate([0,0,-h_pin])prism_circumscribed(n=polygonal,d=d_total,h=h_pin);
		}
	}
	translate([0,0,-(h_pin-d_pin/2)])rotate([0,0,(360-angle_rail)/2]){	
		// estos módulo se encuentra definidos en solids_oblomobka.scad. El modo 2 representa genera el carril a partir de la linea neutra y los espesores del tubo y del toro
		torus(torus=[d_rail,d_pin_hole],angle=angle_rail,mode=2,res=res);
		tube(tube=[d_rail,2*r_neck,h_pin,50],angle=angle_rail,mode=2,res=res);
		}
    
    // La condicinal que sigue define la posición de entrada. si mode=2 entra en los extremos, si mode=1, entra en frente del pin
	if (mode==2){
		for(i=[1,-1]){
			rotate([0,0,(180-angle_extreme)*i])translate([-d_rail/2,0,-(h_pin-d_pin/2)])
			cylinder(r=(d_pin)/2+play,h=h_pin+2,$fn=res);
			}
		}
		else{
			translate([-d_rail/2,0,-(h_pin-d_pin/2)])cylinder(r=(d_pin)/2+play,h=h_pin+2,$fn=res);
		}
	}
}

module total_joint_cone (	pin=[15,4],		// Medidas generales de la union [diámetro total, altura y diámetro del pin]
							angle=360,
							mode=2,			// 1-> La posición de entrada es enfrente del pin
											// 2-> Hay dos entradas en los extremos del rail
							play=0.0,		
							polygonal=8,	// Forma del contenedor del Pin. Cilindrico por defecto. El valor marca el polígono (circunscrito en la circunferencia de diametro_total pin[0]
							res=24)
							{

d_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);
h_pin=d_pin/2;		// h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);

d_total=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);	// Representa el diámetro de la unión completa, no sólo el pin

r_neck=2.5*d_pin/8;

d_rail=d_total-d_pin-2;	// La cifra marca el espesor de la pared (/2) de la pieza. Se podría parametrizar también
d_pin_hole=d_pin+play;	// el valor play permite hacer piezas mas ajustadas o menos	

angle_enter=2*atan2(d_pin/2+0.0,sqrt(pow((d_rail/2),2)-pow(d_pin/2+0.1,2)));		// angulo de entrada en los extremos
angle_max=360-4*atan2(r_neck+0.1,sqrt(pow((d_rail/2),2)-pow(r_neck+0.1,2)));		// Tope de giro que lo marca el diametro del pin
angle_minmax=[1,angle_max];
angle_rail=lim(angle_minmax[0],angle,angle_minmax[1]);

angle_extreme=max(180-angle_rail/2,angle_enter);

// Describe la parte del pin. un cono invertido. Hace la parte positiva del machihembrado 
module pin_head (d,h,res){
	cylinder (r=r_neck,h=h,$fn=res);
	translate([0,0,h-d/2])cylinder (r1=d/4,r2=d/2,h=d/2,$fn=res);
}

// Dibuja el pin
translate([d_rail/2,0,0])pin_head(d=d_pin,h=h_pin,res=res);

difference(){
	// La siguiente condicional hace que cuando el contenedor es poligonal el pin siempre coincida con una cara plana
	if(polygonal%2!=0){
		rotate([0,0,90/polygonal])
		// Dibuja el cuerpo del contenedor donde se resta el rail y el pin
		union(){
			translate([0,0,-h_pin-1])pyramid_circumscribed(n=polygonal,d2=d_total,d1=(d_total-1),h=1); // 1 es el valor de suelo. Se podría parametrizar
			translate([0,0,-h_pin])prism_circumscribed(n=polygonal,d=d_total,h=h_pin);
		}
	}
	else{
		rotate([0,0,0])
		// Dibuja el cuerpo del contenedor donde se resta el rail y el pin
		union(){
			translate([0,0,-h_pin-1])pyramid_circumscribed(n=polygonal,d2=d_total,d1=(d_total-1),h=1);
			translate([0,0,-h_pin])prism_circumscribed(n=polygonal,d=d_total,h=h_pin);
		}
	}

	translate([0,0,-(h_pin/2)])rotate([0,0,(360-angle_rail)/2]){	
		// estos módulo se encuentra definidos en solids_oblomobka.scad. El modo 2 representa genera el carril a partir de la linea neutra y los espesores del tubo y del toro
		trapezium_revolution(d=d_rail,trapezium=[d_pin_hole,d_pin_hole/2,d_pin_hole/2],angle=angle_rail,mode=2,res=res);
		tube(tube=[d_rail,2*r_neck,h_pin,50],angle=angle_rail,mode=2,res=res);
		}

	// La condicinal que sigue define la posición de entrada. si mode=2 entra en los extremos, si mode=1, entra en frente del pin
	if (mode==2){
		for(i=[1,-1]){
			rotate([0,0,(180-angle_extreme)*i])translate([-d_rail/2,0,-(h_pin)])
			cylinder(r=(d_pin)/2+play,h=h_pin+2,$fn=res);
			}
		}

		else{
			translate([-d_rail/2,0,-(h_pin)])cylinder(r=(d_pin)/2+play,h=h_pin+2,$fn=res);
		}
	}
}
}
// Incorporan la union a un volumen cualquiera.
// Funciona como una transformación.
// Debe ir en una cara paralela a la superficie de impresión
{
module TotalJointSphere (	pin=[15,4],
                            angle=360,
                            mode=2,			// 1-> La posición de entrada es enfrente del pin
                                            // 2-> Hay dos entradas en los extremos del rail
                            play=0.0,		
                            z=0,
                            direction=0,
                            res=24)
                            {

d_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);
h_pin=d_pin;		// h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);

d_total=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);	// Representa el diámetro de la unión completa, no sólo el pin

r_neck=d_pin*cos(45)/2;

d_rail=d_total-d_pin-2;		// La cifra marca el espesor de la pared (/2) de la pieza. Se podría parametrizar también
d_pin_hole=d_pin+play;		// el valor play permite hacer piezas mas ajustadas o menos	

angle_enter=2*atan2(d_pin/2+0.0,sqrt(pow((d_rail/2),2)-pow(d_pin/2+0.1,2)));		// angulo de entrada en los extremos

angle_max=360-4*atan2(r_neck+0.1,sqrt(pow((d_rail/2),2)-pow(r_neck+0.1,2)));		// Tope de giro que lo marca el diametro del pin
angle_minmax=[1,angle_max];
angle_rail=lim(angle_minmax[0],angle,angle_minmax[1]);

angle_extreme=max(180-angle_rail/2,angle_enter);

module pin_head (	d,h,res=res){
	cylinder (r=r_neck,h=h-d+(d/2-d*cos(45)/2),$fn=res);
		translate([0,0,h-d/2])sphere(r=d/2,$fn=res);
}

union(){
difference(){
	children();
		rotate([0,0,direction])translate([0,0,z-(h_pin-d_pin/2)])rotate([0,0,(360-angle_rail)/2]){	
		// estos módulo se encuentra definidos en solids_oblomobka.scad. El modo 2 representa genera el carril a partir de la linea neutra y los espesores del tubo y del toro
		torus(torus=[d_rail,d_pin_hole],angle=angle_rail,mode=2,res=res);
		tube(tube=[d_rail,2*r_neck,h_pin,50],angle=angle_rail,mode=2,res=res);
		}
        
    // La condicinal que sigue define la posición de entrada. si mode=2 entra en los extremos, si mode=1, entra en frente del pin
	if (mode==2){
		for(i=[1,-1]){
			rotate([0,0,(180-angle_extreme)*i+direction])translate([-d_rail/2,0,-(h_pin-d_pin/2)+z])
			cylinder(r=(d_pin)/2+play,h=h_pin+2,$fn=res);
			}
		}
		else{
			rotate([0,0,direction])translate([-d_rail/2,0,-(h_pin-d_pin/2)+z])cylinder(r=(d_pin)/2+play,h=h_pin+2,$fn=res);
		}
	}
translate([cos(direction)*d_rail/2,sin(direction)*d_rail/2,z])pin_head(d=d_pin,h=h_pin,res=res);
}
}

module TotalJointCone (	pin=[15,4],
						angle=360,
						mode=2,			// 1-> La posición de entrada es enfrente del pin
										// 2-> Hay dos entradas en los extremos del rail
						play=0.0,		
						z=0,
						direction=0,
						res=24)
						{

d_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);
h_pin=d_pin/2;		// h_pin=lim(h_pin_minmax[0],pin[1],h_pin_minmax[1]);

d_total=lim(d_pin_minmax[0],pin[0],d_pin_minmax[1]);	// Representa el diámetro de la unión completa, no sólo el pin

r_neck=2.5*d_pin/8;

d_rail=d_total-d_pin-2;		// La cifra marca el espesor de la pared (/2) de la pieza. Se podría parametrizar también
d_pin_hole=d_pin+play;		// el valor play permite hacer piezas mas ajustadas o menos	

angle_enter=2*atan2(d_pin/2+0.0,sqrt(pow((d_rail/2),2)-pow(d_pin/2+0.1,2)));		// angulo de entrada en los extremos

angle_max=360-4*atan2(r_neck+0.1,sqrt(pow((d_rail/2),2)-pow(r_neck+0.1,2)));		// Tope de giro que lo marca el diametro del pin
angle_minmax=[1,angle_max];
angle_rail=lim(angle_minmax[0],angle,angle_minmax[1]);

angle_extreme=max(180-angle_rail/2,angle_enter);

// Describe la parte del pin. un cono invertido. Hace la parte positiva del machihembrado 
module pin_head (	d,h,res){
	cylinder (r=r_neck,h=h,$fn=res);
	translate([0,0,h-d/2])cylinder (r1=d/4,r2=d/2,h=d/2,$fn=res);
}

union(){
difference(){
	children();
		rotate([0,0,direction])translate([0,0,z-(h_pin/2)])rotate([0,0,(360-angle_rail)/2]){	
		// estos módulo se encuentra definidos en solids_oblomobka.scad. El modo 2 representa genera el carril a partir de la linea neutra y los espesores del tubo y del toro
		trapezium_revolution(d=d_rail,trapezium=[d_pin_hole,d_pin_hole/2,d_pin_hole/2],angle=angle_rail,mode=2,res=res);
		tube(tube=[d_rail,2*r_neck,h_pin,50],angle=angle_rail,mode=2,res=res);
		}
        
    // La condicinal que sigue define la posición de entrada. si mode=2 entra en los extremos, si mode=1, entra en frente del pin
	if (mode==2){
		for(i=[1,-1]){
			rotate([0,0,(180-angle_extreme)*i+direction])translate([-d_rail/2,0,-(h_pin)+z])
			cylinder(r=(d_pin)/2+play,h=h_pin+2,$fn=res);
			}
		}
		else{
			rotate([0,0,direction])translate([-d_rail/2,0,-(h_pin)+z])cylinder(r=(d_pin)/2+play,h=h_pin+2,$fn=res);
		}
	}
translate([cos(direction)*d_rail/2,sin(direction)*d_rail/2,z])pin_head(d=d_pin,h=h_pin,res=res);
}
}
}

}
// EJEMPLOS

i=30;

res=12;

translate([0,0,0]){

    translate([0,0,0])
        total_joint_sphere	(pin=[17,5],mode=2,angle=360,play=0,polygonal=12,res=res);
    
    translate([0,i,0])
        total_joint_cone	(pin=[20,6],mode=2,angle=360,play=0.1,polygonal=32,res=res);
    
    translate([0,2*i,0])
        total_joint_cone	(pin=[15,4],mode=1,angle=360,play=0.1,polygonal=4,res=res);

    translate([0,3*i,0])
        total_joint_sphere	(pin=[25,4],mode=2,angle=360,play=0,polygonal=32,res=res);

}

translate([2*i,0,0]){

    translate([0,0,0])
        TotalJointSphere ( pin=[15,4], angle=180, mode=1, play=0.0, z=40, direction=30, res=res)
            translate([0,0,20])cube([20,20,40],center=true);
    
    translate([0,i,0])
        TotalJointCone ( pin=[20,4], angle=360, mode=1, play=0.0, z=20, direction=0, res=res)
            cylinder(r=15,h=20,$fn=6);
   
    translate([0,2*i,0])
        TotalJointCone ( pin=[18,4], angle=360, mode=2, play=0.0, z=10, direction=22.5, res=res)
            cylinder(r1=15,r2=10,h=10,$fn=8);
    
    translate([0,3*i,0])
        TotalJointCone ( pin=[15,4], angle=360, mode=1, play=0.0, z=5, direction=0, res=24)
            cylinder(r=8,h=5,$fn=50);
}
