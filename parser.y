%{

/* Autores: Oroel Ipas y Carlos Moyano */

#include <stdio.h>
#include <stdlib.h> // esta librería es para poder usar exit()
#include "defines.h"
#include <string.h>
#include "tablaSimbolos.h"
#include "tablaCuadruplas.h"
#include "listaIndicesQuad.h"
#include <stdarg.h> // esta librería es para poder usar va_list y va_start() para tener funciones con nº de arg indefinidos: yyerror y warning

extern int yycolumn;
extern int yylex();
extern char* yytext;

void warning(const char *warningText, ...);
void yyerror(const char *s, ...);
FILE *fSaR; // fichero out.ShiftAndReduces
FILE *fTS;  // fichero out.TablaSimbolos
FILE *fTC;  // fichero out.TablaCuadruplas
lista_ligada *tablaSimbolos; // tabla de simbolos
t_lista_ligada_int *output;
t_tabla_quad *tablaCuadruplas;
char* programName;

%}

%union {
  	char *str;
  	char caracter;
  	double doble;
  	int entero;
 	lista_ligada* listaSimbolos;  // para las declaraciones de variables
 	t_lista_ligada_int* lista_int;
    simbolo *sim;
  	struct {
    	int type;   // entero, real, ...(tipos basicos o definidos)
    	int place;  // index del simbolo de la tabla de simbolos 
    	t_lista_ligada_int* True;   // entero, real, ...(tipos basicos o definidos)
    	t_lista_ligada_int* False;  // index del simbolo de la tabla de simbolos
    	t_lista_ligada_int* next;
  	} infoExp;
  	struct {
    	int type;   // entero, real, ...(tipos basicos o definidos)
    	int place;  // index del simbolo de la tabla de simbolos 
    	t_lista_ligada_int* True;   // entero, real, ...(tipos basicos o definidos)
    	t_lista_ligada_int* False;  // index del simbolo de la tabla de simbolos
    	t_lista_ligada_int* next;
    	int offset;
  	} infoExpOff;
  	struct {
    	int quad;
  	} infoM;
  	struct {
    	t_lista_ligada_int* next;
  	} infoIns;
    struct {
        t_lista_ligada_int* next;
        int idVar; // este campo guarda el id de la variable a la que acabamos de asignar un valor
    } infoAsig;
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
%token <str> TK_CADENA
%token <caracter> TK_CARACTER
%token <str> TK_IDENTIFICADOR
%token <doble> TK_ENTERO
%token <doble> TK_REAL
%token <entero> TK_BOOLEANO

%precedence TK_NADA_PRIORITARIO
%left TK_PR_O
%left TK_PR_Y
/* %nonassoc para no permitir 3<4<5 */
%nonassoc <entero> TK_IGUAL
%nonassoc <entero> TK_OP_RELACIONAL 
%nonassoc TK_PR_NO
%left TK_MAS TK_MENOS
%left TK_MULT TK_DIV TK_DIV_ENT TK_MOD
%left TK_MENOS_U
/* TK_INICIO_ARRAY es left para cuando estamos en un estado a[b].[c] se reduzca a[b] y no siga leyendo [c] */
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
%type <infoExpOff> ty_expresion_t
%type <str> ty_lista_campos
%type <entero> ty_tipo_base
%type <str> ty_lista_d_cte
%type <listaSimbolos> ty_lista_d_var
%type <listaSimbolos> ty_lista_id
%type <str> ty_decl_ent_sal
%type <str> ty_decl_ent
%type <str> ty_decl_sal
%type <infoExpOff> ty_expresion
%type <infoExpOff> ty_exp_a
%type <infoExp> ty_exp_b
%type <infoExpOff> ty_operando
%type <infoIns> ty_instrucciones
%type <infoIns> ty_instruccion
%type <infoAsig> ty_asignacion
%type <infoIns> ty_alternativa
%type <infoIns> ty_lista_opciones
%type <infoIns> ty_iteracion
%type <infoIns> ty_it_cota_exp
%type <infoIns> ty_it_cota_fija
%type <str> ty_accion_d
%type <str> ty_funcion_d
%type <str> ty_a_cabecera
%type <str> ty_f_cabecera
%type <str> ty_d_par_form
%type <str> ty_d_p_form
%type <str> ty_accion_ll
%type <str> ty_funcion_ll
%type <lista_int> ty_l_ll
%type <infoM> ty_M
%type <infoIns> ty_N
%type <entero> ty_op_relacional

%%

ty_desc_algoritmo:
    TK_PR_ALGORITMO TK_IDENTIFICADOR TK_PUNTOYCOMA ty_cabecera_alg ty_bloque_alg TK_PR_FALGORITMO TK_PUNTOYCOMA{
        fprintf(fSaR,"REDUCE ty_desc_algoritmo: TK_PR_ALGORITMO TK_IDENTIFICADOR TK_PUNTOYCOMA ty_cabecera_alg ty_bloque_alg TK_PR_FALGORITMO TK_PUNTOYCOMA\n");}
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
    TK_PR_VAR ty_lista_d_var TK_PR_FVAR TK_PUNTOYCOMA {
        simbolo *var;
        int idVar;
        // insertar en la tabla de simbolos las variables
        while((var = pop($2))){
            idVar = insertarSimbolo(tablaSimbolos, var);
            if(idVar == -1){
                // si ha habido una doble declaracion solo nos quedamos con la primera, omitimos el resto y damos un error
                yyerror("declaración múltiple de variable '%s'", getNombreSimbolo(var));
            }else{
                fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(var))), getNombreSimbolo(var));
            }
        }
        fprintf(fSaR,"REDUCE ty_decl_var: TK_PR_VAR ty_lista_d_var TK_PR_FVAR TK_PUNTOYCOMA\n");
    };

ty_lista_d_tipo:
      TK_IDENTIFICADOR TK_IGUAL ty_d_tipo TK_PUNTOYCOMA ty_lista_d_tipo {
      	// podemos obtener el id del tipo que acaba de insertarse con $3
      	// una vez que ya podemos acceder, le podemos agregar el nombre, que es $1
      	addNombreSimbolo(tablaSimbolos, $3, $1);
      	simbolo* aux = getSimboloPorNombre(tablaSimbolos, $1);
      	fprintf(fTS,"Insertado tipo de array '%s' contiene %s\n", getNombreSimbolo(aux), getNombreSimbolo(getSimboloPorId(tablaSimbolos, aux -> info.t2.info -> tipoContenido)));
      	fprintf(fSaR,"REDUCE ty_lista_d_tipo: TK_IDENTIFICADOR TK_IGUAL ty_d_tipo TK_PUNTOYCOMA ty_lista_d_tipo\n");
      }
    | /*vacio*/{fprintf(fSaR,"REDUCE ty_lista_d_tipo: vacio\n");}
    ;

ty_d_tipo:
      TK_PR_TUPLA ty_lista_campos TK_PR_FTUPLA {fprintf(fSaR,"REDUCE ty_d_tipo: TK_PR_TUPLA ty_lista_campos TK_PR_FTUPLA\n");}
    | TK_PR_TABLA TK_INICIO_ARRAY ty_expresion_t TK_SUBRANGO ty_expresion_t TK_FIN_ARRAY TK_PR_DE ty_d_tipo {
    	/* Declaración de un tipo de array */
    	if($3.type == ENTERO && $5.type == ENTERO){
    		// insertamos en la tabla de símbolos un tipo de array, que tiene una longitud determinada y almacena valores de un tipo determinado (lo tratamos como a un tipo)
    		int indiceQuadConLongitud = getNextquad(tablaCuadruplas);
    		simbolo* T = newTemp(tablaSimbolos); // newTemp() crea un simbolo y nos devuelve su id
            modificaTipoVar(T, ENTERO);
            fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(T))), getNombreSimbolo(T));
    		gen(tablaCuadruplas, RESTA_INT, $5.place, $3.place, T -> id);
    		infoTipo* info = crearInfoTipoDeTabla($8, indiceQuadConLongitud);
    		simbolo* tipoInsertado = insertarTipo(tablaSimbolos, info);
    		$$ = getIdSimbolo(tipoInsertado);
    	}else{
    		warning("los subrangos de las tablas deben ser enteros");
    	}
    	fprintf(fSaR,"REDUCE ty_d_tipo: TK_PR_TABLA TK_INICIO_ARRAY ty_expresion_t TK_SUBRANGO ty_expresion_t TK_FIN_ARRAY TK_PR_DE ty_d_tipo\n");
    }
    | TK_IDENTIFICADOR {
        simbolo* tipo = getSimboloPorNombre(tablaSimbolos, $1);
        if(tipo){
            if(simboloEsUnTipo(tipo)){
                $$ = getIdSimbolo(tipo);
            }else{
                yyerror("'%s' no es un tipo", $1);
                exit(-1);
            }
        }else{
            yyerror("tipo '%s' no declarado", $1);
            exit(-1);
        }
    	fprintf(fSaR,"REDUCE ty_d_tipo: TK_IDENTIFICADOR\n");
   	}
    | ty_expresion_t TK_SUBRANGO ty_expresion_t {fprintf(fSaR,"REDUCE ty_d_tipo: ty_expresion_t TK_SUBRANGO ty_expresion_t\n");}
    | TK_PR_REF ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_tipo: TK_PR_REF ty_d_tipo\n");}
    | ty_tipo_base {
    	$$ = $1;
    	fprintf(fSaR,"REDUCE ty_d_tipo: ty_tipo_base\n");
    }
    ;

ty_expresion_t:
      ty_expresion {
        $$.place = $1.place;
        $$.type = $1.type;
        $$.True = $1.True;
        $$.False = $1.False;
        $$.offset = $1.offset;
        fprintf(fSaR,"REDUCE ty_expresion_t: ty_expresion\n");
    }
    | TK_CARACTER{fprintf(fSaR,"REDUCE ty_expresion_t: TK_CARACTER\n");
    }
    ;

ty_lista_campos:
    TK_IDENTIFICADOR TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_campos {
        fprintf(fSaR,"REDUCE ty_lista_campos: TK_IDENTIFICADOR TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_campos\n");
    }
    | /*vacio*/ {fprintf(fSaR,"REDUCE ty_lista_campos: vacio\n");}
    ;

ty_tipo_base:
      TK_PR_BOOLEANO {$$=BOOLEANO; fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_BOOLEANO\n");}
    | TK_PR_ENTERO   {$$=ENTERO;   fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_ENTERO\n");}
    | TK_PR_CARACTER {$$=CARACTER; fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_CARACTER\n");}
    | TK_PR_REAL     {$$=REAL;     fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_REAL\n");}
    | TK_PR_CADENA   {$$=CADENA;   fprintf(fSaR,"REDUCE ty_tipo_base: TK_PR_CADENA\n");}
    ;

ty_lista_d_cte:
    TK_IDENTIFICADOR TK_IGUAL ty_tipo_base TK_PUNTOYCOMA ty_lista_d_cte {
        fprintf(fSaR,"REDUCE ty_lista_d_cte: TK_IDENTIFICADOR TK_IGUAL ty_tipo_base TK_PUNTOYCOMA ty_lista_d_cte\n");
    }
    |/*vacio*/{fprintf(fSaR,"REDUCE ty_lista_d_cte: vacio\n");}
    ;

ty_lista_d_var:
    ty_lista_id TK_TIPO_VAR ty_d_tipo TK_PUNTOYCOMA ty_lista_d_var {
        //marcar que el tipo ha sido usado
        marcarComoUsado(getSimboloPorId(tablaSimbolos, $3));
        simbolo* var;
        $$ = $5;
        while((var = pop($1))){
            // asignarle el tipo
            modificaTipoVar(var, $3);
            // insertarla en la lista de variables que estamos definiendo
            if(insertarSimbolo($$, var) == -1){
                yyerror("declaración múltiple de variable '%s'", getNombreSimbolo(var));
            }
        }
	}
    | /*vacio*/ {
        $$ = crearListaLigada();
        fprintf(fSaR,"REDUCE ty_lista_d_var: vacio\n");
    }
    ;

ty_lista_id:
    TK_IDENTIFICADOR TK_SEPARADOR ty_lista_id {
  		fprintf(fSaR,"REDUCE ty_lista_id: TK_IDENTIFICADOR TK_SEPARADOR ty_lista_id\n");
        // introducimos el nuevo identificador a la lista de identificadores
        if(insertarVariable($3, $1, SIM_SIN_TIPO) == NULL){
            warning("declaracion multiple de variable '%s'", $1);
        }
        $$ = $3;
	}
    | TK_IDENTIFICADOR {
		fprintf(fSaR,"REDUCE ty_lista_id: TK_IDENTIFICADOR\n");
        // creamos una lista con un solo simbolo cuyo nombre es el id
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
    TK_PR_ENT ty_lista_d_var {
        simbolo *var;
        int idVar;
        // insertar en la tabla de simbolos las variables
        while(var = pop($2)){
            idVar = insertarSimbolo(tablaSimbolos, var);
            if(idVar == -1){
                // si ha habido una doble declaracion solo nos quedamos con la primera, omitimos el resto y damos un error
                yyerror("declaración múltiple de variable '%s'", getNombreSimbolo(var));
            }else{
                insertarInputEnTablaCuadruplas(tablaCuadruplas, var);
                fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(var))), getNombreSimbolo(var));
            }
        }
        fprintf(fSaR,"REDUCE ty_decl_ent: TK_PR_ENT ty_lista_d_var\n");
    };

ty_decl_sal:
    TK_PR_SAL ty_lista_d_var {
        simbolo *var;
        int idVar;
        // insertar en la tabla de simbolos las variables
        while(var = pop($2)){
            idVar = insertarSimbolo(tablaSimbolos, var);
            if(idVar == -1){
                // si ya ha sido declarada comprobar que tenga el mismo tipo
                if(getTipoVar(var) != getTipoVar(getSimboloPorNombre(tablaSimbolos, getNombreSimbolo(var)))){
                    yyerror("declarando variable '%s' de salida con tipo diferente que de entrada", getNombreSimbolo(var));
                    // decision: omitimos la incoherencia, metemos la variable en la lista output y continuamos compilando
                }
            }else{
                fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(var))), getNombreSimbolo(var));
            }
            output = merge(output, makeList(getIdSimbolo(getSimboloPorNombre(tablaSimbolos, getNombreSimbolo(var)))));
        }
        fprintf(fSaR,"REDUCE ty_decl_sal: TK_PR_SAL ty_lista_d_var\n");
    };

ty_exp_a:
      ty_exp_a TK_MAS ty_exp_a {
        simbolo* T = newTemp(tablaSimbolos);
        $$.place = getIdSimbolo(T);
        if($1.type == ENTERO && $3.type == ENTERO){
            modificaTipoVar(T, ENTERO);
            $$.type = ENTERO;
            gen(tablaCuadruplas, SUMA_INT, $1.place,  $3.place,  $$.place);
        }else if($1.type == REAL && $3.type == REAL){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadruplas, SUMA_REAL,  $1.place,  $3.place,  $$.place);
        }else if($1.type == REAL && $3.type == ENTERO){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadruplas, INT_TO_REAL, $3.place, -1,  $$.place);
            gen(tablaCuadruplas, SUMA_REAL,  $$.place,  $1.place,  $$.place);
        }else if($1.type == ENTERO && $3.type == REAL){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadruplas, INT_TO_REAL, $1.place, -1,  $$.place);
            gen(tablaCuadruplas, SUMA_REAL,  $$.place,  $3.place,  $$.place);
        }
        $$.offset = OFFSET_NULO;
        fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(T))), getNombreSimbolo(T));
        fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MAS ty_exp_a\n");
    }
    | ty_exp_a TK_MENOS ty_exp_a {
        simbolo* T = newTemp(tablaSimbolos);
        $$.place = getIdSimbolo(T);
        if($1.type == ENTERO && $3.type == ENTERO){
            modificaTipoVar(T, ENTERO);
            $$.type = ENTERO;
            gen(tablaCuadruplas, RESTA_INT, $1.place,  $3.place,  $$.place);
        }else if($1.type == REAL && $3.type == REAL){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadruplas, RESTA_REAL,  $1.place,  $3.place,  $$.place);
        }else if($1.type == REAL && $3.type == ENTERO){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadruplas, INT_TO_REAL, $3.place, -1,  $$.place);
            gen(tablaCuadruplas, RESTA_REAL,  $$.place,  $1.place,  $$.place);
        }else if($1.type == ENTERO && $3.type == REAL){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadruplas, INT_TO_REAL, $1.place, -1,  $$.place);
            gen(tablaCuadruplas, RESTA_REAL,  $$.place,  $3.place,  $$.place);
        }
        $$.offset = OFFSET_NULO;
        fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(T))), getNombreSimbolo(T));
    	fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MENOS ty_exp_a\n");
    }
    | ty_exp_a TK_MULT ty_exp_a {
        simbolo* T = newTemp(tablaSimbolos);
        $$.place = getIdSimbolo(T);
        if($1.type == ENTERO && $3.type == ENTERO){
            modificaTipoVar(T, ENTERO);
            $$.type = ENTERO;
            gen(tablaCuadruplas, MULT_INT, $1.place,  $3.place,  $$.place);
        }else if($1.type == REAL && $3.type == REAL){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadruplas, MULT_REAL,  $1.place,  $3.place,  $$.place);
        }else if($1.type == REAL && $3.type == ENTERO){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadruplas, INT_TO_REAL, $3.place, -1,  $$.place);
            gen(tablaCuadruplas, MULT_REAL,  $$.place,  $1.place,  $$.place);
        }else if($1.type == ENTERO && $3.type == REAL){
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadruplas, INT_TO_REAL, $1.place, -1,  $$.place);
            gen(tablaCuadruplas, MULT_REAL,  $$.place,  $3.place,  $$.place);
        }
        $$.offset = OFFSET_NULO;
        fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(T))), getNombreSimbolo(T));
    	fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MULT ty_exp_a\n");
    }
    | ty_exp_a TK_DIV ty_exp_a {
        simbolo* T = newTemp(tablaSimbolos);
        $$.place = getIdSimbolo(T);
        modificaTipoVar(T, REAL);
        fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(T))), getNombreSimbolo(T));
        $$.type = REAL;
        gen(tablaCuadruplas, DIV,  $1.place,  $3.place,  $$.place);
        $$.offset = OFFSET_NULO;
    	fprintf(fSaR,"REDUCE ty_exp_a:  ty_exp_a TK_DIV ty_exp_a \n");
    }
    | ty_exp_a TK_MOD ty_exp_a {
        simbolo* T = newTemp(tablaSimbolos);
        $$.place = getIdSimbolo(T);
        modificaTipoVar(T, REAL);
        fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(T))), getNombreSimbolo(T));
        $$.type = REAL;
        gen(tablaCuadruplas, MOD,  $1.place,  $3.place,  $$.place);
        $$.offset = OFFSET_NULO;
    	fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_MOD ty_exp_a\n");
    }
    | ty_exp_a TK_DIV_ENT ty_exp_a {
        simbolo* T = newTemp(tablaSimbolos);
        $$.place = getIdSimbolo(T);
        modificaTipoVar(T, ENTERO);
        fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(T))), getNombreSimbolo(T));
        $$.type = ENTERO;
        gen(tablaCuadruplas, DIV_ENT,  $1.place,  $3.place,  $$.place);
        $$.offset = OFFSET_NULO;
    	fprintf(fSaR,"REDUCE ty_exp_a: ty_exp_a TK_DIV_ENT ty_exp_a\n");
    }
    | TK_PARENTESIS_INICIAL ty_exp_a TK_PARENTESIS_FINAL {
    	$$.place = $2.place;
        $$.type = $2.type;
        $$.offset = OFFSET_NULO;
    	fprintf(fSaR,"REDUCE ty_exp_a: TK_PARENTESIS_INICIAL ty_exp_a TK_PARENTESIS_FINAL\n");
    }
    | ty_operando {
        $$.place = $1.place;
        $$.type = $1.type;
        $$.offset = $1.offset;
        if($1.type == BOOLEANO){
            $$.True = makeList(getNextquad(tablaCuadruplas));
            $$.False = makeList(getNextquad(tablaCuadruplas) + 1);
            gen(tablaCuadruplas, GOTO_IF_VERDADERO, $1.place, -1, -1);
            gen(tablaCuadruplas, GOTO, -1, -1, -1);
        }
        fprintf(fSaR,"REDUCE ty_exp_a: ty_operando\n");
    }
    | TK_ENTERO {
        warning("este compilador aún no maneja asignacion de literales");
        $$.offset = OFFSET_NULO;
        fprintf(fSaR,"REDUCE ty_exp_a: TK_ENTERO\n");
    }
    | TK_REAL {
        warning("este compilador aún no maneja asignacion de literales");
        fprintf(fSaR,"REDUCE ty_exp_a: TK_REAL\n");
    }
    | TK_MENOS ty_exp_a %prec TK_MENOS_U {
        simbolo* T = newTemp(tablaSimbolos);
        $$.place = getIdSimbolo(T);
        if($2.type == ENTERO){
            modificaTipoVar(T, ENTERO);
            $$.type = ENTERO;
            gen(tablaCuadruplas, RESTA_INT, $2.place, -1,  $$.place);
        }else{
            modificaTipoVar(T, REAL);
            $$.type = REAL;
            gen(tablaCuadruplas, RESTA_REAL, $2.place, -1,  $$.place);        
        }
        $$.offset = OFFSET_NULO;
        fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(T))), getNombreSimbolo(T));
        fprintf(fSaR,"REDUCE ty_exp_a: TK_MENOS ty_exp_a\n");
    }
    ;
    
ty_exp_b:
      ty_expresion TK_PR_Y ty_M ty_expresion {
        // AND
        if($1.type == BOOLEANO && $4.type == BOOLEANO){
            backpatch(tablaCuadruplas, $1.True, $3.quad);
            $$.False = merge($1.False, $4.False);
            $$.True = $4.True;
            $$.type = BOOLEANO;
            fprintf(fSaR,"REDUCE ty_exp_b: ty_expresion TK_PR_Y ty_expresion\n");
        }else{
            yyerror("Operacion logica 'Y' imposible para tipo %s y tipo %s", getNombreDeConstante($1.type), getNombreDeConstante($4.type));
        }
      }
    | ty_expresion TK_PR_O ty_M ty_expresion {
        // OR
        if($1.type == BOOLEANO && $4.type == BOOLEANO){
            backpatch(tablaCuadruplas, $1.False, $3.quad);
            $$.True = merge($1.True, $4.True);
            $$.False = $4.False;
            $$.type = BOOLEANO;
            fprintf(fSaR,"REDUCE ty_exp_b: ty_expresion TK_PR_O ty_expresion_b\n");
        }else{
            yyerror("Operacion logica 'O' imposible para tipo %s y tipo %s", getNombreDeConstante($1.type), getNombreDeConstante($4.type));
        }
    }
    | TK_PR_NO ty_exp_b{
        // NOT
        $$.True = $2.False;
        $$.False = $2.True;
        $$.type = BOOLEANO;
        fprintf(fSaR,"REDUCE ty_exp_b: TK_PR_NO ty_exp_b\n");
    }
    | TK_BOOLEANO {
        $$.type = BOOLEANO;
        warning("este compilador aún no maneja asignacion de literales");
        fprintf(fSaR,"REDUCE ty_exp_b: TK_BOOLEANO\n");
    }
    | ty_expresion ty_op_relacional ty_expresion %prec TK_MUY_PRIORITARIO {
        if(($1.type == ENTERO || $1.type == REAL || $1.type == CARACTER) && 
            $1.type == $3.type)
        {
            $$.True = makeList(getNextquad(tablaCuadruplas));
            $$.False = makeList(getNextquad(tablaCuadruplas)+1);
            $$.type = BOOLEANO;
            // generacion del salto condicional
            switch($2) {
                case MAYOR:
                    gen(tablaCuadruplas, GOTO_IF_OP_REL_MAYOR, $1.place, $3.place, -1);
                    break;
                case MENOR:
                    gen(tablaCuadruplas, GOTO_IF_OP_REL_MENOR, $1.place, $3.place, -1);
                    break;
                case MAYOR_O_IGUAL:
                    gen(tablaCuadruplas, GOTO_IF_OP_REL_MAYOR_IGUAL, $1.place, $3.place, -1);
                    break;
                case MENOR_O_IGUAL:
                    gen(tablaCuadruplas, GOTO_IF_OP_REL_MENOR_IGUAL, $1.place, $3.place, -1);
                    break;
                case IGUAL:
                    gen(tablaCuadruplas, GOTO_IF_OP_REL_IGUAL, $1.place, $3.place, -1);
                    break;
                case DESIGUAL:
                    gen(tablaCuadruplas, GOTO_IF_OP_REL_DESIGUAL, $1.place, $3.place, -1);
                    break;
            }
            // generacion del salto no condicional
            gen(tablaCuadruplas, GOTO, -1, -1, -1);
        }else{
            if($1.type == $3.type){
                yyerror("comparación no posible para el tipo %s", getNombreDeConstante($1.type));
            }else{
                yyerror("comparacion %s con tipos diferentes: tipo %s y tipo %s", getNombreDeConstante($2), getNombreDeConstante($1.type), getNombreDeConstante($3.type));
            }
        }
        fprintf(fSaR,"REDUCE ty_exp_b: ty_expresion TK_OP_RELACIONAL ty_expresion\n");
    }
    | TK_PARENTESIS_INICIAL ty_exp_b TK_PARENTESIS_FINAL {
        $$.True = $2.True;
        $$.False = $2.False;
        $$.type = BOOLEANO;
        fprintf(fSaR,"REDUCE ty_exp_b: TK_PARENTESIS_INICIAL ty_exp_b TK_PARENTESIS_FINAL\n");
    }
    ;

ty_op_relacional:
    TK_OP_RELACIONAL {$$ = $1;}
    | TK_IGUAL {$$ = $1;}
    ;

ty_M: 
    /*vacio*/ {
        $$.quad = getNextquad(tablaCuadruplas);
        fprintf(fSaR,"REDUCE ty_M: vacío\n");
    }
    ;

ty_N:
    /*vacio*/ {
        $$.next = makeList(getNextquad(tablaCuadruplas));
        // generacion del salto no condicional
        gen(tablaCuadruplas, GOTO, -1, -1, -1);
        fprintf(fSaR,"REDUCE ty_N: vacío\n");
    }
    ;

ty_expresion:
    ty_exp_a {
        $$.place = $1.place;
        $$.type = $1.type;
        $$.offset = $1.offset;
        /* Podemos haber reducido una variable booleana
         * Ruta: 
         *       ty_operando -> TK_IDENTIFICADOR
         *       ty_exp_a -> ty_operando
         *
         * y ahora:
         *
         *       ty_expresion -> ty_exp_a 
         *                                */
        if($1.type == BOOLEANO){
            $$.True = $1.True;
            $$.False = $1.False;
        }else{
            $$.True = NULL;
            $$.False = NULL;
        }
        fprintf(fSaR,"REDUCE ty_expresion: ty_exp_a\n");
    }
    | ty_exp_b %prec TK_NADA_PRIORITARIO {
        $$.True = $1.True;
        $$.False = $1.False;
        $$.type = $1.type;
        $$.offset = OFFSET_NULO;
        fprintf(fSaR,"REDUCE ty_expresion: ty_exp_b\n");
    }
    | ty_funcion_ll {fprintf(fSaR,"REDUCE ty_expresion: ty_funcion_ll\n");}
    ;

ty_operando:
    TK_IDENTIFICADOR {
        simbolo* var = getSimboloPorNombre(tablaSimbolos, $1);
        if(var == NULL){
            yyerror("variable '%s' usada pero no declarada", $1);
            exit(-1);
            // Aqui habría que intentar seguir con la compilacion.
            // Pero es basante complicado: Podriamos crear una variable nueva y cuando sepamos de que tipo debería ser se lo definimos
        }else{
            if(simboloEsUnaVariable(var)) {
                marcarComoUsado(var);
                $$.place = getIdSimbolo(var);
                $$.type = getTipoVar(var);
            }else{
                yyerror("%s no es una variable", $1);
            }
        }
        $$.offset = OFFSET_NULO;
        fprintf(fSaR,"REDUCE ty_operando: TK_IDENTIFICADOR\n");
    }
    | ty_operando TK_PUNTO ty_operando {fprintf(fSaR,"REDUCE ty_operando: ty_operando TK_PUNTO ty_operando\n");}
    | ty_operando TK_INICIO_ARRAY ty_expresion TK_FIN_ARRAY {
    	simbolo* T = newTemp(tablaSimbolos);
    	modificaTipoVar(T, ENTERO);
        fprintf(fTS,"Insertada variable %s '%s'\n", getNombreSimbolo(getSimboloPorId(tablaSimbolos, getTipoVar(T))), getNombreSimbolo(T));
    	// TODO: Realmente sería $3.place - 1, pero nos tomamos esa licencia....Hola Carlos, no entiendo este comentario 
    	gen(tablaCuadruplas, MULT_ALTERADA, $3.place, consulta_bpw_TS(tablaSimbolos, getIdTipoContenidoVariableTabla(tablaSimbolos, getSimboloPorId(tablaSimbolos, $1.place))), T -> id);
    	$$.offset = T -> id;
    	fprintf(fSaR,"REDUCE ty_operando: ty_operando TK_INICIO_ARRAY ty_expresion TK_FIN_ARRAY\n");
    }
    | ty_operando TK_PR_REF {fprintf(fSaR,"REDUCE ty_operando: ty_operando TK_PR_REF\n");}
    ;

ty_instrucciones:
      ty_instruccion TK_PUNTOYCOMA ty_M ty_instrucciones {
      	backpatch(tablaCuadruplas, $1.next, $3.quad);
      	$$.next = $4.next;
      	fprintf(fSaR,"REDUCE ty_instrucciones: ty_instruccion TK_PUNTOYCOMA ty_instrucciones\n");}
    | ty_instruccion TK_PUNTOYCOMA {
      	backpatch(tablaCuadruplas, $1.next, getNextquad(tablaCuadruplas));
    	$$.next = $1.next;
    	fprintf(fSaR,"REDUCE ty_instrucciones: ty_instruccion TK_PUNTOYCOMA\n");}
    ;

ty_instruccion:
      TK_PR_CONTINUAR {
        $$.next = makeEmptyList();
        fprintf(fSaR,"REDUCE ty_instruccion: TK_PR_CONTINUAR\n");}
    | ty_asignacion {
    	/* .next vacio para asignaciones */
    	$$.next = makeEmptyList();
    	fprintf(fSaR,"REDUCE ty_instruccion: ty_asignacion\n");}
    | ty_alternativa {
    	$$.next = $1.next;
    	fprintf(fSaR,"REDUCE ty_instruccion: ty_alternativa\n");}
    | ty_iteracion {
    	$$.next = $1.next;
    	fprintf(fSaR,"REDUCE ty_instruccion: ty_iteracion\n");}
    | ty_accion_ll {fprintf(fSaR,"REDUCE ty_instruccion: ty_accion_ll\n");}
    ;

ty_asignacion:
      ty_operando TK_ASIGNACION ty_expresion_t {
      	if ($1.offset == OFFSET_NULO && $3.offset == OFFSET_NULO){
	        if ($1.type == $3.type){
	            if ($1.type == BOOLEANO){
	                backpatch(tablaCuadruplas, $3.True, getNextquad(tablaCuadruplas));
	                gen(tablaCuadruplas, ASIGNAR_VALOR_VERDADERO, -1, -1, $1.place);
	                gen(tablaCuadruplas, GOTO, -1, -1, getNextquad(tablaCuadruplas) + 2);
	                backpatch(tablaCuadruplas, $3.False,  getNextquad(tablaCuadruplas));
	                gen(tablaCuadruplas, ASIGNAR_VALOR_FALSO, -1, -1, $1.place);
	            }else{
	                gen(tablaCuadruplas, ASIGNACION, $3.place, -1, $1.place);
	            }
	        } else {
                if ($1.type == REAL && $3.type == ENTERO){
                    gen(tablaCuadruplas, INT_TO_REAL, $3.place, -1, $1.place);
                }else{
                    yyerror("error en la asignación, el valor asignado no es del tipo correcto: %s := %s", 
                                        getNombreSimbolo(getSimboloPorId(tablaSimbolos, $1.type)), 
                                        getNombreSimbolo(getSimboloPorId(tablaSimbolos, $3.type)));
                }
	        	
	        }
	    } else {
	    	if ($1.offset == OFFSET_NULO){
	    		if ($1.type == getIdTipoContenidoVariableTabla(tablaSimbolos, getSimboloPorId(tablaSimbolos, $3.place))){
	    			// TODO: Mejorar esta parte para finalizar el trabajo
	    			gen(tablaCuadruplas, ASIGNACION_DE_POS_TABLA, $3.place, $3.offset, $1.place);
	    		}else{
	    			yyerror("error en la asignación, el valor asignado no es del tipo correcto: %s := array de %s", 
                                        getNombreSimbolo(getSimboloPorId(tablaSimbolos, $1.type)), 
                                        getNombreTipoContenidoVariableTabla(tablaSimbolos, getSimboloPorId(tablaSimbolos, $3.place)));
	    		}
	    	}else{
	    		if (getIdTipoContenidoVariableTabla(tablaSimbolos, getSimboloPorId(tablaSimbolos, $1.place)) == $3.type){
	    			gen(tablaCuadruplas, ASIGNACION_A_POS_TABLA, $3.place, $1.offset, $1.place);
	    		}else{
	    			yyerror("error en la asignación, el valor asignado no es del tipo correcto: array de %s := %s", 
                                        getNombreTipoContenidoVariableTabla(tablaSimbolos, getSimboloPorId(tablaSimbolos, $1.place)), 
                                        getNombreSimbolo(getSimboloPorId(tablaSimbolos, $3.type)));
	    		}
	    	}
	    }
        $$.idVar = $1.place;
        fprintf(fSaR,"REDUCE ty_asignacion:ty_operando TK_ASIGNACION ty_expresion_t\n");
    }
    | ty_operando TK_ASIGNACION TK_CADENA {fprintf(fSaR,"REDUCE ty_asignacion:ty_operando TK_ASIGNACION TK_CADENA\n");}
    ;

ty_alternativa:
    TK_PR_SI ty_exp_b TK_ENTONCES ty_M ty_instrucciones ty_N ty_M ty_lista_opciones TK_PR_FSI {
        backpatch(tablaCuadruplas, $2.True, $4.quad);
        backpatch(tablaCuadruplas, $2.False, $7.quad);
        if (!esListaVacia($8.next)){
            $$.next = merge($6.next, merge($5.next, $8.next));
        }else{
            $$.next = merge($6.next, merge($5.next, makeList(getNextquad(tablaCuadruplas))));
            gen(tablaCuadruplas, GOTO, -1, -1, -1);
        }
        fprintf(fSaR,"REDUCE ty_alternativa: TK_PR_SI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones TK_PR_FSI\n");
    }
    ;

ty_lista_opciones:
      TK_SINOSI ty_expresion TK_ENTONCES ty_M ty_instrucciones ty_N ty_M ty_lista_opciones {
        backpatch(tablaCuadruplas, $2.True, $4.quad);
        backpatch(tablaCuadruplas, $2.False, $7.quad);
        if (!esListaVacia($8.next)){
            $$.next = merge($6.next, merge($5.next, $8.next));
        }else{
            $$.next = merge($6.next, merge($5.next, makeList(getNextquad(tablaCuadruplas))));
            gen(tablaCuadruplas, GOTO, -1, -1, -1);
        }
        fprintf(fSaR,"REDUCE TK_SINOSI ty_expresion TK_ENTONCES ty_instrucciones ty_lista_opciones\n");
    }
    | /*vacio*/ {
    	$$.next = makeEmptyList();
    	fprintf(fSaR,"REDUCE ty_lista_opciones: vacio\n");}
    ;

ty_iteracion:
      ty_it_cota_fija {
      	$$.next = $1.next;
      	fprintf(fSaR,"REDUCE ty_iteracion: ty_it_cota_fija\n");
    }
    | ty_it_cota_exp {
    	$$.next = $1.next;
    	fprintf(fSaR,"REDUCE ty_iteracion: ty_it_cota_exp\n");
    }
    ;

ty_it_cota_exp:
    TK_PR_MIENTRAS ty_M ty_exp_b TK_PR_HACER ty_M ty_instrucciones TK_PR_FMIENTRAS {
        backpatch(tablaCuadruplas, $3.True, $5.quad);
        if(!esListaVacia($6.next)){
        	backpatch(tablaCuadruplas, $6.next, $2.quad);
        }else{
        	gen(tablaCuadruplas, GOTO, -1, -1, $2.quad);
        }
        $$.next = $3.False;
        fprintf(fSaR,"REDUCE ty_it_cota_exp:  TK_PR_MIENTRAS ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FMIENTRAS\n");
    }
    ;

ty_it_cota_fija:
    TK_PR_PARA ty_asignacion TK_PR_HASTA  ty_expresion TK_PR_HACER ty_M ty_instrucciones TK_PR_FPARA {
        // La variable iteradora debe ser de tipo entero, y la expresión de la condición de parada también
        simbolo* varIterable = getSimboloPorId(tablaSimbolos, $2.idVar);
        if (getTipoVar(varIterable) == ENTERO && $4.type == ENTERO){
            backpatch(tablaCuadruplas, $7.next, getNextquad(tablaCuadruplas));
            gen(tablaCuadruplas, SUMA_1, getIdSimbolo(varIterable), -1, getIdSimbolo(varIterable));     // Aumentamos en 1 el valor de la variable iteradora
            gen(tablaCuadruplas, GOTO_IF_OP_REL_MENOR, getIdSimbolo(varIterable), $4.place, $6.quad);   // Realizamos la comparación con la condición de parada
            $$.next = makeList(getNextquad(tablaCuadruplas));
            gen(tablaCuadruplas, GOTO, -1, -1, -1);
        }else{
            yyerror("El bucle para se ejecuta con valores enteros: encontrado tipos %s y %s",
                                                                                        getNombreDeConstante(getTipoVar(varIterable)),
                                                                                        getNombreDeConstante($4.type));
        }
        fprintf(fSaR,"REDUCE ty_it_cota_fija: TK_PR_PARA TK_IDENTIFICADOR TK_ASIGNACION ty_expresion TK_PR_HASTA ty_expresion TK_PR_HACER ty_instrucciones TK_PR_FPARA\n");
    }
    ;

/* DECLARACIONES DE ACCIONES Y FUNCIONES */

ty_accion_d:
    TK_PR_ACCION ty_a_cabecera ty_bloque TK_PR_FACCION {
        fprintf(fSaR,"REDUCE ty_accion_d: TK_PR_ACCION ty_a_cabecera ty_bloque TK_PR_FACCION\n");
    }
    ;

ty_funcion_d:
    TK_PR_FUNCION ty_f_cabecera ty_bloque TK_PR_DEV ty_expresion TK_PR_FFUNCION {
        fprintf(fSaR,"REDUCE ty_funcion_d: TK_PR_FUNCION ty_f_cabecera ty_bloque TK_PR_DEV ty_expresion TK_PR_FFUNCION\n");
    }
    ;

ty_a_cabecera:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_d_par_form TK_PARENTESIS_FINAL TK_PUNTOYCOMA {
        fprintf(fSaR,"REDUCE ty_a_cabecera: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_d_par_form TK_PARENTESIS_FINAL TK_PUNTOYCOMA\n");
    }
    ;

 ty_f_cabecera:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_lista_d_var TK_PARENTESIS_FINAL TK_PR_DEV ty_d_tipo TK_PUNTOYCOMA {
        fprintf(fSaR,"REDUCE ty_f_cabecera: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_lista_d_var TK_PARENTESIS_FINAL TK_PR_DEV ty_d_tipo TK_PUNTOYCOMA\n");
    }
    ;

ty_d_par_form:
    ty_d_p_form TK_PUNTOYCOMA ty_d_par_form {fprintf(fSaR,"REDUCE ty_d_par_form: ty_d_p_form TK_PUNTOYCOMA ty_d_par_form\n");}
    | /*vacio*/ {fprintf(fSaR,"REDUCE ty_d_par_form: vacio\n");}
    ;

ty_d_p_form:
      TK_PR_ENT ty_lista_id TK_TIPO_VAR ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_p_form: TK_PR_ENT ty_lista_id TK_TIPO_VAR ty_d_tipo\n");}
    | TK_PR_SAL ty_lista_id TK_TIPO_VAR ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_p_form: TK_PR_SAL ty_lista_id TK_TIPO_VAR ty_d_tipo\n");}
    | TK_PR_ES  ty_lista_id TK_TIPO_VAR ty_d_tipo {fprintf(fSaR,"REDUCE ty_d_p_form: TK_PR_ES  ty_lista_id TK_TIPO_VAR ty_d_tip\n");}
    ;

/* LLAMADAS ACCIONES Y FUNCIONES */

ty_accion_ll:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL {
    	/* TODO: NO DESARROLLADO */
    	fprintf(fSaR,"REDUCE ty_accion_ll: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL\n");
   	}
    ;

ty_funcion_ll:
    TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL {
    	/* TODO: NO DESARROLLADO */
    	fprintf(fSaR,"REDUCE ty_funcion_ll: TK_IDENTIFICADOR TK_PARENTESIS_INICIAL ty_l_ll TK_PARENTESIS_FINAL\n");
    }
    ;

ty_l_ll:
      ty_expresion TK_SEPARADOR ty_l_ll {
      	/* TODO: NO DESARROLLADO */
      	fprintf(fSaR,"REDUCE ty_l_ll: ty_expresion TK_SEPARADOR ty_l_ll\n");
    }
    | ty_expresion {
    	/* TODO: NO DESARROLLADO */
    	fprintf(fSaR,"REDUCE ty_l_ll: ty_expresion\n");
    }
    ;


%%

int main (int argc, char *argv[]) {

    // checkear numero de parametros
    if(argc != 2){
        printf("Uso del compilador: ./a.out <NombreDelPrograma>\n");
        exit(1);
    }
    programName = argv[1];
    // redirigir el archivo del programa a la entrada estandar
    FILE *fPrograma = freopen(programName, "r", stdin);
    if(fPrograma == 0){
        printf("algoritmo %s no encontrado\n", argv[1]);
        exit(1);
    }
    
    // abrir el fichero con con SHIFT y los REDUCE
    fSaR = fopen("out.ShiftsAndReduces", "w");
    if (fSaR == NULL){
        printf("Error abriendo out.ShiftsAndReduces\n");
        exit(1);
    }
    // abrir el fichero con con la tabla de simbolos
    fTS = fopen("out.TablaSimbolos", "w");
    if (fTS == NULL){
        printf("Error abriendo out.TablaSimbolos\n");
        exit(1);
    }
    // abrir el fichero con con la tabla de cuadruplas
    fTC = fopen("out.TablaCuadruplas", "w");
    if (fTS == NULL){
        printf("Error abriendo out.TablaCuadruplas\n");
        exit(1);
    }

	tablaSimbolos = crearTablaDeSimbolos();
    tablaCuadruplas = crearTablaQuad();
    output = makeEmptyList();

	yyparse();

	printSimbolosNoUsados(tablaSimbolos);
	insertarOutputEnTablaCuadruplas(tablaCuadruplas, tablaSimbolos, output);
    escribirTablaCuadruplas(tablaSimbolos, tablaCuadruplas, fTC);

    fclose(fTS);
    fclose(fTC);
    fclose(fSaR);
}

/**
 * funcion yyerror de http://web.iitd.ac.in/~sumeet/flex__bison.pdf  pag.220
 * puede ser llamada como se llama a la funcion printf (nº indeterminado de argumentos)
 * errorText es la string con los %s y %i...
 */
void yyerror(const char *errorText, ...) {
    va_list args;  
    va_start(args, errorText);
    
    printf(RED"%s:%d:%d: Error "RESET, programName, yylloc.first_line, yylloc.first_column);
    vprintf(errorText, args);  
    if(strcmp("syntax error", errorText) == 0){
        printf(". Revise out.ShiftsAndReduces");
    }
    printf("\n    Antes de '%s'\n", yytext);
}

void warning(const char *warningText, ...){
    va_list args;
    va_start(args, warningText);
    printf(MAGENTA"%s:%d:%d: Warning "RESET, programName, yylloc.first_line, yylloc.first_column);  
    vprintf(warningText, args);
    printf("\n    Antes de '%s'\n", yytext);
}


/*
Documentacion:  http://dinosaur.compilertools.net/bison/
                http://web.iitd.ac.in/~sumeet/flex__bison.pdf
 */
