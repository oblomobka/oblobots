// snap fasteners [UNIONS] v.03
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

// BOTONES AUTOMÁTICOS
// representa el volumen del botn que se debe eliminar de la pieza donde pegara dando calor con un soldador
module snap_fasteners (    model=PRYM_SNAP_FASTENERS_11,
                           type=PLUG                    // type=PLUG -> tipo macho de la conexion
                                                        // type=SOCKET -> tipo hembra de la conexión
                                                        // (Press Fastenner) Tipo de botón automático
                           ){										
    $fn=50;

    h=model[5];
    d=model[0];
    play=0.7;       // este ajuste hace una diferencia entre colocar el boton macho y el boton hembra. Puede variar segun el modelo

    if(type==0){
        translate([0,0,-0.1])
            cylinder (r=d/2,h=h);
        }
    else{
        if(type==1){
            translate([0,0,-0.1-play])
                cylinder (r=d/2,h=h);
            }
        }
}


// El rebaje para el botón se realiza sobre una base que se puede introducir manualmente en una pieza
module snap_fasteners_base (   model=PRYM_SNAP_FASTENERS_11,
                               type=PLUG,                   // type=PLUG -> tipo macho de la conexion
                                                            // type=SOCKET -> tipo hembra de la conexión
                               base=[15,4,8]
                               ){                     
                            
    $fn=50;                            

    difference(){
        // Dibuja la base
        union(){
            translate([0,0,-base[1]])pyramid_circumscribed(n=base[2],d2=base[0],d1=base[0]-1,h=1);
            translate([0,0,-base[1]+1])prism_circumscribed(n=base[2],d=base[0],h=base[1]-1);
            }
        // Resta el iman
        rotate([0,180,0])    
            snap_fasteners (model=model, type=type);
        }
}


// EJEMPLOS
i=20;
lado=20;

rotate([180,0,0])
fastener(   model=PRYM_SNAP_FASTENERS_11,
            type=PLUG);

difference(){
	translate([0,0,lado/2])
		cube([lado,lado,lado],center=true);
        snap_fasteners(model=PRYM_SNAP_FASTENERS_11, type=SOCKET);
        translate([0,0,lado])rotate([0,180,0])
            snap_fasteners(model=PRYM_SNAP_FASTENERS_11, type=SOCKET);
        translate([lado/2,0,lado/2])rotate([0,-90,0])
            snap_fasteners(model=PRYM_SNAP_FASTENERS_11, type=SOCKET);
        translate([0,lado/2,lado/2])rotate([90,90,0])
            snap_fasteners(model=PRYM_SNAP_FASTENERS_11, type=PLUG);
        translate([-lado/2,0,lado/2])rotate([0,90,0])
            snap_fasteners(model=PRYM_SNAP_FASTENERS_11, type=SOCKET);
        translate([0,-lado/2,lado/2])rotate([-90,90,0])
            snap_fasteners(model=PRYM_SNAP_FASTENERS_11, type=PLUG);
}

translate([0,i,0]){
    translate([2*i,0,0]){
        snap_fasteners_base (model=PRYM_SNAP_FASTENERS_11, type=SOCKET, base=[15,6,50]);
        fastener( model=PRYM_SNAP_FASTENERS_11,
           type=SOCKET);
    }
    
    translate([0,0,0]){
        snap_fasteners_base (model=PRYM_SNAP_FASTENERS_11, type=PLUG, base=[15,6,50]);
        fastener( model=PRYM_SNAP_FASTENERS_11,
           type=PLUG);
    }
}
