
/* DEFINICION DEL MODULO tabla_quad */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "tablaCuadruplas.h"
#include "defines.h"
#include <string.h>

/* DECLARACION DE FUNCIONES ESTATICAS */
static int getCampo1(t_tabla_quad* header, int indice);
static int getCampo2(t_tabla_quad* header, int indice);
static int getCampo3(t_tabla_quad* header, int indice);
static int getCampo4(t_tabla_quad* header, int indice);
static void printQuad(t_tabla_quad* header, int indice);
static int modificaCampoQuad(t_tabla_quad* header, int indice, int num_campo, int nuevo_valor);

/* DEFINICION DE FUNCIONES ESTATICAS */
int getCampo1(t_tabla_quad* header, int indice) {
    return header -> t_quad[indice].campo1;
}

int getCampo2(t_tabla_quad* header, int indice) {
    return header -> t_quad[indice].campo2;
}

int getCampo3(t_tabla_quad* header, int indice) {
    return header -> t_quad[indice].campo3;
}

int getCampo4(t_tabla_quad* header, int indice) {
    return header -> t_quad[indice].campo4;
}

void printQuad(t_tabla_quad* header, int indice) {
    printf("    Contenido de la cuadrupla número %d:\n", indice);
    printf("        operando:  %d\n", getCampo1(header, indice));
    printf("        elemento1: %d\n", getCampo2(header, indice));
    printf("        elemento2: %d\n", getCampo3(header, indice));
    printf("        resultado: %d\n", getCampo4(header, indice));
    printf("\n");
}

int modificaCampoQuad(t_tabla_quad* header, int indice, int num_campo, int nuevo_valor) {
    switch (num_campo) {
        case 1:
            header -> t_quad[indice].campo1 = nuevo_valor;
            break;
        case 2:
            header -> t_quad[indice].campo2 = nuevo_valor;
            break;        
        case 3:
            header -> t_quad[indice].campo3 = nuevo_valor;
            break;        
        case 4:
            header -> t_quad[indice].campo4 = nuevo_valor;
            break;
        default:
            return 0;
    }
    return 1;
}

/* DECLARACION DE FUNCIONES GLOBALES */
t_tabla_quad* crearTablaQuad();
void gen(t_tabla_quad* header, int operando, int elem1, int elem2, int resultado);
int addDestinoGoto(t_tabla_quad* header, int indice, int destino);
int getNextquad(t_tabla_quad* header);

/* DEFINICION DE FUNCIONES GLOBALES */
t_tabla_quad* crearTablaQuad() {
    t_tabla_quad* header = (t_tabla_quad*)malloc(sizeof(t_tabla_quad));
    header -> nextquad = 0;
    return header;
}

void gen(t_tabla_quad* header, int operando, int elem1, int elem2, int resultado) {
    header -> t_quad[header -> nextquad].campo1 = operando;
    header -> t_quad[header -> nextquad].campo2 = elem1;
    header -> t_quad[header -> nextquad].campo3 = elem2;
    header -> t_quad[header -> nextquad].campo4 = resultado;
    header -> nextquad = (header -> nextquad) + 1;
}

int addDestinoGoto(t_tabla_quad* header, int indice, int destino) {
    if(getCampo4(header, indice) == -1) {
        modificaCampoQuad(header, indice, 4, destino);
        return 1;
    } else {
        return 0;
    }
}

int getNextquad(t_tabla_quad* header) {
    return header -> nextquad;
}

void printTablaQuad(t_tabla_quad* header) {
    printf("Contenido tabla de cuadruplas:\n");
    int i = 0;
    while(i < getNextquad(header)) {
        printQuad(header, i);
        i++;
    }
}


void index2Name(char *name, lista_ligada *tablaSimbolos, int index){
    if(index == -1){
        strcpy(name, "NULL");
    }else{
        strcpy(name, getNombreSimbolo(getSimboloPorId(tablaSimbolos, index)));
    }
}

int op_es_goto(const char *pre)
{
    return strncmp(pre, "GOTO", strlen("GOTO")) == 0;
}

void escribirTablaCuadruplas(lista_ligada *tablaSimbolos, t_tabla_quad *tablaCuadruplas, FILE *file){
    char *operacion;
    char operando1[TAM_MAX_NOMBRE_SIMBOLO];
    char operando2[TAM_MAX_NOMBRE_SIMBOLO];
    char destino[TAM_MAX_NOMBRE_SIMBOLO];
    int i = 0;
    while(i < getNextquad(tablaCuadruplas)) {

        operacion = getName(getCampo1(tablaCuadruplas,i));
        index2Name(operando1, tablaSimbolos, getCampo2(tablaCuadruplas,i));
        index2Name(operando2, tablaSimbolos, getCampo3(tablaCuadruplas,i));
        if(op_es_goto(operacion)){
            sprintf(destino, "%i", getCampo4(tablaCuadruplas,i));
        }else{
            index2Name(destino, tablaSimbolos, getCampo4(tablaCuadruplas,i));
        }
        fprintf(file, "%i: (%s,  %s,  %s,  %s)\n", i, operacion, operando1, operando2, destino);
        i++;
    }
}

void insertarInputEnTablaCuadruplas(t_tabla_quad* tablaCuadruplas, lista_ligada* header) {
    simbolo *misimbolo = header -> first;
    while (misimbolo != NULL) {
        printf("INPUT: %s\n", misimbolo -> nombre);
        gen(tablaCuadruplas, INPUT, -1, -1, misimbolo -> id);
        misimbolo = misimbolo -> next;
    }
}

void insertarOutputEnTablaCuadruplas(t_tabla_quad* tablaCuadruplas, lista_ligada* header) {
    simbolo *misimbolo = header -> first;
    while (misimbolo != NULL) {
        printf("OUTPUT: %s\n", misimbolo -> nombre);
        gen(tablaCuadruplas, OUTPUT, -1, -1, misimbolo -> id);
        misimbolo = misimbolo -> next;
    }
}