algoritmo unMientras;
ent n, m, acero, valor1, valor2, uno: entero;
sal suma: entero;
{Prec: n= N AND m = M AND M >= N >0}

var 
    i, comb: entero;
fvar;

i:= acero;
suma:= acero;
comb:= m;
mientras i <n hacer
    suma := suma + comb;
    comb := comb * (m - i - valor1) div (i + valor2);
    i := i+uno;
fmientras;
{Post: n =N AND suma = SUMATORIO(i=1..N)(M sobre i)}
falgoritmo;
