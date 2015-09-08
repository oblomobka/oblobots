// suction_pad [UNIONS] v.02
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


// HUECO PARA METER UNA VENTOSA
module suction_pad_shaft (  suction_pad_head=[7,4,4,3]){
    
    $fn=50;
    d_head=suction_pad_head[0];
    h_head=suction_pad_head[1];
    d_neck=suction_pad_head[2];
    h_neck=suction_pad_head[3];
    play=0.3;
        
    union(){
        translate([0,0,h_neck-0.5])
            cylinder(r=d_head/2+play ,h=h_head+play );
        translate([0,0,(h_neck-0.5)/2])
            cylinder(r=(d_neck+1)/2+play ,h=h_neck );
        translate([0,0,-h_neck+0.1])
            cylinder(r1=d_head/2 ,r2=(d_neck+1)/2+play ,h=h_neck+(h_neck-0.5)/2 );
    }  
}

module suction_pad_base (   suction_pad_head=[7,4,4,3],
                            base=[15,6,8])
                            {
    
$fn=50;
d_head=suction_pad_head[0];
h_head=suction_pad_head[1];
d_neck=suction_pad_head[2];
h_neck=suction_pad_head[3];
    
d_base=max(d_head+2,base[0]);
h_base=max(h_head+h_neck,base[1]);
n_base=lim(3,base[2],50);    

    
difference(){
    // Dibuja la base
    union(){
        translate([0,0,-h_base])pyramid_circumscribed(n=n_base,d2=d_base,d1=d_base-1,h=1);
        translate([0,0,-h_base+1])prism_circumscribed(n=n_base,d=d_base,h=h_base-1);
        }
    // Resta el hueco para la ventosa
    rotate([0,180,0])    
        suction_pad_shaft (suction_pad_head=suction_pad_head  );
    }
}


// EJEMPLOS

i=30;

translate([0,0,0]){
    sector(270)
    translate([0,0,0])
        difference(){
            cylinder(r=15,h=10);
            suction_pad_shaft (suction_pad_head=[7,4,4,3]  );
            }
            
            suction_pad (head=[7,4,4,3], suction=[20,7]);
    translate([i,0,0])
        suction_pad_shaft (suction_pad_head=[12,6,5,3]  );

}

translate([0,i,0]){
    sector(270)
    translate([3*i,0,0]){
        suction_pad_base (suction_pad_head=[7,4,4,3],base=[15,8,50]);
    rotate([0,180,0])    
        suction_pad (head=[7,4,4,3], suction=[20,7]);
    }
    translate([i,0,0]){
        suction_pad_base (suction_pad_head=[12,6,5,3],base=[20,6,8]);
        rotate([0,180,0])    
            suction_pad (head=[12,6,5,3], suction=[30,9]);
    }
    translate([2*i,0,0]){
        suction_pad_base (suction_pad_head=[7,4,4,3],base=[12,3,5]);
        rotate([0,180,0])    
            suction_pad (head=[7,4,4,3], suction=[25,6]);
    }
    translate([0*i,0,0]){
        suction_pad_base (suction_pad_head=[7,4,4,3],base=[8,6,7]);
        rotate([0,180,0])    
            suction_pad (head=[7,4,4,3], suction=[20,7]);
    }
}
