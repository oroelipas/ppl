%{
#include <stdio.h>
#include <stdlib.h> //para hacer exit()
#include "defines.h"
#include <string.h>
#include "tablaSimbolos.h"
#include "tablaCuadruplas.h"
#include "listaIndicesQuad.h"
#include <stdarg.h>//esto es para poder usar va_list y va_start() para tener funciones con nº de arg indefinidos: yyerror

extern int yycolumn;
extern int yylex();
extern char* yytext;
//extern int yylineno; ya no se usa desde que usamos YY_USER_ACTION para calcular linea y columna

void yyerror(const char *s, ...);
FILE *fSaR;//fichero out.ShiftAndReduces
FILE *fTS; //fichero out.TablaSimbolos
FILE *fTC;//fichero out.TablaCuadruplas
lista_ligada *tablaSimbolos; //tabla de simbolos. igual habria que cambiar el nombre
t_tabla_quad *tablaCuadriplas;
char* programName;
int hayErrores;




%}


%union{
  char *str;
  char caracter;
  double doble;
  int entero;
 lista_ligada* tablaSimbolos;  //de momento las listas de id son listas_ligadas
  struct infoExpr{
    int type;   //entero, real, ...(tipos basicos o definidos)
    int place;  //index del simbolo de la tabla de simbolos 
  } info;
}
%locations 
%start ty_desc_algoritmo

%token TK_PARENTESIS_INICIAL
%token TK_PARENTESIS_FINAL
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
%token <str>TK_PR_BOOLEANO
%token <str>TK_PR_CADENA
%token <str>TK_PR_CARACTER
%token TK_PR_CONST
%token TK_PR_CONTINUAR
%token TK_PR_DE
%token TK_PR_DEV
%token TK_PR_ENT
%token <str>TK_PR_ENTERO
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
%token <str>TK_PR_REAL
%token TK_PR_SAL
%token TK_PR_SI
%token TK_PR_TABLA
%token TK_PR_TIPO
%token TK_PR_TUPLA
%token TK_PR_VAR
%token TK_COMENT_PREC
%token TK_COMENT_POST
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
%nonassoc TK_IGUAL
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
%type <entero> ty_d_tipo
%type <info> ty_expresion_t
%type <str> ty_lista_campos
%type <entero> ty_tipo_base
%type <str> ty_lista_d_cte
%type <str> ty_lista_d_var
%type <tablaSimbolos> ty_lista_id
%type <str> ty_decl_ent_sal
%type <str> ty_decl_ent
%type <str> ty_decl_sal
%type <info> ty_expresion
%type <info> ty_exp_a
%type <str> ty_exp_b
%type <info> ty_operando
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
    TK_PR_ALGORITMO TK_IDENTIFICADOR TK_PUNTOYCOMA ty_cabecera_alg ty_bloque_alg TK_PR_FALGORITMO {fprintf(fSaR,"REDUCE ty_desc_algoritmo: TK_PR_ALGORITMO TK_IDENTIFICADOR TK_PUNTOYCOMA ty_cabecera_alg ty_bloque_alg TK_PR_FALGORITMO\n");}
    ;

ty_cabecera_alg:
    ty_decl_globales ty_decl_a_f ty_decl_ent_sal TK_COMENT_PREC {fprintf(fSaR,"REDUCE ty_cabecera_alg: ty_decl_globales ty_decl_a_f ty_decl_ent_sal TK_COMENT_PREC\n");}
    ;

ty_bloque_alg:
    ty_bloque TK_COMENT_POST {fprintf(fSaR,"REDUCE ty_bloque_alg: ty_bloque TK_COMENT_POST\n");}
    ;

ty_decl_globales:
      ty_decl_tipo  ty_decl_globales {fprintf(fSaR,"REDUCE ty_decl_globales: ty_decl_tipo  ty_decl_globales\n");}
    | ty_decl_cte ty_decl_globales {fprintf(fSaR,"REDUCE ty_decl_globales: ty_decl_cte ty_decl_globales\n");}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_decl_globales: vacio\n");}
    ;

ty_decl_a_f:
      ty_accion_d  ty_decl_a_f {fprintf(fSaR,"REDUCE ty_decl_a_f: ty_accion_d  ty_decl_a_f\n");}
    | ty_funcion_d ty_decl_a_f {fprintf(fSaR,"REDUCE ty_decl_a_f: ty_funcion_d ty_decl_a_f \n");}
    | /*vacio*/ {fprintf(fSaR,"REDUCE ty_decl_a_f: vacio\n");}
    ;

ty_bloque:
    ty_declaraciones ty_instrucciones {fprintf(fSaR,"REDUCE ty_bloque: ty_declaraciones ty_instrucciones\n");}
    ;

ty_declaraciones:
      ty_decl_tipo ty_declaraciones {fprintf(fSaR,"REDUCE ty_declaraciones: ty_decl_tipo ty_declaraciones\n");}
    | ty_decl_cte  ty_declaraciones {fprintf(fSaR,"REDUCE ty_declaraciones: ty_decl_cte  ty_declaraciones \n");}
    | ty_decl_var  ty_declaraciones {fprintf(fSaR,"REDUCE ty_declaraciones: ty_decl_var  ty_declaraciones\n");}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_declaraciones: vacio\n");}
    ;

ty_decl_tipo:
    TK_PR_TIPO ty_lista_d_tipo TK_PR_FTIPO TK_PUNTOYCOMA {fprintf(fSaR,"REDUCE ty_decl_tipo: TK_PR_TIPO ty_lista_d_tipo TK_PR_FTIPO TK_PUNTOYCOMA\n");}
    ;

ty_decl_cte:
    TK_PR_CONST ty_lista_d_cte TK_PR_FCONST TK_PUNTOYCOMA {fprintf(fSaR,"REDUCE ty_decl_cte: TK_PR_CONST ty_lista_d_cte TK_PR_FCONST TK_PUNTOYCOMA\n");}
    ;

ty_decl_var:
    TK_PR_VAR ty_lista_d_var TK_PR_FVAR TK_PUNTOYCOMA {fprintf(fSaR,"REDUCE ty_decl_var: TK_PR_VAR ty_lista_d_var TK_PR_FVAR TK_PUNTOYCOMA\n");}//los programas de fitxi no tienen ;
    ;

ty_lista_d_tipo:
      TK_IDENTIFICADOR TK_IGUAL ty_d_tipo TK_PUNTOYCOMA ty_lista_d_tipo {fprintf(fSaR,"REDUCE ty_lista_d_tipo: TK_IDENTIFICADOR TK_IGUAL ty_d_tipo TK_PUNTOYCOMA ty_lista_d_tipo\n");}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_lista_d_tipo: vacio\n");}
    ;

ty_d_tipo:
      TK_PR_TUPLA ty_lista_campos TK_PR_FTUPLA {fprintf(fSaR,"REDUCE ty_d_tipo: TK_PR_TUPLA ty_lista_campos TK_PR_FTUPLA\n");}
    | TK_PR_TABLA TK_INICIO_ARRAY ty_expresion_t TK_SUBRANGO ty_expresion_t TK_FIN_ARRAY TK_PR_DE ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_tipo: TK_PR_TABLA TK_INICIO_ARRAY ty_expresion_t TK_SUBRANGO ty_expresion_t TK_FIN_ARRAY TK_PR_DE ty_d_tipo\n");}
    | TK_IDENTIFICADOR {fprintf(fSaR,"REDUCE ty_d_tipo: TK_IDENTIFICADOR\n");}
    | ty_expresion_t TK_SUBRANGO ty_expresion_t {fprintf(fSaR,"REDUCE ty_d_tipo: ty_expresion_t TK_SUBRANGO ty_expresion_t\n");}
    | TK_PR_REF ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_tipo: TK_PR_REF ty_d_tipo\n");}
    | ty_tipo_base {$$=$1;fprintf(fSaR,"REDUCE ty_d_tipo: ty_tipo_base\n");}
    ;

ty_expresion_t:
      ty_expresion {
        $$.place = $1.place;
        $$.type = $1.type;
        fprintf(fSaR,"REDUCE ty_expresion_t: ty_expresion\n");
    }
    | TK_CARACTER{fprintf(fSaR,"REDUCE ty_expresion_t: TK_CARACTER\n");}
    /*AQUI NO HAY CADENAS?????? ENTONCES NO SE PUEDE HACER a:= "hola"   */
    ;

ty_lista_campos:
    TK_IDENTIFICADOR TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_campos {fprintf(fSaR,"REDUCE ty_lista_campos: TK_IDENTIFICADOR TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_campos\n");}
    |/*vacio*/{{fprintf(fSaR,"REDUCE ty_lista_campos: vacio\n");}}
    ;

ty_tipo_base:
    /*BOOLEANO NO ESTABA ORIGINALMENTE EN LA DOCUMENTACION*/
    // ES NECESARIO RELLENAR $$ PARA DESPUES VER QUE TIPO ES ty_tipo_base CUANDO SE ASIGNEN TIPOS
     TK_PR_BOOLEANO {$$=BOOLEANO; fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_BOOLEANO\n");}
    |TK_PR_ENTERO   {$$=ENTERO;   fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_ENTERO\n");}
    |TK_PR_CARACTER {$$=CARACTER; fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_CARACTER\n");}
    |TK_PR_REAL     {$$=REAL;     fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_REAL\n");}
    |TK_PR_CADENA   {$$=CADENA;   fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_CADENA\n");}
    ;

ty_lista_d_cte:/*En el enunciado pone "literal" pero se referira a ty_tipo_base*/
    //las cte solo pueden ser de tipobase???????????????????????????????
    TK_IDENTIFICADOR TK_IGUAL ty_tipo_base TK_PUNTOYCOMA ty_lista_d_cte{fprintf(fSaR,"REDUCE ty_lista_d_cte: TK_IDENTIFICADOR TK_IGUAL ty_tipo_base TK_PUNTOYCOMA ty_lista_d_cte\n");}
    |/*vacio*/{fprintf(fSaR,"REDUCE ty_lista_d_cte: vacio\n");}
    ;

ty_lista_d_var:
    ty_lista_id TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_d_var {
            //Primero chequear si el tipo esta en la tabla de simbolos
            simbolo* simboloTipo = getSimboloPorId(tablaSimbolos, $3);
            if(simboloTipo != NULL){
                if(simboloEsUnTipo(simboloTipo)){// si el tipo existe
                    //marcar que el tipo ha sido usado
                    marcarComoUsado(simboloTipo);
                    simbolo* idsimbolo;
                    while((idsimbolo = pop($1))){//para cada id de la lista ty_lista_id
                        //creamos un info_simbolo que apunta a un infoVar. infoVar contendra el tipo de la variable ($3)
                        //info_simbolo idInfo = crearInfoVariable($3);
                        //addInfosimbolo (idsimbolo, idInfo);
                        //insertsimbolo(lista, idsimbolo);//lo metemos en la Tabla de simbolos

                        insertarVariable(tablaSimbolos, getNombreSimbolo(idsimbolo), getIdSimbolo(simboloTipo));

                        //Escribimos tipo y nombre de la variable en el fichero tablaSimbolos.txt
                        fprintf(fTS,"Insertada Variable %i '%s' en tabla de simbolos\n", $3, getNombreSimbolo(idsimbolo));
                    }
                }else{
                    yyerror("%s no es un tipo. Es otra cosa", $3);
                }
            }else{
                //el tipo no existe
                yyerror("El tipo %s no existe", $3);
            }
    	}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_lista_d_var: vacio\n");}
    ;

ty_lista_id:
    TK_IDENTIFICADOR TK_SEPARADOR ty_lista_id {
  				fprintf(fSaR,"REDUCE ty_lista_id: TK_IDENTIFICADOR TK_SEPARADOR ty_lista_id\n");
                //introducimos el nuevo identificador a la lista de identificadores
                //simbolo* var = crearsimbolo($1, VARIABLE);
                //TODO: no pueden aparecer 2 veces la misma variable
                //PERO si en entrada y en salida
                insertarVariable($3, $1, SIM_SIN_TIPO);//es un buen nombre??????
                $$ = $3;

			}

    | TK_IDENTIFICADOR {
				fprintf(fSaR,"REDUCE ty_lista_id: TK_IDENTIFICADOR\n");
                //creamos una lista con un solo simbolo cuyo nombre es el id
				//simbolo* var = crearsimbolo($1, VARIABLE);
                $$ = crearListaLigada();
                insertarVariable($$, $1, SIM_SIN_TIPO);
			}
    ;

ty_decl_ent_sal:
      ty_decl_ent {fprintf(fSaR,"REDUCE ty_decl_ent_sal: ty_decl_ent\n");}
    | ty_decl_ent ty_decl_sal {fprintf(fSaR,"REDUCE ty_decl_ent_sal: ty_decl_ent ty_decl_sal\n");}
    | ty_decl_sal {fprintf(fSaR,"REDUCE ty_decl_ent_sal: ty_decl_sal\n");}
    ;

ty_decl_ent:
    TK_PR_ENT ty_lista_d_var {fprintf(fSaR,"REDUCE ty_decl_ent: TK_PR_ENT ty_lista_d_var\n");}
    ;

ty_decl_sal:
    TK_PR_SAL ty_lista_d_var {fprintf(fSaR,"REDUCE ty_decl_sal: TK_PR_SAL ty_lista_d_var\n");}
    ;

ty_exp_a:
//ESTUDIAR SI SERIA MEJOR JUNTAR LAS OPERACIONES ARITMETICAS TODAS EN UNA PRODUCCION
      ty_exp_a TK_MAS ty_exp_a {
        simbolo* T = newTemp(tablaSimbolos);//new temp crea un simbolo y nos devuelve su id
        $$.place = getIdSimbolo(T);
        if($1.type == $3.type == ENTERO){
            modificaTipoVar(T, ENTERO);
            $$.type = ENTERO;
            gen(tablaCuadriplas, SUMA_INT, $1.place,  $3.place,  $$.place);
        }else if($1.type == $3.type == REAL){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadriplas, SUMA_REAL,  $1.place,  $3.place,  $$.place);
        }else if($1.type == REAL && $3.type == ENTERO){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadriplas, INT_TO_REAL, $3.place, -1,  $$.place);
            gen(tablaCuadriplas, SUMA_REAL,  $$.place,  $1.place,  $$.place);
        }else if($1.type == ENTERO && $3.type == REAL){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadriplas, INT_TO_REAL, $1.place, -1,  $$.place);
            gen(tablaCuadriplas, SUMA_REAL,  $$.place,  $3.place,  $$.place);
        }
        fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MAS ty_exp_a\n");
    }
    | ty_exp_a TK_MENOS ty_exp_a {fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MENOS ty_exp_a\n");}
    | ty_exp_a TK_MULT ty_exp_a {fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MULT ty_exp_a\n");}
    | ty_exp_a TK_DIV ty_exp_a {fprintf(fSaR,"REDUCE ty_exp_a:  ty_exp_a TK_DIV ty_exp_a \n");}
    | ty_exp_a TK_MOD ty_exp_a {fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MOD ty_exp_a\n");}
    | ty_exp_a TK_DIV_ENT ty_exp_a {fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_DIV_ENT ty_exp_a\n");}
    | TK_PARENTESIS_INICIAL ty_exp_a TK_PARENTESIS_FINAL {fprintf(fSaR,"REDUCE ty_exp_a: TK_PARENTESIS_INICIAL ty_exp_a TK_PARENTESIS_FINAL\n");}
    | ty_operando {
        $$.place = $1.place;
        $$.type = $1.type;
        fprintf(fSaR,"REDUCE ty_exp_a: ty_operando\n");
    }
    | TK_ENTERO {fprintf(fSaR,"REDUCE ty_exp_a: TK_ENTERO\n");}
    | TK_REAL {fprintf(fSaR,"REDUCE ty_exp_a: TK_REAL\n");}
    | TK_MENOS ty_exp_a %prec TK_MENOS_U {fprintf(fSaR,"REDUCE ty_exp_a: TK_MENOS ty_exp_a\n");}
    ;

/*
ESTO ES PARA ELIMINAR LOS S/R
(TAMBIEN MOLARIA QUE MAS, MENOS, MULT, DIV.... ESTUVIESEN JUNTOS COMO ESTOS)
NO SABEMOS LA FORMA DE QUE AL HACER ESTO ty_op_relacional TAMBIEN SEA NONASOC
ty_op_relacional:
      TK_OP_RELACIONAL {}
    | TK_IGUAL {}
    ;
*/
    
ty_exp_b:
      ty_exp_b TK_PR_Y ty_exp_b {fprintf(fSaR,"REDUCE ty_exp_b: ty_exp_b TK_PR_Y ty_exp_b\n");}/*AQUI IGUAL SE PUEDEN DEFINIR OP_LOGICO: CUYOS VALORES SEAN Y,O*/
    | ty_exp_b TK_PR_O ty_exp_b {fprintf(fSaR,"REDUCE ty_exp_b: ty_exp_b TK_PR_O ty_exp_b\n");}
    | TK_PR_NO ty_exp_b /*%prec TK_MUY_PRIORITARIO ESTO NO NOS ESTA QUITANDO R/R*/{fprintf(fSaR,"REDUCE ty_exp_b: TK_PR_NO ty_exp_b\n");}
    | TK_BOOLEANO {fprintf(fSaR,"REDUCE ty_exp_b: TK_BOOLEANO\n");}
    | ty_expresion TK_OP_RELACIONAL ty_expresion {fprintf(fSaR,"REDUCE ty_exp_b: ty_expresion TK_OP_RELACIONAL ty_expresion\n");}
    | ty_expresion TK_IGUAL ty_expresion {fprintf(fSaR,"REDUCE ty_exp_b: ty_expresion TK_IGUAL ty_expresion\n");}
    | TK_PARENTESIS_INICIAL ty_exp_b TK_PARENTESIS_FINAL {fprintf(fSaR,"REDUCE ty_exp_b: TK_PARENTESIS_INICIAL ty_exp_b TK_PARENTESIS_FINAL\n");}
    ;

ty_expresion:
      ty_exp_a {
        fprintf(fSaR,"REDUCE ty_expresion: ty_exp_a\n");
        $$.place = $1.place;
        $$.type = $1.type;
    }
    | ty_exp_b %prec TK_NADA_PRIORITARIO{fprintf(fSaR,"REDUCE ty_expresion: ty_exp_b\n");} /*ESTO NO TIENE QUE FUNCIONAR ASI!!!!!*/
    | ty_funcion_ll {fprintf(fSaR,"REDUCE ty_expresion: ty_funcion_ll\n");}
    ;


ty_operando:
    /*AQUI EN EL CONFLICTO SUPONGO QUE HABRA QUE HACER UN SHIFT POR PURA ASOCIATIVIDAD, PARA REDUCIR LA PILA.
    ADEMAS ES EL MODO DE ACCEDER A LAS VARIABLES: SI TIENES variable1.variable2[variable3] PRIMERO HABRA QUE IR DE FUERA HACIA ADENTRO Y REDUCIR variable1.variable2 A UNA SOLA VARIABLE (variable12) PARA LUEGO ACCEDER A ESA VARIABLE variable12[variable3]*/
    TK_IDENTIFICADOR {
        simbolo* var = getSimboloPorNombre(tablaSimbolos, $1);
        if(var == NULL){
            yyerror("variable %s usada pero no delarada", $1);
        }else{
            if(simboloEsUnaVariable(var)){
                marcarComoUsado(var);
                $$.place = getIdSimbolo(var);
                $$.type = getTipoVar(var);
            }else{
                yyerror("%s no es una variable", $1);
            }
        }
        fprintf(fSaR,"REDUCE ty_operando: TK_IDENTIFICADOR\n");
      }
    | ty_operando TK_PUNTO ty_operando {fprintf(fSaR,"REDUCE ty_operando: ty_operando TK_PUNTO ty_operando\n");}
    | ty_operando TK_INICIO_ARRAY ty_expresion TK_FIN_ARRAY {fprintf(fSaR,"REDUCE ty_operando: ty_operando TK_INICIO_ARRAY ty_expresion TK_FIN_ARRAY\n");}
    | ty_operando TK_PR_REF {fprintf(fSaR,"REDUCE ty_operando: ty_operando TK_PR_REF\n");}
    ;

ty_instrucciones:
      ty_instruccion TK_PUNTOYCOMA ty_instrucciones {fprintf(fSaR,"REDUCE ty_instrucciones: ty_instruccion TK_PUNTOYCOMA ty_instrucciones\n");}
    | ty_instruccion {fprintf(fSaR,"REDUCE ty_instrucciones: ty_instruccion\n");}
    ;//la ultima instruccion no lleva PUNTOYCOMA 


ty_instruccion:
      TK_PR_CONTINUAR {fprintf(fSaR,"REDUCE ty_instruccion: TK_PR_CONTINUAR\n");}
    | ty_asignacion {fprintf(fSaR,"REDUCE ty_instruccion: ty_asignacion\n");}
    | ty_alternativa {fprintf(fSaR,"REDUCE ty_instruccion: ty_alternativa\n");}
    | ty_iteracion {fprintf(fSaR,"REDUCE ty_instruccion: ty_iteracion\n");}
    | ty_accion_ll {fprintf(fSaR,"REDUCE ty_instruccion: ty_accion_ll\n");}
    ;

ty_asignacion:
    /*Hemos puesto ty_expresion_t en veZ de ty_expresion para poder hacer a = 'a'*/
     ty_operando TK_ASIGNACION ty_expresion_t {
        if($1.type == $3.type){
            gen(tablaCuadriplas, ASIGNACION, $3.place, -1, $1.place);
        }
        fprintf(fSaR,"REDUCE ty_asignacion:ty_operando TK_ASIGNACION ty_expresion_t\n");
    }
    |ty_operando TK_ASIGNACION TK_CADENA {fprintf(fSaR,"REDUCE ty_asignacion:ty_operando TK_ASIGNACION TK_CADENA\n");}
    ;

ty_alternativa:
    TK_PR_SI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones TK_PR_FSI {fprintf(fSaR,"REDUCE ty_alternativa: TK_PR_SI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones TK_PR_FSI\n");}
    ;

ty_lista_opciones:
     TK_SINOSI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones {fprintf(fSaR,"REDUCE TK_SINOSI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones\n");}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_lista_opciones: vacio\n");}
    ;

ty_iteracion:
      ty_it_cota_fija {fprintf(fSaR,"REDUCE ty_iteracion: ty_it_cota_fija\n");}
    | ty_it_cota_exp {fprintf(fSaR,"REDUCE ty_iteracion: ty_it_cota_exp\n");}
    ;

ty_it_cota_exp:
    TK_PR_MIENTRAS ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FMIENTRAS {fprintf(fSaR,"REDUCE ty_it_cota_exp:  TK_PR_MIENTRAS ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FMIENTRAS\n");}
    ;

ty_it_cota_fija:
    TK_PR_PARA TK_IDENTIFICADOR TK_ASIGNACION ty_expresion TK_PR_HASTA ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FPARA {fprintf(fSaR,"REDUCE ty_it_cota_fija: TK_PR_PARA TK_IDENTIFICADOR TK_ASIGNACION ty_expresion TK_PR_HASTA ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FPARA\n");}
    ;

ty_accion_d:
    TK_PR_ACCION ty_a_cabecera ty_bloque TK_PR_FACCION {fprintf(fSaR,"REDUCE ty_accion_d: TK_PR_ACCION ty_a_cabecera ty_bloque TK_PR_FACCION\n");}
    ;

ty_funcion_d:
    TK_PR_FUNCION ty_f_cabecera ty_bloque TK_PR_DEV ty_expresion TK_PR_FFUNCION {fprintf(fSaR,"REDUCE ty_funcion_d: TK_PR_FUNCION ty_f_cabecera ty_bloque TK_PR_DEV ty_expresion TK_PR_FFUNCION\n");}
    ;

ty_a_cabecera:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_d_par_form TK_PARENTESIS_FINAL TK_PUNTOYCOMA {fprintf(fSaR,"REDUCE ty_a_cabecera: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_d_par_form TK_PARENTESIS_FINAL TK_PUNTOYCOMA\n");}
    ;

 ty_f_cabecera:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_lista_d_var TK_PARENTESIS_FINAL TK_PR_DEV ty_d_tipo TK_PUNTOYCOMA {fprintf(fSaR,"REDUCE ty_f_cabecera: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_lista_d_var TK_PARENTESIS_FINAL TK_PR_DEV ty_d_tipo TK_PUNTOYCOMA\n");}
    ;

ty_d_par_form:
    ty_d_p_form TK_PUNTOYCOMA ty_d_par_form {fprintf(fSaR,"REDUCE ty_d_par_form: ty_d_p_form TK_PUNTOYCOMA ty_d_par_form\n");}
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_d_par_form: vacio\n");}
    ;

ty_d_p_form:
      TK_PR_ENT ty_lista_id TK_TIPO_VAR ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_p_form: TK_PR_ENT ty_lista_id TK_TIPO_VAR ty_d_tipo\n");}
    | TK_PR_SAL ty_lista_id TK_TIPO_VAR ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_p_form: TK_PR_SAL ty_lista_id TK_TIPO_VAR ty_d_tipo\n");}
    | TK_PR_ES  ty_lista_id TK_TIPO_VAR ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_p_form: TK_PR_ES  ty_lista_id TK_TIPO_VAR ty_d_tip\n");}
    ;

ty_accion_ll:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL {fprintf(fSaR,"REDUCE ty_accion_ll: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL\n");}
    ;

ty_funcion_ll:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL {fprintf(fSaR,"REDUCE ty_funcion_ll: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL\n");}
    ;

ty_l_ll:
      ty_expresion TK_SEPARADOR ty_l_ll {fprintf(fSaR,"REDUCE ty_l_ll: ty_expresion TK_SEPARADOR ty_l_ll\n");}
    | ty_expresion {fprintf(fSaR,"REDUCE ty_l_ll: ty_expresion\n");}
    ;


%%

int main (int argc, char *argv[]) {
    //checkear numero de parametros
    if(argc != 2){
        printf("Uso del compilador: ./a.out <NombreDelPprogama>\n");
        exit(1);
    }
    programName = argv[1];
    //redirigir el archivo del programa a la entrada estandar
    FILE *fPrograma = freopen(programName, "r", stdin);
    if(fPrograma == 0){
        printf("algoritmo %s no encontrado\n", argv[1]);
        exit(1);
    }
    
    //Abrir el fichero con con SHIFT y los REDUCE
    fSaR = fopen("out.ShiftsAndReduces", "w");
    if (fSaR == NULL){
        printf("Error abriendo out.ShiftsAndReduces\n");
        exit(1);
    }
    //Abrir el fichero con con la tabla de simbolos
    fTS = fopen("out.TablaSimbolos", "w");
    if (fTS == NULL){
        printf("Error abriendo out.TablaSimbolos\n");
        exit(1);
    }
    //Abrir el fichero con con la tabla de cuadruplas
    fTC = fopen("out.TablaCuadruplas", "w");
    if (fTS == NULL){
        printf("Error abriendo out.TablaCuadruplas\n");
        exit(1);
    }

	tablaSimbolos = crearTablaDeSimbolos();
    tablaCuadriplas =  crearTablaQuad();

	yyparse();

    printTablaQuad(tablaCuadriplas);
	printSimbolosNoUsados(tablaSimbolos);
    escribirTablaCuadruplas(tablaSimbolos, tablaCuadriplas, fTC);

    if(hayErrores){
	   printf("Revise out.ShiftsAndReduces\n");
	}
    fclose(fTS);
    fclose(fTC);
    fclose(fSaR);

}

/**
 * funcion yyerror de http://web.iitd.ac.in/~sumeet/flex__bison.pdf  pag.220
 * puede ser llamada como se llama a la funcion printf (nº indeterminado de argumentos)
 * errorText es la string con los %s y %i...
 * 
 */
void yyerror(const char *errorText, ...) {
    va_list args;  
    va_start(args, errorText);
    
    printf("%s:%d:%d: "RED, programName, yylloc.first_line, yylloc.first_column);  
    vprintf(errorText, args);
    printf(RESET"\n    Antes de '%s'\n", yytext);
    hayErrores = 1;
}




/*

DOCUMENTACION EN: http://dinosaur.compilertools.net/bison/
                  http://web.iitd.ac.in/~sumeet/flex__bison.pdf

 */
