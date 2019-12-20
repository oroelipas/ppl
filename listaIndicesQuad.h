
/*  CABECERA DEL MODULO lista_ligada_int
	Autores: Oroel Ipas y Carlos Moyano */

#ifndef CM_OI_LISTA_LIGADA_INT_H
#define CM_OI_LISTA_LIGADA_INT_H

typedef struct nodo {
	int contenido;
	struct nodo* next;
} nodo;

typedef struct t_lista_ligada_int {
	struct nodo* first;
	struct nodo* last;	// Nos facilita la concatenación de las listas con la función merge(header1, header2)
} t_lista_ligada_int;

#include "tablaCuadruplas.h"

// DECLARACIÓN DE FUNCIONES GLOBALES
extern int esListaVacia (t_lista_ligada_int* header);
extern t_lista_ligada_int* makeList (int valor);
extern t_lista_ligada_int* makeEmptyList();
extern t_lista_ligada_int* merge (t_lista_ligada_int* header1, t_lista_ligada_int* header2);
extern int backpatch (t_tabla_quad* t, t_lista_ligada_int* header, int valor);
extern int popListaIndices (t_lista_ligada_int* header);
#endif