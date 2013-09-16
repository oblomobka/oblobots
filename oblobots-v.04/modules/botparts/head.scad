///////////////////////////////////////////////////////////////////////////////////////////////
// head [OBLOBOTS] 
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
/////////////////// MODULO headQ_hollow  ////////////////////////////////

module headQ_hollow (	hs=[38,38,38],	// Arista del cubo
					ht=2,			// grosor de la pared del cubo
					eh=5,			// lo que sobresale el ojo (para tipos 2 y 3)
					exp1=25,			// factor de expresión de los ojos (para tipo 2)
					exp2=2,			// factor de expresión de los ojos (para tipo 2)
					eb=0				// [0:100] factor de separación entre ojos. Mayor valor -> Mayor separación
					)
					{

hsx=hs[0];		// Arista X del cubo
hsy=hs[1];		// Arista Y del cubo
hsz=hs[2];		// Arista Z del cubo


$fn=50;
ledn=5;		// Diámetro nominal del led
hti=1.5;		// pared de la separación interior de las mitades de la cabeza

edled=ledn+2;								//Variable auxiliar, Hueco para meter el led
ed2=min(edled+2*eh+2,(hsx/2)-3);
eb2=max(0,min(eb,100))*((hsx/2-0.5)-ed2)/100;	// Variable auxiliar


// --------- Volumen ----------------
						
union(){
	difference(){				
		emptyhead();
		moveEyes()
			cylinder (r=edled/2,h=ht*2+0.1,center=true);
	}	

	moveEyes()			
		ledsocket_exp(ledn=ledn,h=min(eh,(hsx-12-edled)/4),exp1=exp1, exp2=exp2);			

	moveEars()
		blindcone(d=1.3*min(hsy,hsz)/2);
	
	translate([0,0,hsz/2])
		cube([hsx-2*ht,hsy-2*ht,hti],center=true);

		
	
}			
			
// ----- Modulos auxiliares ------------

module moveEars(){

	for(i=[1,-1]){
		translate ([i*(hsx/2-0.3),0,hsz/2])
			rotate ([0,i*90,0])
				child(0);				
	}
}

module moveEyes(){

for(i=[0,1]){
	mirror([i,0,0])
		translate ([((ed2/2)+eb2),-hsy/2,hsz/2])
			rotate ([90,0,0])
				child(0);				
	}
}


// ------ Formas auxiliares --------------
module emptyhead(sx=hsx,sy=hsy,sz=hsz,t=ht){

sxint=sx-2*t;		// Variables auxiliares
syint=sy-2*t;		// Variables auxiliares
szint=sz-2*t;		// Variables auxiliares
//hti=1.5;
h1=sz/2-t-hti/2;
h2=sz/2;

	difference(){
	translate([0,0,sz/2])
		cube([sx,sy,sz],center=true);
	translate([0,t,h1/2+t])
		cube([sxint,sy,h1],center=true);
	translate([0,0,3*sz/4+hti/2])
		cube([sxint,syint,sz/2],center=true);
	}
}
// ----- fin módulos auxiliares ------------

}


///////////////////////////////////////////////////////////////////////////
/////////////////// MODULO headQ  ////////////////////////////////

module headQ(	hs=[38,38,38],	// [x,y,z] Aristas del cubo
				ht=2,			// grosor de la pared del cubo
				E=1,				// Tipo de ojo:	1 -> hueco rebajado
								//				2 -> alojamiento para led 5mm
								//				3 -> cono ciego
				ed=8,			// Diámetro ojo (para tipos 1 y 3)
				eh=3,			// lo que sobresale el ojo (para tipos 2 y 3)
				exp1=25,			// factor de expresión de los ojos (para tipo 2)
				exp2=2,			// factor de expresión de los ojos (para tipo 2)
				eb=50			// [0:100] factor de separación entre ojos. Mayor valor -> Mayor separación
				)
				{

hsx=hs[0];		// Arista X del cubo
hsy=hs[1];		// Arista Y del cubo
hsz=hs[2];		// Arista Z del cubo

$fn=50;
ledn=5;		// Diámetro nominal del led

// estas variables limitan los valores posibles para el tamaño y posición de los ojos.
ed1=min(ed,(hsx/2)-3);						// Variable auxiliar. Impide que los ojos se salgan de la cara
eb1=max(3,min(eb,100))*((hsx/2-ht)-ed1)/100;	// Variable auxiliar

edled=ledn+2;								//Variable auxiliar, Hueco para meter el led
ed2=min(edled+2*eh+2,(hsx/2)-3);
eb2=max(0,min(eb,100))*((hsx/2-0.5)-ed2)/100;	// Variable auxiliar

vh=0.6;			// rebaje en la cara del cubo
vb=3;			// borde

// --------- Volumen ----------------
			
if(E==1){
	difference(){
		translate([0,0,hsz/2])
			cube([hsx,hsy,hsz],center=true);
			// -- Cuencas de los ojos				

		moveEyes()
		translate([0,0,-4+0.1])
			difference(){
				cylinder (r=ed1/2,h=4);
				rotate([0,0,exp1])
					translate([0,(2+(2*exp2/100))*ed1/4,2])
						cube([ed1,ed1,4],center=true);
				}
		velcro();				
	}
}
			
	else{
		if(E==2){
			union(){
				difference(){				
				emptyhead();
				moveEyes()
					cylinder (r=edled/2,h=ht*3,center=true);
				}

				moveEyes()			
					ledsocket_exp(ledn=ledn,h=min(eh,(hsx-12-edled)/4),exp1=exp1, exp2=exp2);			

				moveEars()
					blindcone(d=1.3*min(hsy,hsz)/2);

				translate([0,0,hsz/2])
					cube([hsx-2*ht,hsy-2*ht,1.5],center=true);			
				}
			}
		else{
			if(E==3){
				union(){
					translate([0,0,hs[2]/2])
					cube(hs,center=true);
					moveEyes()
						blindcone(d=ed);
					}
				}
	
			}
}

// ----- Modulos auxiliares ------------

module moveEars(){

	for(i=[1,-1]){
		translate ([i*hsx/2,0,hsz/2])
			rotate ([0,i*90,0])
				child(0);				
	}
}

module moveEyes(){

for(i=[0,1]){
	mirror([i,0,0])
		translate ([((ed2/2)+eb2),-hsy/2,hsz/2])
			rotate ([90,0,0])
				child(0);				
	}

}

module velcro(){

translate([0,0,hsz])
	translate([0,0,-vh/2+0.05])
		cube([hsx-2*vb,hsy-2*vb,vh],center=true);
translate([0,hsy/2,hsz/2])
	rotate([90,0,0])
		translate([0,0,vh/2-0.05])
			cube([hsx-2*vb,hsz-2*vb,vh],center=true);
translate([-hsx/2,0,hsz/2])
	rotate([0,-90,0])
		translate([0,0,-vh/2+0.05])
			cube([hsz-2*vb,hsy-2*vb,vh],center=true);
translate([hsx/2,0,hsz/2])
	rotate([0,90,0])
		translate([0,0,-vh/2+0.05])
			cube([hsz-2*vb,hsy-2*vb,vh],center=true);

}

// ------ Formas auxiliares --------------
module emptyhead(sx=hsx,sy=hsy,sz=hsz,t=ht){

sxint=sx-2*t;		// Variables auxiliares
syint=sy-2*t;		// Variables auxiliares
szint=sz-2*t;		// Variables auxiliares

	difference(){
	translate([0,0,sz/2])
		cube([sx,sy,sz],center=true);
	translate([0,0,szint/2+t])
		cube([sxint,syint,szint],center=true);
	}
}

// ----- fin módulos auxiliares ------------

}

// -------------- Fin del módulo headQ () -------------------------------
// ------------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////
/////////////////// Ejemplos de aplicación //////////////////////////////



hs=[30,30,30];	// Aristas del cubo

ht=2;			// grosor de la pared del cubo


E=1;			// Tipo de ojo:	1 -> hueco circular
			//				2 -> alojamiento para led 5mm
			//				3 -> cono ciego
			//				4 -> hueco rebajado


ed=15;		// Diámetro ojo (para tipos 1, 3, 4)
eh=5;		// lo que sobresale el ojo (para tipo 2)

exp1=45;		// factor de expresión de los ojos (para tipo 2)
exp2=35;		// factor de expresión de los ojos (para tipo 2)

eb=50;		// [0:100] factor de separación entre ojos. Mayor valor -> Mayor separación


headQ (hs=[30,30,30],ht=ht,E=1,ed=ed,eh=3,exp1=exp1,exp2=exp2,eb=10);

translate ([60,0,0])
headQ (hs=[40,20,26],ht=ht,E=3,ed=ed,eh=3,exp1=exp1,exp2=exp2,eb=10);

translate ([-60,0,0])
headQ_hollow (hs=[30,30,40],ht=ht,eh=eh,exp1=exp1,exp2=exp2,eb=eb);

