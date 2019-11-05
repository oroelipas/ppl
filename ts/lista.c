
/* MÓDULO QUE IMPLEMENTA UNA LISTA LIGADA */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "lista.h"

/* Declaracion funciones locales */
static t_nodo_ll* getNodo (char* nombre, int tipo, t_lista_ligada *header);
static void printVariable (t_nodo_ll *nodo);

/* DEFINICION DE FUNCIONES GLOBALES */

t_lista_ligada* crearListaLigada() {
    t_lista_ligada *lista = (t_lista_ligada *)malloc(sizeof(t_lista_ligada));
    lista -> first = NULL;
    return lista;
}

int findNodo (char* nombre, int tipo, t_lista_ligada *header) {
    if (getNodo(nombre, tipo, header) != NULL) {
        printf("El objeto de nombre [%s] se encuentra en la lista\n", nombre);
        return VARIABLE;
    }
    printf("El objeto de nombre [%s] no se encuentra en la lista\n", nombre);
    return 0;
}

int insertNodo (char *nombre, int tipo, t_lista_ligada *header) {

    // Primero realizamos una búsqueda para ver si es necesario realizar la inserción
    if (findNodo(nombre, tipo, header)) {
        printf("No se ha podido realizar la inserción del objeto\n");
        return 0;
    }

    // Nota para el futuro: tendremos un sistema de números de bloque, que nos indicarán la visibilidad
    t_nodo_ll *aux = (t_nodo_ll *)malloc(sizeof(t_nodo_ll));
    aux -> nombre = (char *)malloc(sizeof(char) * TAM_MAX_NOMBRE);
    if (strlen(nombre) <= TAM_MAX_NOMBRE) {
        printf("El nombre del objeto es válido\n");
        strcpy(aux -> nombre, nombre);
        aux -> tipo = tipo;
        aux -> info = (t_info_nodo *)malloc(sizeof(t_info_nodo)); // Reservamos memoria para la estructura que almacena la info del objeto
    } else {
        printf("Inserción INCORRECTA del objeto de nombre : %s\n", nombre);
        return 0;
    }
    aux -> next = NULL;
    if (header -> first == NULL) {
        header -> first = aux;
    }
    printf("Inserción CORRECTA del objeto de nombre : %s\n", nombre);
    return VARIABLE;
}

int addInfoNodo (char* nombre, int tipo, t_lista_ligada *header, t_info_nodo* info) {
    t_nodo_ll *aux = getNodo(nombre, tipo, header);
    if (aux != NULL) {
        // Aquí añadiríamos la información necesaria en función del tipo de objeto
        if (aux -> tipo == VARIABLE) {
            // CASO VARIABLE: En la estructura info asociada al objeto solamente tenemos valor en el campo tipo_variable
            aux -> info -> tipo_variable = (char *)malloc(sizeof(TAM_MAX_TIPO_VAR));
            strcpy(aux -> info -> tipo_variable, info -> tipo_variable);
            printf("Información añadida en el objeto correspondiente\n");
        }
        return VARIABLE;
    }
    printf("El objeto de nombre [%s] no se encuentra en la lista\n", nombre);
    return 0;  
}

t_info_nodo* getInfoNodo (char* nombre, int tipo, t_lista_ligada *header) {
    t_nodo_ll *aux = getNodo(nombre, tipo, header);
    if (aux != NULL) {
        // Aquí se podría filtrar la información que devolvemos en función del tipo de nodo
        if (aux -> tipo == VARIABLE) {
            printVariable(aux); // No necesario
            // Devolveriamos la info
            return aux -> info;
        }
        return aux -> info;
    }
    printf("El objeto de nombre [%s] no se encuentra en la lista, no se puede obtener su información\n", nombre);
    return 0;
}

void printListaLigada (t_lista_ligada *header) {
    t_nodo_ll *aux;
    if ((header == NULL) || (header -> first == NULL))
        printf("La lista ligada está vacía\n");
    else {
        aux = header -> first;
        while (aux -> next != NULL) {
            printf("Nombre del objeto: %s\n", aux -> nombre);
            if (aux -> tipo == VARIABLE) {
                printVariable(aux);
            }
            aux = aux -> next;
        }
        if (aux -> next == NULL) {
            printf("Nombre del objeto: %s\n", aux -> nombre);
            if (aux -> tipo == VARIABLE) {
                printVariable(aux);
            }
        }

    }
}

int destroyListaLigada (t_lista_ligada *header) {
    if (header == NULL) {
        printf("Error: Está intentando borrar el contenido de una referencia nula a una lista\n");
        return 0;
    } else {
        if (header -> first == NULL) {
            printf("La lista está vacía\n");
        } else {
            t_nodo_ll *auxant = NULL;
            t_nodo_ll *aux = header -> first;
            while (aux -> next != NULL) {
                auxant = aux;
                aux = aux -> next;
                free(auxant);
            }
            free(aux);
            header -> first = NULL;
            printf("La lista se ha vaciado\n");
        }
    }
    return VARIABLE;
}

/* DEFINICION DE FUNCIONES LOCALES */

t_nodo_ll* getNodo (char* nombre, int tipo, t_lista_ligada *header) {
    t_nodo_ll *aux;
    if ((header == NULL) || (header -> first == NULL)) {    
        return NULL;
    } else {
        aux = header -> first;
        while ((aux -> next != NULL) && (strcmp(nombre, aux -> nombre) != 0)) {
            aux = aux -> next;
        }
        if (strcmp(nombre, aux -> nombre) == 0) {
            return aux;
        }
    }
    return NULL;
}

// Podríamos tener distintos print en función del tipo de nodo (variable, etiqueta, función...)
void printVariable (t_nodo_ll *nodo) {
    printf("    El objeto es una variable\n");
    printf("    El tipo de la variable es : %s\n\n", nodo -> info -> tipo_variable);
}

/* MAIN */

int main (int argc, char** argv) {
    t_lista_ligada *lista = crearListaLigada();
    destroyListaLigada(lista);
    insertNodo("variable1", VARIABLE, lista);
    destroyListaLigada(lista);
    destroyListaLigada(lista);
    findNodo("variable1", VARIABLE, lista);
    insertNodo("variable1", VARIABLE, lista);
    findNodo("variable1", VARIABLE, lista);


    getInfoNodo("variable1", VARIABLE, lista);
    getInfoNodo("variable6", VARIABLE, lista);

    t_info_nodo *info = (t_info_nodo *)malloc(sizeof(t_info_nodo));
    info -> tipo_variable = (char *)malloc(sizeof(TAM_MAX_TIPO_VAR));
    strcpy(info -> tipo_variable, "boolean");

    addInfoNodo("variable1", VARIABLE, lista, info);
    getInfoNodo("variable1", VARIABLE, lista);

    addInfoNodo("variable6", VARIABLE, lista, info);

    destroyListaLigada(lista);
    destroyListaLigada(lista);

    insertNodo("variable1", VARIABLE, lista);
    insertNodo("variable2", VARIABLE, lista);
    insertNodo("variable3", VARIABLE, lista);
    insertNodo("variable4", VARIABLE, lista);
    insertNodo("variable5", VARIABLE, lista);
    insertNodo("variable6", VARIABLE, lista);

    printListaLigada(lista);
    destroyListaLigada(lista);
    printListaLigada(lista);
}