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
%token TK_IGUAL
%token TK_ASIGNACION
%token TK_PUNTOYCOMA
%token TK_SEPARADOR
%token TK_SUBRANGO
%token TK_TIPO_VAR
%token TK_ENTONCES
%token TK_SINOSI
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
%token TK_PR_ENT
%token TK_PR_ENTERO
%token TK_PR_ES
%token TK_PR_FACCION
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
%token TK_PR_PARA
%token TK_PR_REAL
%token TK_PR_SAL
%token TK_PR_SI
%token TK_PR_TABLA
%token TK_PR_TIPO
%token TK_PR_TUPLA
%token TK_PR_VAR
%token TK_COMENTARIO
/* TK_CADENA DE MOMENTO EN LA GRAMATICA NO SE USA*/
%token <str> TK_CADENA
%token <caracter> TK_CARACTER
%token <str> TK_IDENTIFICADOR
%token <doble> TK_ENTERO
%token <doble> TK_REAL
%token <entero> TK_BOOLEANO


%precedence TK_NADA_PRIORITARIO
/*no todos los TK_OP_RELACIONAL pueden usarse para boolenaos, solo = y <>.  PERO NO <,>,=>,=<*/
%left TK_PR_O
%left TK_PR_Y
/*%nonassoc para no permitir 3<4<5*/
%nonassoc <str> TK_OP_RELACIONAL
%nonassoc TK_PR_NO
%left TK_MAS TK_MENOS
%left TK_MULT TK_DIV TK_DIV_ENT TK_MOD
%left TK_MENOS_U
/*TK_INICIO_ARRAY es left para cuando estamos en un estado a[b].[c] para que se reduzca a[b] y no siga leyendo [c]*/
%left TK_INICIO_ARRAY
%left TK_PUNTO
%left TK_PR_REF
%precedence TK_MUY_PRIORITARIO


%type <str> ty_desc_algoritmo
%type <str> ty_cabecera_alg
%type <str> ty_bloque_alg
%type <str> ty_decl_globales
%type <str> ty_decl_a_f
%type <str> ty_bloque
%type <str> ty_declaraciones
%type <str> ty_decl_tipo
%type <str> ty_decl_cte
%type <str> ty_decl_var
%type <str> ty_lista_d_tipo
%type <str> ty_d_tipo
%type <str> ty_expresion_t
%type <str> ty_lista_campos
%type <str> ty_tipo_base
%type <str> ty_lista_d_cte
%type <str> ty_lista_d_var
%type <str> ty_lista_id
%type <str> ty_decl_ent_sal
%type <str> ty_decl_ent
%type <str> ty_decl_sal
%type <str> ty_expresion
%type <str> ty_exp_a
%type <str> ty_exp_b
%type <str> ty_operando
%type <str> ty_instrucciones
%type <str> ty_instruccion
%type <str> ty_asignacion
%type <str> ty_alternativa
%type <str> ty_lista_opciones
%type <str> ty_iteracion
%type <str> ty_it_cota_exp
%type <str> ty_it_cota_fija
%type <str> ty_accion_d
%type <str> ty_funcion_d
%type <str> ty_a_cabecera
%type <str> ty_f_cabecera
%type <str> ty_d_par_form
%type <str> ty_d_p_form
%type <str> ty_accion_ll
%type <str> ty_funcion_ll
%type <str> ty_l_ll


%%

ty_desc_algoritmo:
/* aqui en la gramatica de fitxi hay un punto despues de falgoritmo que hemos quitado porque en los ejemplos no esta*/
    TK_PR_ALGORITMO TK_IDENTIFICADOR TK_PUNTOYCOMA ty_cabecera_alg ty_bloque_alg TK_PR_FALGORITMO {printf("REDUCE\n");}
    ;

ty_cabecera_alg:
    ty_decl_globales ty_decl_a_f ty_decl_ent_sal TK_COMENTARIO {printf("REDUCE ty_cabecera_alg: ty_decl_globales ty_decl_a_f ty_decl_ent_sal TK_COMENTARIO\n");}
    ;

ty_bloque_alg:
    ty_bloque TK_COMENTARIO {printf("REDUCE\n");}
    ;

ty_decl_globales:
      ty_decl_tipo  ty_decl_globales {printf("REDUCE\n");}
    | ty_decl_cte ty_decl_globales {printf("REDUCE\n");}
    | /*vacio*/{printf("REDUCE\n");}
    ;

ty_decl_a_f:
      ty_accion_d  ty_decl_a_f {printf("REDUCE\n");}
    | ty_funcion_d ty_decl_a_f {printf("REDUCE\n");}
    | /*vacio*/ {printf("REDUCE\n");}
    ;

ty_bloque:
    ty_declaraciones ty_instrucciones {printf("REDUCE\n");}
    ;

ty_declaraciones:
      ty_decl_tipo  ty_declaraciones {printf("REDUCE\n");}
    | ty_decl_cte ty_declaraciones {printf("REDUCE\n");}
    | ty_decl_var   ty_declaraciones {printf("REDUCE\n");}
    | /*vacio*/{printf("REDUCE\n");}
    ;

ty_decl_tipo:
    TK_PR_TIPO ty_lista_d_tipo TK_PR_FTIPO TK_PUNTOYCOMA {printf("REDUCE\n");}
    ;

ty_decl_cte:
    TK_PR_CONST ty_lista_d_cte TK_PR_FCONST TK_PUNTOYCOMA{printf("REDUCE\n");}
    ;

ty_decl_var:
    TK_PR_VAR ty_lista_d_var TK_PR_FVAR TK_PUNTOYCOMA{printf("REDUCE\n");}//los programas de fitxi no tienen ;
    ;

ty_lista_d_tipo:
      TK_IDENTIFICADOR TK_IGUAL ty_d_tipo TK_PUNTOYCOMA ty_lista_d_tipo {printf("REDUCE\n");}
    | /*vacio*/{printf("REDUCE\n");}
    ;

ty_d_tipo:
      TK_PR_TUPLA ty_lista_campos TK_PR_FTUPLA {printf("REDUCE\n");}
    | TK_PR_TABLA TK_INICIO_ARRAY ty_expresion_t TK_SUBRANGO ty_expresion_t TK_FIN_ARRAY TK_PR_DE ty_d_tipo {printf("REDUCE\n");}
    | TK_IDENTIFICADOR {printf("REDUCE\n");}
    | ty_expresion_t TK_SUBRANGO ty_expresion_t {printf("REDUCE\n");}
    | TK_PR_REF ty_d_tipo {printf("REDUCE\n");}
    | ty_tipo_base {printf("REDUCE\n");}
    ;

ty_expresion_t:
      ty_expresion {printf("REDUCE\n");}
    | TK_CARACTER{printf("REDUCE\n");}/*AQUI NO HAY CADENAS?????? ENTONCES NO SE PUEDE HACER a:= "hola"   */
    ;

ty_lista_campos:
    TK_IDENTIFICADOR TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_campos{printf("REDUCE\n");}
    |/*vacio*/{{printf("REDUCE\n");}}
    ;

ty_tipo_base:
    TK_PR_BOOLEANO {/*ESTO NOS LO HEMOS INVENTADO NOSOTROS*/}
    |TK_PR_ENTERO {printf("REDUCE\n");}
    |TK_PR_CARACTER {printf("REDUCE\n");}
    |TK_PR_REAL {printf("REDUCE\n");}
    |TK_PR_CADENA {printf("REDUCE\n");}
    ;

ty_lista_d_cte:/*En el enunciado pone "literal" pero se referira a ty_tipo_base*/
    TK_IDENTIFICADOR TK_IGUAL ty_tipo_base TK_PUNTOYCOMA ty_lista_d_cte{printf("REDUCE\n");}
    |/*vacio*/{printf("REDUCE\n");}
    ;

ty_lista_d_var:
      ty_lista_id TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_d_var {printf("REDUCE\n");}
    | /*vacio*/{printf("REDUCE\n");}
    ;

ty_lista_id:
      TK_IDENTIFICADOR TK_SEPARADOR ty_lista_id {printf("REDUCE\n");}
    | TK_IDENTIFICADOR {printf("REDUCE\n");}
    ;

ty_decl_ent_sal:
      ty_decl_ent {printf("REDUCE\n");}
    | ty_decl_ent ty_decl_sal {printf("REDUCE\n");}
    | ty_decl_sal {printf("REDUCE\n");}
    ;

ty_decl_ent:
    TK_PR_ENT ty_lista_d_var {printf("REDUCE\n");}
    ;

ty_decl_sal:
    TK_PR_SAL ty_lista_d_var {printf("REDUCE\n");}
    ;

ty_expresion:
      ty_exp_a {printf("REDUCE\n");}
    | ty_exp_b %prec TK_NADA_PRIORITARIO{printf("REDUCE\n");} /*ESTO NO TIENE QUE FUNCIONAR ASI!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
    | ty_funcion_ll {printf("REDUCE\n");}
    ;

ty_exp_a:
      ty_exp_a TK_MAS ty_exp_a {printf("REDUCE\n");}
    | ty_exp_a TK_MENOS ty_exp_a {printf("REDUCE\n");}
    | ty_exp_a TK_MULT ty_exp_a {printf("REDUCE\n");}
    | ty_exp_a TK_DIV ty_exp_a {printf("REDUCE\n");}
    | ty_exp_a TK_MOD ty_exp_a {printf("REDUCE\n");}
    | ty_exp_a TK_DIV_ENT ty_exp_a {printf("REDUCE\n");}
    | TK_PARENTESIS_INICIAL ty_exp_a TK_PARENTESIS_FINAL {printf("REDUCE\n");}
    | ty_operando {printf("REDUCE\n");}
    | TK_ENTERO {printf("REDUCE\n");}
    | TK_REAL {printf("REDUCE\n");}
    | TK_MENOS ty_exp_a %prec TK_MENOS_U {/*SOLO TIENE QUE ENTRAR AQUI SI EL OP_ARIT ES UN MENOS*/}
    ;

ty_exp_b:
      ty_exp_b TK_PR_Y ty_exp_b {printf("REDUCE\n");}/*AQUI IGUAL SE PUEDEN DEFINIR OP_LOGICO: CUYOS VALORES SEAN Y,O*/
    | ty_exp_b TK_PR_O ty_exp_b {printf("REDUCE\n");}
    | TK_PR_NO ty_exp_b %prec TK_MUY_PRIORITARIO{printf("REDUCE\n");}
    | TK_BOOLEANO {printf("REDUCE\n");}
    | ty_expresion TK_OP_RELACIONAL ty_expresion {printf("REDUCE\n");}
    | TK_PARENTESIS_INICIAL ty_exp_b TK_PARENTESIS_FINAL {printf("REDUCE\n");}
    ;


ty_operando:
    /*AQUI EN EL CONFLICTO SUPONGO QUE HABRA QUE HACER UN SHIFT POR PURA ASOCIATIVIDAD, PARA REDUCIR LA PILA.
    ADEMAS ES EL MODO DE ACCEDER A LAS VARIABLES: SI TIENES variable1.variable2[variable3] PRIMERO HABRA QUE IR DE FUERA HACIA ADENTRO Y REDUCIR variable1.variable2 A UNA SOLA VARIABLE (variable12) PARA LUEGO ACCEDER A ESA VARIABLE variable12[variable3]*/
      TK_IDENTIFICADOR {printf("REDUCE\n");}
    | ty_operando TK_PUNTO ty_operando {printf("REDUCE\n");}
    | ty_operando TK_INICIO_ARRAY ty_expresion TK_FIN_ARRAY {printf("REDUCE\n");}
    | ty_operando TK_PR_REF {printf("REDUCE\n");}
    ;

ty_instrucciones:
      ty_instruccion TK_PUNTOYCOMA ty_instrucciones {printf("REDUCE\n");}
    | ty_instruccion {printf("REDUCE\n");}
    ;

ty_instruccion:
      TK_PR_CONTINUAR {printf("REDUCE\n");}
    | ty_asignacion {printf("REDUCE\n");}
    | ty_alternativa {printf("REDUCE\n");}
    | ty_iteracion {printf("REDUCE\n");}
    | ty_accion_ll {printf("REDUCE\n");}
    ;

ty_asignacion:
    /*Hemos puesto ty_expresion_t en vex de ty_expresion para poder hacer a = 'a'*/
    /*AUN NO SE PUEDEN HACER ASIGNACIONES CON CADENAS a = "hola"     */
    ty_operando TK_ASIGNACION ty_expresion_t {printf("REDUCE\n");}
    ;

ty_alternativa:
    TK_PR_SI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones TK_PR_FSI {printf("REDUCE\n");}
    ;

ty_lista_opciones:
     TK_SINOSI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones {printf("REDUCE\n");}
    | /*vacio*/{printf("REDUCE\n");}
    ;

ty_iteracion:
      ty_it_cota_fija {printf("REDUCE\n");}
    | ty_it_cota_exp {printf("REDUCE\n");}
    ;

ty_it_cota_exp:
    TK_PR_MIENTRAS ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FMIENTRAS {printf("REDUCE\n");}
    ;

ty_it_cota_fija:
    TK_PR_PARA TK_IDENTIFICADOR TK_ASIGNACION ty_expresion TK_PR_HASTA ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FPARA {printf("REDUCE\n");}
    ;

ty_accion_d:
    TK_PR_ACCION ty_a_cabecera ty_bloque TK_PR_FACCION {printf("REDUCE\n");}
    ;

ty_funcion_d:
    TK_PR_FUNCION ty_f_cabecera ty_bloque TK_PR_DEV ty_expresion TK_PR_FFUNCION {printf("REDUCE\n");}
    ;

ty_a_cabecera:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_d_par_form TK_PARENTESIS_FINAL TK_PUNTOYCOMA {printf("REDUCE\n");}
    ;

 ty_f_cabecera:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_lista_d_var TK_PARENTESIS_FINAL TK_PR_DEV ty_d_tipo TK_PUNTOYCOMA {printf("REDUCE\n");}
    ;

ty_d_par_form:
    ty_d_p_form TK_PUNTOYCOMA ty_d_par_form {printf("REDUCE\n");}
    | /*vacio*/{printf("REDUCE\n");}
    ;

ty_d_p_form:
      TK_PR_ENT ty_lista_id TK_TIPO_VAR ty_d_tipo {printf("REDUCE\n");}
    | TK_PR_SAL ty_lista_id TK_TIPO_VAR ty_d_tipo {printf("REDUCE\n");}
    | TK_PR_ES  ty_lista_id TK_TIPO_VAR ty_d_tipo {printf("REDUCE\n");}
    ;

ty_accion_ll:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL {printf("REDUCE\n");}
    ;

ty_funcion_ll:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL {printf("REDUCE\n");}
    ;

ty_l_ll:
      ty_expresion TK_SEPARADOR ty_l_ll {printf("REDUCE\n");}
    | ty_expresion {printf("REDUCE\n");}
    ;


%%


int main() {
  yyparse();

}

void yyerror(const char *s) {
	printf("REDUCEError en lina %i: %s",yylineno, s);
}










/*

PARA LOS - UNITARIOS:
https://www.gnu.org/software/bison/manual/html_node/Contextual-Precedence.html

S
PORQUE LA PRODUCCION DE UN ALGORITMO TIENE UN PUNTO AL FINAL????????????????????????


PONER SIEMPRE UNA RUTINA SEMANTICA PORQUE POR DEFECTO SE EJECUTA {$$=$1} Y ESO DARA PROBLEMAS CON EL YYLVAL. SI NO QUEREMOS NADA PONER {printf("REDUCE
");}.



//IGUAL HAY QUE TENER CUIDADO TAMBIEN CON LOS NOMBRES DE LOS TOKENS Y LA POLITICA DE NOMBRADO

// DOCUMENTACION EN: http://dinosaur.compilertools.net/bison/


Reglas gramaticales
AQUI USAR SIEMPRE LA RECURSIVIDAD POR LA IZQUIERDA PARA NO GASTAR MEMORIA DE PILA:


Para hacer debugging:
https://starbeamrainbowlabs.com/blog/article.php?article=posts/267-Compilers-101.html :
gcc -Wall -Wextra -g parser.tab.c main.c -lfl -ly -DYYDEBUG -D_XOPEN_SOURCE=700
 */
