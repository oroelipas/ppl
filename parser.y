%{
#include <stdio.h>
extern int yylex();
extern int yylineno;
extern int yyparse();
void yyerror(const char *s);
%}


%union{
  char *str;
  double val;            
}

%token <val> ENTERO
%token <val> FLOAT
%token <str> IDENTIFICADOR
%token <str> OP_ARITMETICO
%token <str> OP_RELACIONAL



%%

bien : ENTERO OP_RELACIONAL ENTERO {printf("%f %s %f\n", $1, $2, $3);}
	|  ENTERO OP_ARITMETICO ENTERO {printf("%f %s %f\n", $1, $2, $3);}
	|  IDENTIFICADOR {printf("ID, %s", $1);}

%%


int main() {
  yyparse();
  
}

void yyerror(const char *s) {
	printf("Error en lina %i: %s",yylineno, s);
}










/*


// DOCUMENTACION EN: http://dinosaur.compilertools.net/bison/


Declaraciones de Bison:
    Los simbolos terminales van en mayuscula y se llaman tokens

Todos los nombres de tokens (pero no los tokens de carácter literal simple tal como ‘+’ y ‘*’) se deben declarar
    
    
%token <val> NUM         /* define token (terminal) NUM and its type 
//De forma alternativa, puede utilizar %left, %right, o %nonassoc en lugar de %token, si desea especificar la precedencia. 
%type <str> nonterminal   /*define NON terminal symbol, porque usamos %type


Reglas gramaticales
AQUI USAR SIEMPRE LA RECURSIVIDAD POR LA IZQUIERDA PARA NO GASTAR MEMORIA DE PILA:


DEL PDF DE FITXI:   
El parser debe informar en otro fichero de cu ́ales
son los tokens a los que hace shift y cu ́ales son las reducciones que se producen. 
En otro fichero debe escribir informacion que permita reconstruir la tabla de sımbolos que se ha creado durante la compilación.En un tercer fichero debe escribir la tabla de cuadruplas que se genera.
 */
