// magnet [UNIONS] v.02
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

// IMAN FIJO
{
// representa el volumen del iman que se debe eliminar de la pieza donde se pegará
module magnet_fixed (   magnet=[6,2],
                        play=[0.3,0,2]
                        ){                     
                            
    $fn=32;                            
    d=magnet[0];
    h=magnet[1];
    d_play=play[0];
    h_play=play[1];

    translate([0,0,-0.1])                  
        cylinder (r=(d+d_play)/2,h=h+h_play);
                            
    }

// El rebaje para el imán se realiza sobre una base que se puede introducir manualmente en una pieza
module magnet_fixed_base (  magnet=[6,2],
                            play=[0.3,0,2],
                            base=[15,4,8]
                            ){                     
                                
    $fn=32;                            
    d=magnet[0];
    h=magnet[1];
    d_play=play[0];
    h_play=play[1];

    difference(){
        // Dibuja la base
        union(){
            translate([0,0,-base[1]])pyramid_circumscribed(n=base[2],d2=base[0],d1=base[0]-1,h=1);
            translate([0,0,-base[1]+1])prism_circumscribed(n=base[2],d=base[0],h=base[1]-1);
            }
        // Resta el iman
        rotate([0,180,0])    
            magnet_fixed(magnet=magnet,play=play);
        }
                               
    }

}

// IMAN SUELTO
{
// representa un contenedor donde el iman puede girar libremente para escoger el polo apropiado
// se debe restar de la pieza donde se quiera incorporar

module magnet_loose (   magnet=[6,2],
                        t=0.6,           // pared de la pieza donde apoyara interiormente el iman
                        play=1           // aquí el juego debe permitir girar el imán en el interior de la pieza     
                        ){

    $fn=32;
    d=magnet[0];
    h=magnet[1];                        
                                
    // diámetro de la esfera donde el imán puede girar libremente
    d_spin=sqrt(pow(d,2)+pow(h,2));


    union(){
        translate([0,0,-0.1])
            cube([d_spin,h,t+d_spin],center=true);
        translate([0,0,t])       
            cylinder (r=(d_spin)/2,h=h);
        translate([0,0,t+h-0.05])       
            cylinder (r2=(d_spin+play)/2,r1=(d_spin)/2,h=play/2+0.1);
        translate([0,0,t+h+play/2])
            cylinder (r=(d_spin+play)/2,h=d_spin+play/2-h);
        }    
}
module magnet_loose_base_open (  magnet=[6,2],
                            t=0.6,
                            play=0.6,
                            base=[15,2,8]
                            ){                     
                            
    $fn=32;                            
    d=magnet[0];
    h=magnet[1];
    d_spin=sqrt(pow(d,2)+pow(h,2));
    h_base=max(base[1],d_spin+play+t-0.1);                                
                                    

    //translate([0,0,h_base])
    difference(){
        // Dibuja la base
        union(){
            translate([0,0,-h_base])pyramid_circumscribed(n=base[2],d2=base[0],d1=base[0]-1,h=1);
            translate([0,0,-h_base+1])prism_circumscribed(n=base[2],d=base[0],h=h_base-1);
            }
        // Resta el contenedor del iman con giro
        rotate([0,180,0])    
            union(){
                translate([0,0,t])       
                    cylinder (r=(d_spin)/2,h=h);
                translate([0,0,t+h-0.05])       
                    cylinder (r2=(d_spin+play)/2,r1=(d_spin)/2,h=play/2+0.1);
                translate([0,0,t+h+play/2])
                    cylinder (r=(d_spin+play)/2,h=5*d_spin+play/2-h);
            }   
        }                           
    }

module magnet_loose_base_close (    magnet=[6,2],
                                    t=0.6,
                                    play=1,
                                    base=[15,8,8]
                                    ){                     
                            
    $fn=32;                            
    d=magnet[0];
    h=magnet[1];
                                    
    d_spin=sqrt(pow(d,2)+pow(h,2));

    //translate([0,0,base[1]])
    difference(){
        // Dibuja la base
        union(){
            translate([0,0,-base[1]])pyramid_circumscribed(n=base[2],d2=base[0],d1=base[0]-1,h=1);
            translate([0,0,-base[1]+1])prism_circumscribed(n=base[2],d=base[0],h=base[1]-1);
            }
        // Resta el contenedor del iman con giro
        rotate([0,180,0])    
            magnet_loose (  magnet=magnet,t=t,play=play);
        }                           
    }

}

i=30;

translate([0,0,0]){
    
    translate([0,0,0])
        difference(){
            cylinder(r=10,h=30);
            translate([0,0,30])
                rotate([0,180,0])
                magnet_fixed(magnet=[6,2],play=[0.1,0.2]);   
            }
     translate([0,0,30])
        rotate([0,180,0])
            magnet(6,2);

    translate([i,0,0])
        difference(){
            translate([0,0,10])
            cube([20,40,20],center=true);
            translate([0,10,20])
                rotate([0,180,0])
                magnet_fixed(magnet=[6,2],play=[0,0]);
            translate([0,-10,20])
                rotate([0,180,0])
                magnet_fixed(magnet=[6,2],play=[0,0]);
            translate([0,-20,10])
                rotate([90,,0])
                rotate([0,180,0])
                magnet_fixed(magnet=[6,2],play=[0,0]);
            }

}

translate([0,i,0]){
    translate([0,0,0]){
        magnet_fixed_base ( magnet=[6,2],
                            play=[0.3,0,2],
                            base=[18,4,50]);
        rotate([180,0,0])
        magnet ( magnet=[6,2]);
    }
    
    translate([i,0,0])
        magnet_fixed_base ( magnet=[8,2],
                            play=[0.3,0,2],
                            base=[10,6,50]);
    
    translate([2*i,0,0])
        magnet_fixed_base ( magnet=[10,1],
                            play=[0.3,0,2],
                            base=[15,4,8]);
    
    translate([3*i,0,0])
        magnet_fixed_base ( magnet=[4,1],
                            play=[0.3,0,2],
                            base=[12,3,5]);
    
}

translate([0,2*i,0]){
    translate([0,0,0])
        sector(180) // para ver el interior. Cegar esta linea para generar stl
        difference(){
            translate([0,0,5])
            cube([20,20,10],center=true);
            magnet_loose ( magnet=[6,2],t=0.5,play=0.5);
        }
    
    // Imán    
    translate([0,0,0.5+sqrt(pow(6,2)+pow(2,2))/2])
            rotate([rands(0,90,1)[0],rands(0,90,1)[0],rands(0,90,1)[0]])
            translate([0,0,-1])
                magnet(6,2);
    
    translate([i,0,0]){
        sector(270) // para ver el interior. Cegar esta linea para generar stl
        magnet_loose_base_open ( magnet=[6,2],
                            t=0.6,
                            play=0.6,
                            base=[10,1,8]);
        
        // Imán 
        translate([0,0,-(0.5+sqrt(pow(6,2)+pow(2,2))/2)])
            rotate([rands(0,90,1)[0],rands(0,90,1)[0],rands(0,90,1)[0]])
            translate([0,0,-1])
                magnet(6,2);
        }
        
    
    translate([2*i,0,0]){
        sector(180)
        magnet_loose_base_close ( magnet=[6,2],
                            t=0.6,
                            play=0.6,
                            base=[10,10,50]);
        
        // Imán 
        translate([0,0,-(0.5+sqrt(pow(6,2)+pow(2,2))/2)])
            rotate([rands(0,90,1)[0],rands(0,90,1)[0],rands(0,90,1)[0]])
            translate([0,0,-1])
                magnet(6,2);
        }
    
    translate([3*i,0,0]){
        sector(180)
        magnet_loose_base_open ( magnet=[6,2],
                            t=0.6,
                            play=0.6,
                            base=[12,12,50]);
        
        // Imán 
        translate([0,0,-(0.5+sqrt(pow(6,2)+pow(2,2))/2)])
            rotate([rands(0,90,1)[0],rands(0,90,1)[0],rands(0,90,1)[0]])
            translate([0,0,-1])
                magnet(6,2);
        }
        
    
}