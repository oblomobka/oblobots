// external elements modules [UNIONS] v.13
// librería de elementos externos comerciales (botones automáticos, espigas de madera baterías, ...) 
// (c) Jorge Medal (@oblomobka) 2015.09 
// GPL license

use <oblomobka/solids.scad>
include <external_elements.scad>

// MÓDULOS

// Junta tórica de goma
module o_ring (d1=9,d2=1.5){
    
    color("black",0.8)
    torusOD(d1=d1,d2=d2,res=32);
}

// Imán cilíndrico
module magnet (d=6, h=2){
    
    $fn=24;
    color("grey",0.8)
        translate([0,0,0])
        cylinder (r=d/2,h=h);
}

// Botón automático
module fastener (   model=PRYM_SNAP_FASTENERS_11,
                    type=PLUG
                    ){
    
    $fn=24;

    d1_socket=model[0];
    h1_socket=model[1];
    d2_socket=model[2];
    h2_socket=model[3];
    d1_plug=model[4];
    h1_plug=model[5];
    d2_plug=model[6];
    h2_plug=model[7];
                            

    if(type==0){
        color("grey",1)
        translate([0,0,-h1_socket])
            tubeOI (d1=d1_socket,d2=d2_socket-1,h=h1_socket);
        }
    else{
        color("grey",1)
        if(type==1){
         translate([0,0,-h1_plug])
            cylinder (r=d1_plug/2,h=h1_plug);
         translate([0,0,h2_plug-d2_plug/2])
            sphere(d2_plug/2);
            cylinder (r=(d2_plug-0.5)/2,h=h2_plug-d2_plug/2);
            }
        }
}

// Ventosa
module suction_pad (head=[7,4,4,2.5], suction=[20,7]){
    $fn=50;
    d_head=head[0];
    h_head=head[1];
    d_neck=head[2];
    h_neck=head[3];
        
    d_suction=suction[0];
    h_suction=suction[1];
        
     color("white",0.8)
       translate([0,0,-0.3]) 
        union(){
        translate([0,0,0])
            cylinder(r=d_neck/2,h=h_neck+0.1 );
        translate([0,0,h_neck])
            cylinder(r1=d_head/2,r2=(d_neck-1)/2 ,h=h_head );
        translate([0,0,-1])
            cylinder(r=(d_head+2)/2,,h=1 );
        difference(){
            translate([0,0,-h_suction])
            cylinder(r1=d_suction/2,r2=(d_head)/2 ,h=h_suction);
            translate([0,0,-h_suction-0.5])
            cylinder(r1=d_suction/2,r2=(d_neck)/2 ,h=h_suction-2);
        }
        
    }  
}

suction_pad();

fastener();

o_ring();

!magnet();