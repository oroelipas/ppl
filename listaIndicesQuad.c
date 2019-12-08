
/*  DEFINICION DEL MODULO lista_ligada_int.h
	Autores: Oroel Ipas y Carlos Moyano */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "listaIndicesQuad.h"
#include "tablaCuadruplas.h"

// DECLARACIÓN DE FUNCIONES LOCALES
static int getContenidoNodo (nodo* n);
static void vaciarLista (t_lista_ligada_int *header);
static int insertNodo (t_lista_ligada_int* header, int valor);
static void printListaInt (t_lista_ligada_int* header);

// DEFINICIÓN DE FUNCIONES LOCALES

/* 
 * Funcionalidad: Devuelve el contenido del nodo cuya referencia se pasa como parametro.
 */
int getContenidoNodo (nodo* n) {
	return n -> contenido;
}

/* 
 * Funcionalidad: Vacía la lista ligada de indices cuya referencia se pasa como parametro.
 */
void vaciarLista (t_lista_ligada_int *header) {
    if (header -> first == NULL) {
        printf("Vaciar lista: La lista YA estaba vacía\n");
    } else {
        nodo *auxant = NULL;
        nodo *aux = header -> first;
        while (aux -> next != NULL) {
            auxant = aux;
            aux = aux -> next;
            free(auxant);
        }
        free(aux);
        header -> first = NULL;
        header -> last = NULL;
    }
}

/**
 * Funcionalidad: Inserta un elemento en una lista ligada de indices.
 * Parámetros:
 *	 t_lista_ligada_int* header -> referencia a la lista ligada de indices en la que queremos insertar el elemento
 *	 int valor 					-> contenido que queremos que tenga el elemento a insertar
 * Return:
 *	 0  -> si la insercion no se realiza correctamente
 *   1  -> si la insercion se realiza correctamente
 */
int insertNodo (t_lista_ligada_int* header, int valor) {
	/* Creamos el nodo a insertar */
	nodo* aux = (nodo*)malloc(sizeof(nodo));
	aux -> contenido = valor;
	aux -> next = NULL;
	///////////////////////////////
    if (header -> first == NULL) {
        header -> first = aux;
        header -> last = aux;
    } else {
        header -> last -> next = aux;
        header -> last = aux;
    }
    return 1;
}

/**
 * Funcionalidad: Muestra por pantalla el contenido de una lista ligadad de índices.
 */
void printListaInt (t_lista_ligada_int* header) {
	printf("Contenido lista de enteros:\n");
	if(esListaVacia(header)) {
		printf("	La lista está vacía\n");
	} else {
		nodo *aux;
		aux = header -> first;
		while (aux != NULL) {
	    	printf("	Contenido nodo: %d\n", aux -> contenido);
	    	aux = aux -> next;
	    }
	}
	printf("\n");
}
/////////////////////////////////////////////////////////////////////////////////////////////////

// DEFINICIÓN DE FUNCIONES GLOBALES

/**
 * Funcionalidad: Comprueba si una lista ligada de indices está vacía.
 * Return:
 *	 1  -> si la lista esta vacia
 *   0  -> si la lista no esta vacia
 */
int esListaVacia (t_lista_ligada_int* header) {
	return header -> first == NULL;
}

/**
 * Funcionalidad: Crea una lista ligada de indices con 1 elemento cuyo contenido se pasa como parámetro y devuelve una referencia a la misma.
 * Parámetros:
 *	 int valor -> contenido que queremos que tenga el único elemento con el que se va a crear la nueva lista
 * Return:
 *	 NULL   	  -> si la insercion no se realiza correctamente
 *   referencia   -> si la insercion se realiza correctamente
 */
t_lista_ligada_int* makeList (int valor) {
	t_lista_ligada_int* l = (t_lista_ligada_int*)malloc(sizeof(t_lista_ligada_int));
	l -> first = NULL;
	l -> last = NULL;
	if (insertNodo(l, valor))
		return l;
	return NULL;	// Error inicializando la lista
}

/**
 * Funcionalidad: Crea una lista ligada de indices vacía y devuelve una referencia a la misma.
 */
t_lista_ligada_int* makeEmptyList() {
	t_lista_ligada_int* l = (t_lista_ligada_int*)malloc(sizeof(t_lista_ligada_int));
	l -> first = NULL;
	l -> last = NULL;
	return l;
}

/**
 * Funcionalidad: Concatena dos listas y devuelve la referencia a la lista resultado.
 * Parámetros:
 *   t_lista_ligada_int* header1 -> referencia a la lista ligada de indices numero 1
 *   t_lista_ligada_int* header2 -> referencia a la lista ligada de indices numero 2
 *
 * Return:
 *	 NULL   	  -> si ambas listas estan vacías
 *   referencia   -> si la concatenación se realiza sin problemas
 */
t_lista_ligada_int* merge (t_lista_ligada_int* header1, t_lista_ligada_int* header2) {
	if(esListaVacia(header1) && (!esListaVacia(header2)))
			return header2;
	if((!esListaVacia(header2)) && esListaVacia(header2))
			return header1;
	if((!esListaVacia(header1)) && (!esListaVacia(header2))) {
		header1 -> last -> next = header2 -> first;
		header1 -> last = header2 -> last;
		header2 -> first = NULL;
		header2 -> last = NULL;
		return header1;
	}
	// Ambas listas se encuentran vacías
	return NULL;
}

/**
 * Funcionalidad: Rellena con un valor determinado el contenido de los indices de la lista cuya referencia se pasa como parámetro.
 * Parámetros:
 *   t_lista_ligada_int* header -> referencia a la lista ligada de indices
 *
 * Return:
 *	 0   -> si la lista ligada esta vacía
 *   1   -> si la lista ligada no está vacía
 */
int backpatch (t_tabla_quad* t, t_lista_ligada_int* header, int valor) {
	if(!esListaVacia(header)){
        nodo *aux = header -> first;
        while(aux -> next != NULL) {
            if(!addDestinoGoto(t, getContenidoNodo(aux), valor)) {
            	// Error modificando el destino del salto que representa la intrucción con índice getContenido(aux) en la tabla de cuadruplas
            	return -1;
            }
            aux = aux -> next;
        }
        if(!addDestinoGoto(t, getContenidoNodo(aux), valor)) {
        	// Error modificando el destino del salto que representa la intrucción con índice getContenido(aux) en la tabla de cuadruplas
        	return -1;
       	}
        // En cuanto realizamos el backpatch, vaciamos la lista
        vaciarLista(header);
		return 1;
	}
	// Error, la lista se encuentra vacía
	return 0;
}

/**
 * Funcionalidad: Devuelve el primer indice de la lista y lo elimina de la misma.
 * Es especialmente útil cuando se quiere sacar todos los elementos de una lista uno a uno.
 * Parámetros:
 *   t_lista_ligada_int* header -> referencia a la lista ligada de indices
 *
 * Return:
 *	 0   		-> si la lista ligada esta vacía
 *   contenido  -> si la lista ligada no está vacía
 */
int popListaIndices (t_lista_ligada_int* header) {
	if(!esListaVacia(header)) {
		nodo *aux = header -> first;
		header -> first = header -> first -> next;
		return aux -> contenido;
	}
	// Error, la lista se encuentra vacía
	return 0;
}