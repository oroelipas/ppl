
/* CABECERA DEL MODULO lista_ligada_int.h*/

#ifndef CM_OI_LISTA_LIGADA_INT_H
#define CM_OI_LISTA_LIGADA_INT_H
#include "tablaCuadruplas.h"

typedef struct nodo {
	int contenido;
	struct nodo* next;
} nodo;

typedef struct t_lista_ligada_int {
	struct nodo* first;
	struct nodo* last;	// Nos facilita la concatenación de las listas con la función merge(header1, header2)
} t_lista_ligada_int;

/* DECLARACIÓN DE FUNCIONES GLOBALES */
extern t_lista_ligada_int* makeList(int valor);
extern t_lista_ligada_int* merge(t_lista_ligada_int* header1, t_lista_ligada_int* header2);
extern int backpatch(t_tabla_quad* t, t_lista_ligada_int* header, int valor);

#endif