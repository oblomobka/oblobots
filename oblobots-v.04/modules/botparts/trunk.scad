//////////////////////////////////////////////////////////////////////////////////////////////
// body [OBLOBOTS] 
// 
// v.04
//////////////////////////////////////////////////////////////////////////////////////////////////
// (c) Jorge Medal (@oblomobka) - Sara Alvarellos (@trecedejunio) Sep 2013
//////////////////////////////////////////////////////////////////////////////////////////////////
// GPL license
//////////////////////////////////////////////////////////////////////////////////////////////////

use <plus/union.scad>
use <plus/parts.scad>


//////////////////////////////////////////////////////////////////
/////////////////// MODULO trunkQ  ////////////////////////////////

module trunkQ (	tr=[50,25,50],		// medida del cuerpo: ancho
				T=1					// Tipo de hombro:	1 -> 3 chaflanes
									//					2 -> 4 chaflanes
				)
				{

$fn=50;

trx=tr[0];
try=tr[1];
trz=tr[2];

sx=trx/10;
sy=try;
sz=max(24,trz/2);

// --------- Volumen ----------------

union(){
translate ([0,0,trz/2])
	cube (tr,center=true);

// hombros
translate([-trx/2,0,trz-sz])
	shoulder (S=T,sx=sx,sy=sy,sz=sz);

mirror([1,0,0])translate([-trx/2,0,trz-sz])
	shoulder (S=T,sx=sx,sy=sy,sz=sz);
	
}


// ----- Modulos auxiliares ------------

module shoulder(S=1,sx,sy,sz){

ang=45;		//[0:45]

// paralepipedo achflanado en 3 lados	
if(S==1){
	rotate([0,-90,0])translate ([sz/2,0,0])
	hull(){
		translate ([0,0,-0.05])
			cube([sz,sy,0.1],center=true);
		translate ([sx*cos(ang)/2,0,sx/2])
			cube([sz-sx*cos(ang),sy-2*sx*cos(ang),sx],center=true);
		}
	}

// paralepipedo achflanado en 4 lados
	else{
		if(S==2){
			rotate([0,-90,0])translate ([sz/2,0,0])
			hull(){
				translate ([0,0,-0.05])
					cube([sz,sy,0.1],center=true);
				translate ([0,0,sx/2])
					cube([sz-2*sx*cos(ang),sy-2*sx*cos(ang),sx],center=true);
			}
		}	
}
}

// ----- Fin de los módulos auxiliares ------------

}

// -------------- Fin del módulo trunkQ() ----------------------------------
// ------------------------------------------------------------------------



trunkQ(T=1);
