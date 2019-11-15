#ifndef CM_OI_TABLA_SIMBOLOS_H
#define CM_OI_TABLA_SIMBOLOS_H

typedef struct lista_ligada {
    struct simbolo *first;    // Referencia al primer simbolo almacenado
    int contador;          //de index de simbolos
}  lista_ligada;

// La información de estas estructuras se añade por medio de la función addInfosimbolo
typedef struct { int tipo_variable;} infoVar;
typedef struct { char *tipo_tipo;  } infoTipo;
typedef struct { char *ent; char *sal; } infoFunc;
// En el futuro tendremos (quizás) un campo que nos indique el bloque en el que se ha definido una variable concreta [siendo el nivel 0 el de las globales]

typedef union {
    infoVar  t1;
    infoTipo t2;	
    infoFunc t3;
} info_simbolo;

typedef struct simbolo {
    int id;           //primary key
    char *nombre;       // Referencia al nombre del objeto almacenado
    int tipo;			// Indica el tipo del objeto almacenado [1 -> VARIABLE, 2 -> TIPO]
    int usado;          // 1 si el simbolo ha sido usado. 0 si el simbolo ha sido declarado y nunca usado
    info_simbolo info;  	// Referencia a la información del objeto almacenado
    struct simbolo *next;  // Referencia al siguiente simbolo
} simbolo;


extern simbolo* pop(lista_ligada *header);
extern lista_ligada* crearListaLigada();
extern lista_ligada* crearTablaDeSimbolos();
extern int simboloEsUnaVariable(simbolo* misimbolo);
extern simbolo* getSimboloPorNombre (lista_ligada *header, char* nombre);
extern void printSimbolosNoUsados(lista_ligada *header);
extern simbolo* newTemp(lista_ligada *header);
extern void printListaLigada (lista_ligada *header);
extern simbolo* insertarVariable(lista_ligada *header, char *nombre, int tipo);
extern int simboloEsUnTipo(simbolo* misimbolo);
extern void marcarComoUsado (simbolo *misimbolo);
extern simbolo* getSimboloPorId (lista_ligada *header, int id);
extern char *getNombreSimbolo(simbolo* misimbolo);
extern void modificaTipoVar(simbolo* var, int tipo_var);
extern int getIdSimbolo(simbolo* misimbolo);
extern int getTipoVar (simbolo* misimbolo);

#endif