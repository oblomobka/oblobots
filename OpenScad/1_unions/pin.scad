// pin [UNIONS] v.02
// (c) Jorge Medal (@oblomobka)  2015.08 
// GPL license

// Librerías que siguen una ruta relativa a este archivo
include <../2_helpers/presets_unions.scad>
include <../2_helpers/external_elements.scad>
use <../2_helpers/external_elements_modules.scad>

// Librerías que deben instalarse en Built-In library location
// según https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Libraries 
// Se pueden encontrar aquí -> https://github.com/oblomobka/OpenSCAD/tree/master/libraries
include <oblomobka/constants.scad>
use <oblomobka/functions.scad>
use <oblomobka/transformations.scad>
use <oblomobka/solids.scad>

// PIN (+)
{
// Pin general - si SIMPLE el pin será un cilindro, si se define TAB- (TABNORMAL, TABWIDE, TABFINE) será un pin expandible en la punta
module pin (	pin=[12,20,SIMPLE],	    // [d,h,[tab]]	medidas generales del pin
                                        // [tab] representa las medidas de la pestaña [d,cruz,expand]
                base=[0,0,0,0],			// [d1,d2,h,n] medidas y forma de la base. Opcional
                play=0.0			    // ajuste del diámetro. Suma o resta al diámetro del pin[0]
                ){
                    
    translate([0,0,-base[2]])                   
    if(pin[2]==SIMPLE){
        pin_simple(pin=pin,base=base,play=play);
        }
    else{
        pin_expand(pin=pin,base=base,play=play);
        }
    }

// Auxiliares

// Pin cilíndrico simple. Tiene un ligero achafalnado en la punta
module pin_simple(	pin=[12,20,SIMPLE],		// [d,h]	medidas generales del pin
					base=[0,0,0,0],	        // [d1,d2,h,n] medidas y forma de la base. Opcional
					play=0.0	        // ajuste del diámetro. Suma o resta al diámetro del pin[0]
					){
					
    $fn=50;

    defaultplay=-0.1;

    dp=lim(4,pin[0],20)+defaultplay+play;	// diámetro del pin
    hp=lim(5,pin[1],30);					// longitud del pin
    db1=lim(dp,base[0],100);				// diámetro de la base1
    db2=lim(dp,base[1],db1);				// diámetro de la base2 si es =db1 es un prisma rectangular
    hb=base[2];								// longitud de la base
    nb=lim(4,base[3],50);					// lim:(4<-->50) nº de lados del prisma base	

    hp1=1;								    // rebaje de la punta
    hp2=hp-hp1;

    translate([0,0,hb])
        union(){
            cylinder(r=dp/2, h=hp2);
            translate([0,0,hp2])
                cylinder (r1=dp/2,r2=(dp-2)/2,h=hp1);
            if(hb==0){
                translate([0,0,-hb])
                    pyramid_circumscribed(d1=db1,d2=db2,h=hb,n=0);
                }
            else{
                translate([0,0,-hb])
                    pyramid_circumscribed(d1=db1,d2=db2,h=hb,n=nb);
                }
            }
    }


// Pin que se ensancha en la punta
module pin_expand (	pin=[12,20,TABNORMAL],	// [d,h,[tab]]	medidas generales del pin
											// [tab] representa las medidas de la pestaña [d,cruz,expand]
					base=[0,0,0,0],			// [d1,d2,h,n] medidas y forma de la base. Opcional
					play=0.0			    // ajuste del diámetro. Suma o resta al diámetro del pin[0]
					){

    $fn=50;
    defaultplay=-0.3;

    dp=lim(4,pin[0],20)+defaultplay+play;		// diámetro del pin
    hp=lim(5,pin[1],30);						// longitud del pin
    db1=max(dp,base[0]);						// diámetro de la base1
    db2=lim(dp,base[1],db1);				    // diámetro de la base2 si es =db1 es un prisma rectangular
    hb=base[2];							        // longitud de la base
    nb=lim(4,base[3],50);					    // lim:(4<-->50) nº de lados del prisma base							


    cross=dp*(lim(25,pin[2][1],100)/400);
    core=dp*(lim(25,pin[2][0],100)/100);
    expand=lim(30,pin[2][2],100)/100;		    // valor de la expansión del pin en la punta

    dpe=dp+expand;
    hpe=hp/15;


    translate([0,0,hb])
        difference(){
            union(){
                cylinder(r=dp/2,h=hp/2);
                translate([0,0,hp/2])
                    cylinder(r1=dp/2,r2=dpe/2,h=hp/2-hpe);
                translate([0,0,hp-hpe])
                    cylinder (r1=dpe/2,r2=(dp-1)/2,h=hpe-0.05);
                if(hb==0){
                    translate([0,0,-hb])
                        pyramid_circumscribed(d1=db1,d2=db2,h=hb,n=0);
                    }
                else{
                    translate([0,0,-hb])
                        pyramid_circumscribed(d1=db1,d2=db2,h=hb,n=nb);
                    }
                }

            translate([0,0,hp])
                for(i=[90,180]){
                    rotate([0,0,i])
                        union(){
                            cube([2*dp,cross,hp],center=true);
                            translate([0,0,-hp/2])rotate([90,0,0])
                                cylinder(r=cross/2,h=2*pin[0],center=true);
                            }
                    }
            cylinder(r=core/2,h=3*hp, center=true);
            }
    }

    
}



// PIN (-)
{
// Alojamiento del pin - si SIMPLE el pin será un cilindro, si se define TAB- (TABNORMAL, TABWIDE, TABFINE) será un pin expandible en la punta
module socket (	pin=[12,20,TABNORMAL] ){	// [d,h,[tab]]	medidas generales del pin
                                            // [tab] representa las medidas de la pestaña [d,cruz,expand]

    if(pin[2]==SIMPLE){ socket_polygonal(pin=pin); }
    else{ socket_expand(pin=pin); }
}


// Auxiliares

// Taladro poligonal para volumen macizo.
// Dibuja el volumen, se hace el taladro mediante difference(){}
module socket_polygonal (pin=[12,6,SIMPLE]){

    n=6;			        // Nº de lados del taladro (el taladro es poligonal, normalmente será hexagonal)

    dp=lim(4,pin[0],20);	// diámetro del taladro
    hp=lim(5,pin[1],30);	// profundidad del taladro

    translate([0,0,-0.2])
        intersection(){
            cylinder (r=(dp/cos(180/n))/2,h=hp+0.2,$fn=n);
            cylinder (r=(dp+dp/20)/2,h=hp+0.2);
            }
}


// Taladro que se ensancha en la punta
// Dibuja el volumen, se hace el taladro mediante difference(){}
module socket_expand (pin=[12,6,TABNORMAL]){

    $fn=50;

    dp=lim(4,pin[0],20);				// diámetro del taladro
    hp=lim(5,pin[1],30);				// profundidad del taladro

    expand=lim(30,pin[2][2],100)/100;	// valor de la expansión del pin en la punta
    dpe=dp+expand;
    hpe=hp/15;

    translate([0,0,-0.05])
    union(){
        translate([0,0,-0.5])
            cylinder(r=dp/2,h=0.5+hp/2);
        translate([0,0,(hp-0.05)/2])
            cylinder(r1=dp/2,r2=dpe/2,h=hp/2-hpe);
        translate([0,0,hp-hpe-0.05])
            cylinder (r1=dpe/2,r2=(dp-1)/2,h=hpe);
        }
}

// Alojamiento del pin - si SIMPLE el pin será un cilindro, si se define TAB- (TABNORMAL, TABWIDE, TABFINE) será un pin expandible en la punta
module SocketPod (	pin=[12,20,TABNORMAL],	// [d,h,[tab]]	medidas generales del pin
											// [tab] representa las medidas de la pestaña [d,cruz,expand]
					t=3						// espesor de la caña donde se alojará el pin correspondiente
					){

if(pin[2]==SIMPLE){
	socket_polygonal_pod(pin=pin,t=t)
		children (0);
	}
	else{
		socket_expand_pod(pin=pin,t=t)
			children (0);
	}
}

// Auxiliares
// Taladro poligonal para volumen hueco - Añade una caña donde alojar el pin de espesor t.
// Funciona como una transformación
module socket_polygonal_pod (	pin=[12,6,SIMPLE],		// [d,h]	medidas generales del pin
                                t=3					// espesor de la caña donde se alojará el pin correspondiente
                                ){

    $fn=50;
    s=6;			        // Nº de lados del taladro (el taladro es poligonal, normalmente será hexagonal)

    dp=lim(4,pin[0],20);	// diámetro del taladro
    hp=lim(5,pin[1],30);	// profundidad del taladro


    difference(){
        children (0);
        cylinder (r=(dp+2*t)/2,h=2*hp,center=true);	
        }

    color("red")
    difference(){
        cylinder (r=(dp+2*t)/2,h=hp+t);
        translate([0,0,-0.2])
            intersection(){
                cylinder (r=(dp/cos(180/s))/2,h=hp+0.2,$fn=s);
                cylinder (r=(dp+dp/20)/2,h=hp+0.2);
            }
        }
}


// Taladro que se ensancha en la punta con caña
// Funciona como una transformación
module socket_expand_pod (	pin=[12,6,TABNORMAL],	// [d,h]	medidas generales del pin
							t=3					// espesor de la caña donde se alojará el pin correspondiente
							){
    $fn=50;
    dp=lim(4,pin[0],20);				    // diámetro del taladro
    hp=lim(5,pin[1],30);				    // profundidad del taladro

    expand=lim(30,pin[2][2],100)/100;		// valor de la expansión del pin en la punta
    dpe=dp+expand;
    hpe=hp/15;

    //color("green")
    difference(){
        children (0);	
            cylinder (r=(dp+2*t)/2,h=2*hp,center=true);	
        }

    //color("green")
        difference(){
            cylinder (r=(dp+2*t)/2,h=hp+t);
            union(){
                translate([0,0,-0.5])
                    cylinder(r=dp/2,h=0.5+hp/2);
                translate([0,0,(hp-0.05)/2])
                    cylinder(r1=dp/2,r2=dpe/2,h=hp/2-hpe+0.05);
                translate([0,0,hp-hpe])
                    cylinder (r1=dpe/2,r2=(dp-1)/2,h=hpe);
                }
            }
}



}


// EJEMPLOS

i=30;

translate([0,0,0]){
    translate([0,0,0])
        pin (   pin=[10,16,SIMPLE],
                base=[20,20,5,4],
                play=0.0);

    translate([i,0,0])
        pin (   pin=[8,15,TABNORMAL],
                base=[10,4,5,50],
                play=0.0);

    translate([2*i,0,0])
        pin (   pin=[10,15,TABFINE],
                base=[15,12,2,4],
                play=0.0);

    translate([3*i,0,0])
        pin (   pin=[15,10,TABWIDE],
                base=[0,0,0,0],
                play=0.0);
}

translate([0,i,0]){
    translate([0,0,0])
        socket (   pin=[12,30,SIMPLE]);
    
    color("green")
    translate([i,0,0])
        sector(180)
        SocketPod ( pin=[12,20,SIMPLE] )
            cylinder(r=15,h=30);
    
    translate([i,0,-0])    
    pin (   pin=[12,20,SIMPLE],
                base=[20,15,5,50],
                play=-0.2);
    
    
    
   translate([2*i,0,0])
        socket (   pin=[12,30,TABWIDE]);

   translate([3*i,0,0])
        sector(270)
        SocketPod ( pin=[10,25,SIMPLE] )
            translate([0,0,15])
            cube([20,20,30],center=true);
}