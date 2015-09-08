// o-ring [UNIONS] v.02
// (c) Jorge Medal (@oblomobka)  2015.08
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

// PIN (+)
module pin_o_ring (     h_pin=12,       // longitud del pin
                        ring=[9,1.5],   // [diametor exterior anillo, espesor anillo]
                        play=0.2,       // juego del canal donde va la junta tórica                 
                        ){
 
    $fn=32;
    d1=ring[0];
    d2=ring[1];
    d_pin=d1-d2;                            
    bevel=2; 

    translate([0,0,-0.05])
    difference(){
        union(){
            translate([0,0,0])
                cylinder (r=d_pin/2, h=h_pin-bevel);
            translate([0,0,h_pin-bevel-0.05])
                cylinder (r1=d_pin/2,r2=d_pin/2-bevel,h=bevel);
            }
        if(h_pin>10){
            for(i=[h_pin-bevel-1-d2,3]){
                translate([0,0,i])
                    torusOD(d1=d1+play,d2=d2+play,res=32);
                }
            }
        else{
            translate([0,0,h_pin-bevel-1-d2])
                    torusOD(d1=d1+play,d2=d2+play,res=32);
            }
        }
}

module pin_o_ring_base (    h_pin=12,       // longitud del pin
                            ring=[9,1.5],   // [diametor exterior anillo, espesor anillo]
                            play=0.2,       // juego del canal donde va la junta tórica
                            base=[16,4,8]
                            ){
 
    $fn=32;
    d1=ring[0];
    d2=ring[1];
    d_pin=d1-d2;                            
    bevel=2;
                                
    union(){
        // Dibuja la base
        translate([0,0,-base[1]])
            pyramid_circumscribed(n=base[2],d2=base[0],d1=base[0]-1,h=1);
        translate([0,0,-base[1]+1])
            prism_circumscribed(n=base[2],d=base[0],h=base[1]-1);
        // Dibuja el pincho
        pin_o_ring (h_pin=h_pin, ring=ring, play=play);
    }
}


// PIN (-)
module socket_o_ring (  h_pin=12,           // longitud del pin
                        ring=[9,1.5],       // [diametor exterior anillo, espesor anillo]
                        play=0.2
                        ){
    $fn=32;
    d1=ring[0];
    d2=ring[1];
    d_pin=d1-d2/2;

    translate([0,0,-0.05])
    union(){
        translate([0,0,0])
            cylinder (r=d_pin/2, h=h_pin);
        if(h_pin>10){
            for(i=[h_pin-2-1-d2,3]){
                translate([0,0,i])
                    torusOD(d1=d1+play,d2=d2+play,res=32);
                }
            }
        else{
            translate([0,0,h_pin-2-0.5-d2])
                torusOD(d1=d1+play,d2=d2+play,res=32);
            }
        }
}

// EJEMPLOS

i=20;

translate([0,0,0]){
    sector(210)
    translate([0,0,0]){
        pin_o_ring (    ring=[9,1.5],
                        h_pin=12,
                        play=0.2);
    
    translate([0,0,12-2-1-1.55])
            o_ring(d1=9,d2=1.5);
        
    translate([0,0,3-0.05])
            o_ring(d1=9,d2=1.5);
    }
    
    translate([i,0,0]){
        pin_o_ring (    ring=[12,1.5],
                        h_pin=6,
                        play=0.2);
    
        translate([0,0,6-2-1-1.55])
            o_ring(d1=12,d2=1.5);
        }

    translate([2*i,0,0]){
        pin_o_ring_base (   ring=[9,1.5],
                            h_pin=14,
                            play=0.2,
                            base=[12,4,50]);
        translate([0,0,14-2-1-1.55])
            o_ring(d1=9,d2=1.5);
        translate([0,0,3-0.05])
            o_ring(d1=9,d2=1.5);
        }

    translate([3*i,0,0]){
        pin_o_ring_base (   ring=[6,1],
                            h_pin=10,
                            play=0.2,
                            base=[10,6,8]);  
        translate([0,0,10-2-1-1.05])
            o_ring(d1=6,d2=1);
        }
    }

translate([0,i,0]){
    
    translate([0,0,0]){
        color("green")sector(210)
        difference(){
            cylinder(r=10,h=20);
            socket_o_ring (     ring=[9,1.5],
                                h_pin=12,
                                play=0.1
                                );
            }        
        pin_o_ring_base (   ring=[9,1.5],
                            h_pin=12,
                            play=0.1,
                            base=[12,4,50]);        
        translate([0,0,12-2-1-1.55])
            o_ring(d1=9,d2=1.5);            
        translate([0,0,3-0.05])
            o_ring(d1=9,d2=1.5);
        }

    translate([i,0,0])
    sector(180)
        difference(){
            cylinder(r=6,h=14);
            socket_o_ring (     ring=[7,1.5],
                                h_pin=8,
                                play=0.1);
            }    
    }