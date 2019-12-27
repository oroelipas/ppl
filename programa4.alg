algoritmo sumacomb;
ent n, m: entero;z : real;
sal suma: real;
{Prec: n= N AND m = M AND M >= N >0}
tipo
    tipoarray1 = tabla[n..m] de entero;
ftipo;
var 
    a, b : entero;
    comb : real;
    array1 : tipoarray1;
fvar;

a:=n;
array1[a]:=a;
comb:=z;
comb:=comb*(m*(a+m));
suma:= suma + comb;
b := array1[n];
suma := array1[m];
array1[m] := suma;
{Post: n =N AND suma = SUMATORIO(i=1..N)(M sobre i)}
falgoritmo;
