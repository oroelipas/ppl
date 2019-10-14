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

%start bien
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

//IGUAL HAY QUE TENER CUIDADO TAMBIEN CON LOS NOMBRES DE LOS TOKENS Y LA POLITICA DE NOMBRADO

// DOCUMENTACION EN: http://dinosaur.compilertools.net/bison/


Declaraciones de Bison:
    Los simbolos terminales van en mayuscula y se llaman tokens

Todos los nombres de tokens (pero no los tokens de carácter literal simple tal como ‘+’ y ‘*’) se deben declarar
    
    
%token <val> NUM         /* define token (terminal) NUM and its type 
//De forma alternativa, puede utilizar %left, %right, o %nonassoc en lugar de %token, si desea especificar la precedencia. 
%type <str> nonterminal   /*define NON terminal symbol, porque usamos %type


Reglas gramaticales
AQUI USAR SIEMPRE LA RECURSIVIDAD POR LA IZQUIERDA PARA NO GASTAR MEMORIA DE PILA:


Para hacer debugging:
https://starbeamrainbowlabs.com/blog/article.php?article=posts/267-Compilers-101.html : 
gcc -Wall -Wextra -g parser.tab.c main.c -lfl -ly -DYYDEBUG -D_XOPEN_SOURCE=700
 */
