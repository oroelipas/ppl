algoritmo paraArray;
ent n, m: entero;
{Prec: n= N AND m = M AND M >= N >0}
tipo
    tipoarray1 = tabla[n..m] de entero;
ftipo;
var 
    i: entero;
    array1 : tipoarray1;
fvar;

para i:=n hasta m hacer
	array1[i]:=i;
fpara;

{Post: n =N AND suma = SUMATORIO(i=1..N)(M sobre i)}
falgoritmo;
