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
	struct nodo *last;    // Referencia al primer nodo almacenado
}  lista_ligada;

// La información de estas estructuras se añade por medio de la función addInfoNodo
typedef struct { char *tipo_variable;} infoVar;
typedef struct { char *tipo_tipo;  } infoTipo;
typedef struct { char *ent; char *sal; } infoFunc;
// En el futuro tendremos (quizás) un campo que nos indique el bloque en el que se ha definido una variable concreta [siendo el nivel 0 el de las globales]

typedef union {
    infoVar*  t1;
    infoTipo* t2;	
    infoFunc* t3;
} info_nodo;

typedef struct nodo {
    char *nombre;       // Referencia al nombre del objeto almacenado
    int tipo;			// Indica el tipo del objeto almacenado [1 -> VARIABLE, 2 -> TIPO]
    int usado;          // 1 si el nodo ha sido usado. 0 si el nodo ha sido declarado y nunca usado
    info_nodo info;  	// Referencia a la información del objeto almacenado
    struct nodo *next;  // Referencia al siguiente nodo
} nodo;


extern nodo* pop(lista_ligada *header);
extern info_nodo crearInfoVariable(char *tipo_var);
extern lista_ligada* crearListaLigada();
extern nodo* crearNodo(char *nombre, int tipo);
extern int existeNodo (lista_ligada *header, char* nombre);
extern int insertNodo (lista_ligada *header, nodo* nuevoNodo);
extern void addInfoNodo (nodo* minodo, info_nodo info);
extern int addInfoNodoEnLista ( lista_ligada *header, char* nombre, info_nodo info);
extern info_nodo getInfoNodoEnLista (lista_ligada *header, char* nombre);
extern int getTipo(nodo* minodo);
extern char *getNombre(nodo* minodo);
extern void printListaLigada (lista_ligada *header);
extern void vaciarLista (lista_ligada *header);
extern nodo* getNodo (lista_ligada *header, char* nombre);
extern void marcarComoUsada(nodo* minodo);
extern void printSimbolosNoUsados(lista_ligada *header);
extern void marcarComoUsado(nodo* minodo);
  