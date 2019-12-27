algoritmo intercambio;
    ent a, b: entero;
    sal a, b: entero;
    
    {Prec: a= A AND b = B}
    
    var
        aux, c: entero;
    fvar;

    aux:= a;
    a:= b;
    b:= aux;
    c:= a + (b div b);
    {Post: b=A AND a = B}
    
falgoritmo;
