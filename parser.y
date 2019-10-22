%{
#include <stdio.h>
extern int yylex();
extern int yylineno;
//extern int yyparse();
void yyerror(const char *s);
%}


%union{
  char *str;
  char caracter;
  double doble;
  int entero;
}

%start ty_desc_algoritmo

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
%token TK_PUNTO
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
%token TK_COMENTARIO
%token <str> TK_CADENA
%token <caracter> TK_CARACTER
%token <str> TK_IDENTIFICADOR
%token <doble> TK_ENTERO
%token <doble> TK_REAL
%token <entero> TK_BOOLEANO


%type <str> ty_cabecera_alg
%type <str> ty_bloque_alg
%type <str> ty_decl_globales
%type <str> ty_decl_a_f
%type <str> ty_bloque
%type <str> ty_declaraciones
%type <str> ty_decl_ent_sal
%type <str> ty_decl_tipo
%type <str> ty_decl_const
%type <str> ty_accion_d
%type <str> ty_funcion_d
%type <str> ty_lista_d_tipo
%type <str> ty_lista_d_cte
%type <str> ty_lista_d_var
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>
%type <str>




%%

ty_desc_algoritmo:
    TK_PR_ALGORITMO TK_IDENTIFICADOR TK_PUNTOYCOMA ty_cabecera_alg ty_bloque_alg TK_PR_FALGORITMO {printf("");}
    ;

ty_cabecera_alg:
    ty_decl_globales ty_decl_a_f ty_decl_ent_sal TK_COMENTARIO {printf("");}
    ;

ty_bloque_alg:
    ty_bloque TK_COMENTARIO {printf("");}
    ;

ty_decl_globales:
    ty_decl_tipo  ty_decl_globales {printf("");}
    | ty_decl_const ty_decl_globales {printf("");}
    | /*vacio*/{printf("");}
    ;


ty_decl_a_f:
    ty_accion_d  ty_decl_a_f {printf("");}
    |ty_funcion_d ty_decl_a_f {printf("");}
    |/*vacio*/ {printf("");}
    ;

ty_bloque:
    ty_declaraciones ty_instrucciones {printf("");}
    ;

ty_declaraciones:
    ty_decl_tipo  ty_declaraciones {printf("");}
    |ty_decl_const ty_declaraciones {printf("");}
    |ty_decl_var   ty_declaraciones {printf("");}
    |/*vacio*/{printf("");}
    ;

ty_decl_tipo:
    TK_PR_TIPO ty_lista_d_tipo TK_PR_FTIPO TK_PUNTOYCOMA {printf("");}
    ;
ty_decl_cte:
    TK_PR_CONST ty_lista_d_cte TK_PR_FCONST TK_PUNTOYCOMA{printf("");}
    ;
ty_decl_var:
    TK_PR_VAR ty_lista_d_var TK_PR_FVAR TK_PUNTOYCOMA{printf("");}
    ;
ty_lista_d_tipo:
    TK_IDENTIFICADOR TK_IGUAL ty_d_tipo TK_PUNTOYCOMA{printf("");}
    |/*vacio*/{printf("");}
    ;
ty_d_tipo:
    TK_PR_TUPLA ty_lista_campos TK_PR_FTUPLA {printf("");}
    |TK_PR_TABLA TK_INICIO_ARRAY ty_expresion_t TK_SUBRANGO ty_expresion_t TK_FIN_ARRAY TK_PR_DE ty_d_tipo {printf("");}
    |TK_IDENTIFICADOR {printf("");}
    |ty_expresion_t TK_SUBRANGO ty_expresion_t {printf("");}
    |TK_PR_REF ty_d_tipo {printf("");}
    |{printf("");}
    ;

ty_expresion_t:
    ty_expresion{printf("");}
    |TK_CARACTER{printf("");}
    ;

ty_lista_campos:
    TK_IDENTIFICADOR TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_campos{printf("");}
    |/*vacio*/{printf("");}
    ;
    
ty_tipo_base:
    TK_BOOLEANO {/*ESTO NOS LO HEMOS INVENTADO NOSOTROS*/}
    |TK_ENTERO {}
    |TK_CARACTER {}
    |TK_REAL {}
    |TK_CADENA {}
    ;
    
    
ty_lista_d_cte:/*esto de ty_tipo_base lo hemos cambiado por "literal"*/
    TK_IDENTIFICADOR TK_IGUAL ty_tipo_base TK_PUNTOYCOMA ty_lista_d_cte{}
    |/*vacio*/{}
    ;
ty_lista_d_var:
    ty_lista_id TK_TIPO_VAR TK_IDENTIFICADOR TK_PUNTOYCOMA ty_lista_d_var {}
    |ty_lista_id TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_d_var {}
    | /*vacio*/{}
    ;
ty_lista_id:
    TK_IDENTIFICADOR TK_SEPARADOR ty_lista_id {} 
    | TK_IDENTIFICADOR {}
    ;

ty_decl_ent_sal:
    ty_decl_ent {}
    |ty_decl_ent ty_decl_sal {}
    |ty_decl_sal {}
    ;
ty_decl_ent:
    TK_PR_ENT ty_lista_d_var {}
    ;
ty_decl_sal:
    TK_PR_SAL ty_lista_d_var {}
    ;
ty_expresion:
    ty_exp_a {}
    |ty_exp_b {}
    |ty_funcion_ll {}
    ;
ty_exp_a:
    ty_exp_a TK_OP_ARITMETICO ty_exp_a {}
    | TK_PARENTESIS_INICIAL ty_exp_a TK_PARENTESIS_FINAL {}
    | ty_operando {}
    | TK_ENTERO {}
    | TK_REAL {}
    | TK_OP_ARITMETICO ty_exp_a {/*SOLO TIENE QUE ENTRAR AQUI SI EL OP_ARIT ES UN MENOS*/}
    ;
    /*
    opcion: definir aparte el token menos en flex y hacer que bison tenga producciones para saber lo que es un op_arit
    y que el tk_menos deje de ser un operador aritmetico
ty_op_arit:
    TK_OP_ARITMETICO {}
    | TK_MENOS {}
    ;
    */
    
ty_exp_b:
      ty_exp_b TK_PR_Y ty_exp_b {}/*AQUI IGUAL SE PUEDEN DEFINIR OP_LOGICO: CUYOS VALORES SEAN Y,O*/
    | ty_exp_b TK_PR_O ty_exp_b {}
    | TK_PR_NO ty_exp_b {}
    | ty_operando {}
    | TK_BOOLEANO {}
    | ty_expresion TK_OP_RELACIONAL ty_expresion {}
    | TK_PARENTESIS_INICIAL ty_exp_b TK_PARENTESIS_FINAL {}
    ;

ty_operando:
      TK_IDENTIFICADOR {}
    | ty_operando TK_PUNTO ty_operando {}
    | ty_operando TK_INICIO_ARRAY ty_expresion TK_FIN_ARRAY {}
    | ty_operando TK_PR_REF {}
    ;
    
ty_instrucciones:
      ty_instruccion TK_PUNTOYCOMA ty_instrucciones {}
    | ty_instruccion {}
    ;
    
ty_instruccion:
      TK_PR_CONTINUAR {}
    | ty_asignacion {}
    | ty_alternativa {}
    | ty_iteracion {}
    | ty_accion_ll {}
    ;
    
ty_asignacion:
    ty_operando TK_PUNTOYCOMA ty_expresion {}
    ;
    
ty_alternativa:
    TK_PR_SI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones TK_PR_FSI {}
    ;
    
ty_lista_opciones:
     TK_SINOSI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones {}
    | /*vacio*/
    ;

ty_iteracion:
      ty_it_cota_fija {}
    | ty_it_cota_exp {}
    ;
    
ty_it_cota_exp:
    TK_PR_MIENTRAS ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FMIENTRAS {}
    ;

ty_it_cota_fija:
    TK_PR_PARA TK_IDENTIFICADOR TK_ASIGNACION ty_expresion TK_PR_HASTA ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FPARA {}
    ;
    
ty_accion_d:
    TK_PR_ACCION ty_a_cabecera ty_bloque TK_PR_ACCION {}
    ;

ty_funcion_d:
    TK_PR_FUNCION ty_f_cabecera ty_bloque TK_PR_DEV ty_expresion TK_PR_FFUNCION {}
    ;

ty_a_cabecera:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_d_par_form TK_PARENTESIS_FINAL TK_PUNTOYCOMA {}
    ;
 
 ty_f_cabecera:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_lista_d_var TK_PARENTESIS_FINAL TK_PR_DEV ty_d_tipo TK_PUNTOYCOMA {}
    ;
    
ty_d_par_form:
    ty_d_p_form TK_PUNTOYCOMA ty_d_par_form {}
    | /*vacio*/
    ;

ty_d_p_form:
      TK_PR_ENT ty_lista_id TK_TIPO_VAR ty_d_tipo {}
    | TK_PR_SAL ty_lista_id TK_TIPO_VAR ty_d_tipo {}
    | TK_PR_ES  ty_lista_id TK_TIPO_VAR ty_d_tipo {}
    ;

ty_accion_ll:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL {}
    ;
    
ty_funcion_ll:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL {}
    ;

ty_l_ll:
      ty_expresion TK_SEPARADOR ty_l_ll {}
    | ty_expresion {}
    ;

    
%%


int main() {
  yyparse();

}

void yyerror(const char *s) {
	printf("Error en lina %i: %s",yylineno, s);
}










/*

PORQUE LA PRODUCCION DE UN ALGORITMO TIENE UN PUNTO AL FINAL????????????????????????


PONER SIEMPRE UNA RUTINA SEMANTICA PORQUE POR DEFECTO SE EJECUTA {$$=$1} Y ESO DARA PROBLEMAS CON EL YYLVAL. SI NO QUEREMOS NADA PONER {printf("
");}.



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
