
/*  CABECERA DEL MODULO tablaSimbolos
	Autores: Oroel Ipas y Carlos Moyano */

#ifndef CM_OI_TABLA_SIMBOLOS_H
#define CM_OI_TABLA_SIMBOLOS_H
#include "defines.h"

typedef struct lista_ligada {
    struct simbolo *first;    	// Referencia al primer simbolo almacenado
    int contador;				// Número de elementos contenidos en la lista ligada
}  lista_ligada;

typedef struct infoTipo {
    /* Solamente se ha utilizado pensando en la creación de tipos de tablas como máximo de 2 dimensiones, además de los tipos básicos */
    // UTILIZADO EN TIPOS BÁSICOS
    int bpw; // tamaño del tipo, solamente lo utilizamos para los tipos básicos por el momento
    // UTILIZADO EN TIPOS DE ARRAYS
    int tipoContenido; // id del tipo que contiene nuestro array
    int nDim; // número de dimensiones de la tabla (el parser solamente tolera tipos de tablas de 2 dimensiones como máximo)
    int arrayQuadLen[MAX_DIM_ARRAY]; // array de ids de las variables temporales que almacenan la longitud de cada una de las dimensiones del array
} infoTipo;

typedef struct { int tipo_variable;} t_infoVar;
typedef struct { infoTipo* info;} t_infoTipo;
typedef struct { char *ent; char *sal;} t_infoFunc;

typedef union {
    t_infoVar  t1;
    t_infoTipo t2;
    t_infoFunc t3;
} infoSimbolo;

typedef struct simbolo {
    int id;					// Identificador del simbolo (utilizado como si fuera una clave primaria)
    char *nombre;       	// Referencia al nombre del objeto almacenado
    int tipo;				// Indica el tipo del objeto almacenado [1 -> VARIABLE, 2 -> TIPO]
    int usado;          	// Valor 1 si el simbolo ha sido usado. Valor 0 si el simbolo ha sido declarado y nunca usado (poner macros)
    infoSimbolo info;  		// Referencia a la información del objeto almacenado
    struct simbolo *next;  	// Referencia al siguiente simbolo
} simbolo;

// DECLARACIÓN DE FUNCIONES GLOBALES
extern lista_ligada* crearListaLigada();
extern lista_ligada* crearTablaDeSimbolos();
extern simbolo* pop (lista_ligada *header);
extern void vaciarListaLigada (lista_ligada *header);
extern void vaciarTablaSimbolos (lista_ligada *header);
extern void printListaLigada (lista_ligada *header);
extern void printSimbolosNoUsados (lista_ligada *header);
extern int consulta_bpw_TS (lista_ligada *header, int id);
extern simbolo* newTemp (lista_ligada *header);
extern void marcarComoUsado (simbolo *misimbolo);
extern void addNombreSimbolo (lista_ligada *header, int id, char* nombre);
extern simbolo* getSimboloPorId (lista_ligada *header, int id);
extern simbolo* getSimboloPorNombre (lista_ligada *header, char* nombre);
extern char *getNombreSimbolo (simbolo* misimbolo);
extern int getTipoSimbolo (simbolo* misimbolo);
extern int getIdSimbolo (simbolo* misimbolo);
extern int simboloEsUnaVariable (simbolo* misimbolo);
extern simbolo* insertarVariable (lista_ligada *header, char *nombre, int tipo);
extern int insertarSimbolo (lista_ligada *header, simbolo* misimbolo);
extern void modificaTipoVar (simbolo* var, int tipo_var);
extern infoTipo* crearInfoTipoDeTabla (int tipoContenido, int cuadruplaQueCalculaSuLongitud1, int cuadruplaQueCalculaSuLongitud2);
extern infoTipo* crearInfoTipoBasico (int bpw);
extern simbolo* insertarTipo (lista_ligada *header, infoTipo* info);
extern void addInfoTipo (simbolo* s, infoTipo* info);
extern int simboloEsUnTipo (simbolo* misimbolo);
extern int simboloEsUnTipoBasico (simbolo* misimbolo);
extern int simboloEsUnaVariable (simbolo* misimbolo);
extern char* getNombreTipoContenidoVariableTabla (lista_ligada *header, simbolo* misimbolo);
extern int getIdTipoContenidoVariableTabla (lista_ligada *header, simbolo* misimbolo);
extern int getIdTipoContenidoTabla (lista_ligada *header, simbolo* misimbolo);
extern int getTipoVar (simbolo* misimbolo);
extern int consulta_dim_maxima_TS (lista_ligada* header, int idTipoArray);
extern int consulta_limite_TS (lista_ligada* header, int idTipoArray, int dimActual);
extern int esArrayDe1Dimension (lista_ligada* header, int idVarTipoArray);
#endif
