/*
HAY QUE HACER LO .H BIEN PARA QUE NO SOBREESCRIBA NINGUNA FUCNION AL INCLUIRLO
CON #ifndef
*/
/*	CABECERA DEL MÓDULO QUE IMPLEMENTA UNA LISTA LIGADA */

/*
 DECISION DE COMO ESTAN HECHOS LOS STRUCT Y EL UNION:
 https://stackoverflow.com/questions/28107867/different-structs-in-the-same-node-linked-lists-c
 */
typedef struct lista_ligada {
    struct nodo *first;    // Referencia al primer nodo almacenado
    int contador;          //de index de nodos
}  lista_ligada;

// La información de estas estructuras se añade por medio de la función addInfoNodo
typedef struct { int tipo_variable;} infoVar;
typedef struct { char *tipo_tipo;  } infoTipo;
typedef struct { char *ent; char *sal; } infoFunc;
// En el futuro tendremos (quizás) un campo que nos indique el bloque en el que se ha definido una variable concreta [siendo el nivel 0 el de las globales]

typedef union {
    infoVar  t1;
    infoTipo t2;	
    infoFunc t3;
} info_nodo;

typedef struct nodo {
    int id;           //primary key
    char *nombre;       // Referencia al nombre del objeto almacenado
    int tipo;			// Indica el tipo del objeto almacenado [1 -> VARIABLE, 2 -> TIPO]
    int usado;          // 1 si el nodo ha sido usado. 0 si el nodo ha sido declarado y nunca usado
    info_nodo info;  	// Referencia a la información del objeto almacenado
    struct nodo *next;  // Referencia al siguiente nodo
} nodo;


extern nodo* pop(lista_ligada *header);
extern lista_ligada* crearListaLigada();
extern lista_ligada* crearTablaDeSimbolos();
extern int simboloEsUnaVariable(nodo* minodo);
extern nodo* getSimboloPorNombre (lista_ligada *header, char* nombre);
extern void printSimbolosNoUsados(lista_ligada *header);
extern nodo* newTemp(lista_ligada *header);
extern void printListaLigada (lista_ligada *header);
extern nodo* insertarVariable(lista_ligada *header, char *nombre, int tipo);
extern int simboloEsUnTipo(nodo* minodo);
extern void marcarComoUsado (nodo *minodo);
extern nodo* getSimboloPorId (lista_ligada *header, int id);
extern char *getNombreSimbolo(nodo* minodo);
extern void modificaTipoVar(nodo* var, int tipo_var);
extern int getIdSimbolo(nodo* minodo);
extern int getTipoVar (nodo* minodo);