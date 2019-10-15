%{
#include <stdio.h>
extern int yylex();
extern int yylineno;
extern int yyparse();
void yyerror(const char *s);
%}


%union{
  char *str;
  char caracter;
  double doble;
  int entero;
}

%start bien

%token TK_PARENTESIS_INICIAL
%token TK_PARENTESIS_FINAL
%token <str> TK_OP_RELACIONAL
%token TK_IGUAL
%token <caracter> TK_OP_ARITMETICO
%token TK_ASIGNACION
%token TK_PUNTOYCOMA
%token TK_SEPARADOR
%token TK_SUBRANGO
%token TK_TIPO_VAR
%token TK_ENTONCES
%token TK_SINOSI
%token TK_INICIO_ARRAY
%token TK_FIN_ARRAY

%token TK_PR_ACCION
%token TK_PR_ALGORITMO
%token TK_PR_BOOLEANO
%token TK_PR_CADENA
%token TK_PR_CARACTER
%token TK_PR_CONST
%token TK_PR_CONTINUAR
%token TK_PR_DE
%token TK_PR_DEV
%token TK_PR_DIV
%token TK_PR_ENT
%token TK_PR_ENTERO
%token TK_PR_ES
%token TK_PR_FACCOIN
%token TK_PR_FALGORITMO
%token TK_PR_FCONST
%token TK_PR_FFUNCION
%token TK_PR_FMIENTRAS
%token TK_PR_FPARA
%token TK_PR_FSI
%token TK_PR_FTIPO
%token TK_PR_FTUPLA
%token TK_PR_FUNCION
%token TK_PR_FVAR
%token TK_PR_HACER
%token TK_PR_HASTA
%token TK_PR_MIENTRAS
%token TK_PR_MOD
%token TK_PR_NO
%token TK_PR_O
%token TK_PR_PARA
%token TK_PR_REAL
%token TK_PR_REF
%token TK_PR_SAL
%token TK_PR_SI
%token TK_PR_TABLA
%token TK_PR_TIPO
%token TK_PR_TUPLA
%token TK_PR_VAR
%token TK_PR_Y
%token <str> TK_CADENA
%token <caracter> TK_CARACTER
%token <str> TK_IDENTIFICADOR
%token <doble> TK_ENTERO
%token <doble> TK_REAL

%token <entero> TK_BOOLEANO





%%

bien : TK_ENTERO TK_OP_RELACIONAL TK_ENTERO {printf("%f %s %f\n", $1, $2, $3);}
	|  TK_ENTERO TK_OP_ARITMETICO TK_ENTERO {printf("%f %c %f\n", $1, $2, $3);}
	|  TK_IDENTIFICADOR {printf("ID, %s", $1);}

%%


int main() {
  yyparse();

}

void yyerror(const char *s) {
	printf("Error en lina %i: %s",yylineno, s);
}










/*
PONER SIEMPRE UNA RUTINA SEMANTICA PORQUE POR DEFECTO SE EJECUTA {$$=$1} Y ESO DARA PROBLEMAS CON EL YYLVAL. SI NO QUEREMOS NADA PONER {}.



//IGUAL HAY QUE TENER CUIDADO TAMBIEN CON LOS NOMBRES DE LOS TOKENS Y LA POLITICA DE NOMBRADO

// DOCUMENTACION EN: http://dinosaur.compilertools.net/bison/


Declaraciones de Bison:
    Los simbolos terminales van en mayuscula y se llaman tokens

Todos los nombres de tokens (pero no los tokens de carácter literal simple tal como ‘+’ y ‘*’) se deben declarar


%token TK_<val> NUM         /* define token (terminal) NUM and its type
//De forma alternativa, puede utilizar %left, %right, o %nonassoc en lugar de %token, si desea especificar la precedencia.
%type <str> nonterminal   /*define NON terminal symbol, porque usamos %type


Reglas gramaticales
AQUI USAR SIEMPRE LA RECURSIVIDAD POR LA IZQUIERDA PARA NO GASTAR MEMORIA DE PILA:


Para hacer debugging:
https://starbeamrainbowlabs.com/blog/article.php?article=posts/267-Compilers-101.html :
gcc -Wall -Wextra -g parser.tab.c main.c -lfl -ly -DYYDEBUG -D_XOPEN_SOURCE=700
 */
