// spike [UNIONS] v.02
// (c) Jorge Medal (@oblomobka)  2015.08
// GPL license

// Union paramétrica basada en los Open Toys de le FabShop (www.lefabshop.fr)
// http://www.thingiverse.com/thing:554850/#files

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

// SPIKE
module spike(   d=8,
                h=15,
                t=1,
                sharp=80    // de 0 a 100
                ){

translate([0,0,-0.1])
    for(i=[0,90]){
        rotate([0,0,i])
            union(){
                hull(){
                    translate([0,0,0.25])
                        cube([d,t,0.5],center=true);
                    translate([0,0,sharp*h/100+0.25])
                        cube([d/2-t/2,t,0.5],center=true);
                    }
                hull(){
                    translate([0,0,sharp*h/100+0.25])
                        cube([d/2-t/2,t,0.5],center=true);
                    translate([0,0,h-0.25])
                        cube([t,t,0.5],center=true);
                    }
                }
            }      
}

module spike_base ( spike=[8,12,0.6,75],
                    base=[15,4,8]
                    ){
    union(){
        // Dibuja la base
        translate([0,0,-base[1]])pyramid_circumscribed(n=base[2],d2=base[0],d1=base[0]-1,h=1);
        translate([0,0,-base[1]+1])prism_circumscribed(n=base[2],d=base[0],h=base[1]-1);
        // Dibuja el pincho
        spike (spike[0],spike[1],spike[2],spike[3]);
    }
   
}


// EJEMPLOS

i=20;

translate([0,0,0]){
    translate([0,0,0])
        spike_base (spike=[7,11,0.6,85],base=[14,4,36]);
    
    translate([i,0,0])
        spike ( h=12, base=8, t=0.6, sharp=50   );

    translate([2*i,0,0])
        spike ( h=15, base=8, t=0.8, sharp=90   );

    translate([3*i,0,0])
        spike ( h=8, base=12, t=1, sharp=50   );
}

translate([0,i,0]){
    translate([0,0,0])
        
     spike ( h=15, base=12, t=1, sharp=80   );
    
    translate([i,0,0])
        spike_base (spike=[6,15,0.6,50],base=[8,2,8]);
    
    translate([2*i,0,0])
        spike_base (spike=[10,10,1,80],base=[20,6,4]);
    
    translate([3*i,0,0])
        spike_base (spike=[12,18,2,80],base=[12,5,8]);  
}