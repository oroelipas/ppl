algoritmo pruebaArrays;
ent n, m: entero;z : real;
sal suma: real;
{Prec: n= N AND m = M AND M >= N >0}
tipo
    tipoarray3 = tabla[m..m] de entero;
    tipoarray1 = tabla[m..n] de tabla[n..m] de entero;
ftipo;
var 
    a, b : entero;
    array1 : tipoarray1;
    array3 : tipoarray3;
fvar;
suma:=z;
a:=n;
array1[a][b]:=a;
array3[a]:=a;
b:=array3[m - b];
b:=array1[m - b][a + b];
{Post: n =N AND suma = SUMATORIO(i=1..N)(M sobre i)}
falgoritmo;
