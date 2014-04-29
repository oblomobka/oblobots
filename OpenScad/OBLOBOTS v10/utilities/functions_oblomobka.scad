// Functions
// (C) @oblomobka - 2014
// GPL3

include <constants_oblomobka.scad>

// da el diámetro interior del cono(d1,d2,h) a una altura interior(hi) conocida
function di_cone(d1,d2,h,hi)=d2+(d1-d2)*(1-hi/h);

// da la altura interior del cono(d1,d2,h) a un diametro(di) conocido
function hi_cone(d1,d2,h,di)=-h*((di-d2)/(d1-d2)-1);

// 
function r_circle_intersection (d1,d2)=sqrt(pow(d1/2,2)-pow(d2/2,2));

// Relaciones entre radio, apotema y lado en un polígono de n lados
function side_apothem (apothem,n)=apothem*2*tan(180/n);
function apothem_radius(radius,n)=radius*cos(180/n);
function radius_apothem(apothem,n)=apothem/cos(180/n);
function side_radius (radius,n)=radius*2*sin(180/n);

// limita los posibles valores de x, que siempre estarán comprendidos entre un minimo(a) y un maximo(z)
function lim(a,x,z)=max(a,min(x,z));

// transforma angulo, radianes --> hexadecimal
function deg(angle) = 180*angle/PI;
// transforma angulo, hexadecimal --> radianes
function rad(angle) = angle*PI/180;

