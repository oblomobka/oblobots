// shaft [UNIONS] v.02
// (c) Jorge Medal (@oblomobka)  2015.09
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


// HUECO PARA UNIONES EN PIEZAS SUELTAS
// Prisma para sustraer de una forma.
// Se sebe colocar donde se vaya que colocar la union
module shaft_base (	    base=[15,4,50],		// Medidas generales de la union [diámetro de la base, altura de la base, n lados base]
                        play=[0.5,0.2]	    // [juego del diámetro, juego de altura]
						){

    d=base[0];
    h=base[1];
    n=base[2];                           
    d_play=play[0];			
    h_play=play[1];			

    translate([0,0,-0.1])
        prism_circumscribed(n=n,d=d+d_play,h=h+0.1+h_play);
    }



// Crea un agujero para introducir todo tipo de tubos comunes como uniones(espigas de madera, muelles, tubos de pecera, lápices, ...)
module shaft_dowel (    dowel=[6,30],   // [diametro, longitud]
                        deep=0.5,       // entre 0 - 1 || parte de la longitud que se aplicará sobre la pieza
                        play=0          // juego entre piezas, define lo apretado u holgado que entra la union
                ){
                    
    l=dowel[1];            
    d=dowel[0]+0.25+play;       

    translate([0,0,-0.1])
        union(){
            pyramid_circumscribed (d1=d+2,d2=d,h=1,n=6);
            translate([0,0,0.9])
                prism_circumscribed (d=d,h=l*lim(0,deep,1)+0.5,n=6);
            }	
    }
    
module shaft (  shaft=[6,30],   // [diametro, longitud]
                play=0          // juego entre piezas, define lo apretado u holgado que entra la union
                ){
                    
    l=shaft[1];            
    d=shaft[0]+0.25+play;       

    translate([0,0,-0.1])
        union(){
            pyramid_circumscribed (d1=d+2,d2=d,h=1,n=6);
            translate([0,0,0.9])
                prism_circumscribed (d=d,h=l+0.5,n=6);
            }	
    }


// EJEMPLOS
i=30;

translate([0,0,0]){
    translate([0,0,0])
        shaft (shaft=[15,10], play=0);

    translate([i,0,0])
        shaft_base (base=[20,2,8], play=[0.5,0.2] );

    translate([2*i,0,0])
        difference(){
            translate([0,0,20/2])
                cube([20,20,20],center=true);
            translate([0,0,20])
                rotate([0,180,0])
                    shaft_base (base=[10,10,8], play=[0.5,0.2]);
            }

    translate([3*i,0,0])
        shaft_base (base=[12,5,7], play=[0.5,0.2]);
}


translate([0,i,0]){
    rotate([0,180,0])
    difference(){
        cylinder(r=15,h=20);
                shaft_dowel (dowel=[8,30],deep=0.5,play=0);
    }
    
  }
