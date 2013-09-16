///////////////////////////////////////////////////////////////////////////////////////////////
// arm [OBLOBOTS] 
// 
// v.04
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Sep 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

use <plus/union.scad>
use <plus/parts.scad>

////////////////////////////////////////////////////////////////////////
/////////////////// MODULO armQ()  ////////////////////////////////

module armQ (	arm=[10,15,70],	// [ grosor(x), fondo(y), longitud(z) ] Medidas de los Brazo
				an=8				// [4,6,8,10,12] nº de lados del polígono de la mano
				){


ax=arm[0];	// medida del brazo: grosor
ay=arm[1];	// medida del brazo: fondo
az=arm[2];	// medida del brazo: longitud

hand=3*ay/2;
wrist=2*(hand/2)*tan(180/max(6,min(2*floor(an/2),12)));
az1=az-(ay/2)-hand-(wrist/2);

translate([0,0,1])
union(){
difference(){
hull(){
	translate([0,0,ax/2])
		cube([ay,ay,ax],center=true);

	translate([az1,0,3*ax/4])
		cube([wrist,wrist,ax/2],center=true);
	}
translate([0,0,3*ax/4])
	prism_C (n=min(2*floor(an/2),12),d=9,h=ax);
}
translate([0,0,-1])

prism_C (n=min(2*floor(an/2),12),d=10,h=ax/2);
	



difference(){
	translate([(az-hand/2-ay/2),0,ax/3])
		pyramid_C (n=min(2*floor(an/2),12),d1=hand,d2=hand,h=ax/1.5);

	translate([(az-hand/2-ay/2),0,ax/4])
		pyramid_C (n=min(2*floor(an/2),12),d1=hand/2,d2=hand/2,h=ax);

	translate([(az-hand/2-ay/2),-hand/6,0])
		cube([az,hand/3,2*ax]);
	}
}

}

// -------------- Fin del módulo armQ() ----------------------------------
// ------------------------------------------------------------------------------


armQ(arm=[10,15,70],an=6);
