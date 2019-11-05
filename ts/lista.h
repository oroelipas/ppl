
/*	CABECERA DEL MÓDULO QUE IMPLEMENTA UNA LISTA LIGADA */

#define TAM_MAX_NOMBRE 50		// Número de caracteres máximo que podrá tener el nombre del objeto almacenado
#define TAM_MAX_TIPO_VAR 100 	// Número de caracteres máximo que podrá tener el nombre de un tipo de variable (tanto básico como definido por el usuario)

/* Constantes que indican los tipos de los objetos almacenados en la lista ligada */
#define VARIABLE 1
#define D_TIPO 2

typedef struct t_nodo_ll {
    char *nombre;            	// Referencia al nombre del objeto almacenado
    int tipo;					// Indica el tipo del objeto almacenado [1 -> VARIABLE, 2 -> D_TIPO]
    struct t_info_nodo *info;  	// Referencia a la información del objeto almacenado
    struct t_nodo_ll *next;
} t_nodo_ll;

typedef struct t_lista_ligada {
    struct t_nodo_ll *first;    // Referencia al primer nodo almacenado
}  t_lista_ligada;


// La información de esta estructura se añadirá por medio de la función addInfoNodo
typedef struct t_info_nodo {
	/* Los campos de esta estructura que realmente almacenarán contenido vendrán indicados por el valor del campo tipo de t_nodo_ll */
	char *tipo_variable;
	// En el futuro tendremos (quizás) un campo que nos indique el bloque en el que se ha definido una variable concreta [siendo el nivel 0 el de las globales]
} t_info_nodo;

extern t_lista_ligada* crearListaLigada();
extern int findNodo (char* nombre, int tipo, t_lista_ligada *header);
extern int insertNodo (char* nombre, int tipo, t_lista_ligada *header);
extern int addInfoNodo (char* nombre, int tipo, t_lista_ligada *header, t_info_nodo* info);
extern t_info_nodo* getInfoNodo (char* nombre, int tipo, t_lista_ligada *header);
extern void printListaLigada (t_lista_ligada *header);
extern int destroyListaLigada (t_lista_ligada *header);