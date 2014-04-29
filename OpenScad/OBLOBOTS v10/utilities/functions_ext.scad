// Funciones sacadas de otras librerías y de diferentes autores

include <constants_oblomobka.scad>

/* A circular helix of radius a and pitch 2πb is described by the following parametrisation:
x(t) = a*cos(t),
y(t) = a*sin(t),
z(t) = b*t
Licensed under the MIT license.
© 2010 by Elmo Mäntynen
*/
function b(pitch) = pitch/(TAU);
function t(pitch, z) = z/b(pitch);
function helix_curve(pitch, radius, z) = [radius*cos(deg(t(pitch, z))), radius*sin(deg(t(pitch, z))), z];


/* Utility functions.
 * Originally by Hans Häggström, 2010.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */
function distance(a, b) = sqrt( (a[0] - b[0])*(a[0] - b[0]) +
                                (a[1] - b[1])*(a[1] - b[1]) +
                                (a[2] - b[2])*(a[2] - b[2]) );

function length2(a) = sqrt( a[0]*a[0] + a[1]*a[1] );

function normalized(a) = a / (max(distance([0,0,0], a), 0.00001));

function normalized_axis(a) = 	a == "x" ? [1, 0, 0]:
                  			 	a == "y" ? [0, 1, 0]:
                   				a == "z" ? [0, 0, 1]: normalized(a);

function angleOfNormalizedVector(n) = [0, -atan2(n[2], length2([n[0], n[1]])), atan2(n[1], n[0]) ];

function angle(v) = angleOfNormalizedVector(normalized(v));

function angleBetweenTwoPoints(a, b) = angle(normalized(b-a));

