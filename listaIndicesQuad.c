
/* DEFINICION DEL MODULO lista_ligada_int.h */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "listaIndicesQuad.h"
#include "tablaCuadruplas.h"

/* DECLARACIÓN DE FUNCIONES LOCALES */
static int getContenidoNodo(nodo* n);
static void vaciarLista (t_lista_ligada_int *header);
static int insertNodo(t_lista_ligada_int* header, int valor);
static void printListaInt(t_lista_ligada_int* header);

/* DEFINICIÓN DE FUNCIONES LOCALES */
int getContenidoNodo(nodo* n) {
	return n -> contenido;
}

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

int insertNodo(t_lista_ligada_int* header, int valor) {
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

void printListaInt(t_lista_ligada_int* header) {
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

/* DEFINICIÓN DE FUNCIONES GLOBALES */
int esListaVacia(t_lista_ligada_int* header) {
	return header -> first == NULL;
}

t_lista_ligada_int* makeList(int valor) {
	t_lista_ligada_int* l = (t_lista_ligada_int*)malloc(sizeof(t_lista_ligada_int));
	l -> first = NULL;
	l -> last = NULL;
	if(insertNodo(l, valor))
		return l;
	return NULL;	// Error inicializando la lista
}

t_lista_ligada_int* makeEmptyList() {
	t_lista_ligada_int* l = (t_lista_ligada_int*)malloc(sizeof(t_lista_ligada_int));
	l -> first = NULL;
	l -> last = NULL;
	return l;
}

// TODO: esta funcion tenemos que hacer que sirva para 3 listas
// o, idealmente, un numero indetermiando de listas, como la funcion yyerror
t_lista_ligada_int* merge(t_lista_ligada_int* header1, t_lista_ligada_int* header2) {
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

int backpatch(t_tabla_quad* t, t_lista_ligada_int* header, int valor) {
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

/*
int main(int argc, char** argv) {
	// Creamos la tabla de cuadruplas 
	t_tabla_quad* t;
	t = crearTablaQuad(t);
	///////////////////////////////////
	printf("Nextquad: %d\n", getNextquad(t));
	t_lista_ligada_int* l_true = makeList(getNextquad(t));
	t_lista_ligada_int* l_false = makeList(getNextquad(t) + 1);
	gen(t, 1, 1, 1, -1);
	printf("Nextquad: %d\n", getNextquad(t));
	gen(t, 2, 2, 2, -1);
	printTablaQuad(t);
	//Realizamos el merge de listas 
	l_true = merge(l_true, l_false);
	printListaInt(l_true);
	printListaInt(l_false);
	if(backpatch(t, l_true, getNextquad(t))) {
		printTablaQuad(t);
	}
	return 1;
}*/

/*
int main(int argc, char** argv){
	t_lista_ligada_int* l1 = makeList(1);
	t_lista_ligada_int* l2 = makeList(2);
	t_lista_ligada_int* l3;
	l1 = merge(l1, l2);
	printListaInt(l1);
	l3 = makeList(3);
	t_lista_ligada_int* l4 = makeList(4);
	l1 = merge(l1, merge(l3, l4));
	printListaInt(l1);
}
*/