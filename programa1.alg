algoritmo intercambio;
    ent a, b: entero;
    sal a, b: entero;
    
    {Prec: a= A AND b = B}
    
    var
        aux: entero;
    fvar;

    aux:= a;
    a:= b;
    b:= aux;
    c:= a+(b / 5)
    {Post: b=A AND a = B}
    
falgoritmo
