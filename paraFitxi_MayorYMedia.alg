algoritmo MayorYMedia;
ent a, b, c, tres: entero; 
sal max: entero; media: real;
{Prec: a = A AND b = B AND c = C}

si a >= b y a >= c ->
    max := a;
[] b >= a y b >= c ->
    max := b;
[] c >= b y c >= a ->
    max := c;
fsi;

media := (a + b + c) / tres;

{Post: a=A AND b = B AND c= C ...}
falgoritmo;
