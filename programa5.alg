algoritmo sumacomb;
ent i,n, m: entero;
sal suma: entero;
{Prec: n= N AND m = M AND M >= N >0}

para i:=n hasta m hacer
	suma := suma + i;
fpara;

{Post: n =N AND suma = SUMATORIO(i=1..N)(M sobre i)}
falgoritmo;
