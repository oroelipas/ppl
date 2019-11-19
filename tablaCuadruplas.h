#include "tablaSimbolos.h"
/* CABECERA DEL MODULO tabla_quad */

#ifndef CM_OI_TABLA_CUADRUPLAS_H
#define CM_OI_TABLA_CUADRUPLAS_H
#define NUM_QUADS 64

typedef struct quad {
    int campo1;
    int campo2;
    int campo3;
    int campo4;
} quad;
//quitar struct????
typedef struct t_tabla_quad {
    struct quad t_quad [NUM_QUADS];
    int nextquad;
} t_tabla_quad;

/* DECLARACION DE FUNCIONES GLOBALES */
extern t_tabla_quad* crearTablaQuad();
extern void gen(t_tabla_quad* header, int operando, int elem1, int elem2, int resultado);
extern int addDestinoGoto(t_tabla_quad* header, int indice, int destino);
extern int getNextquad(t_tabla_quad* header);
extern void printTablaQuad(t_tabla_quad* header);
extern void escribirTablaCuadruplas(lista_ligada* tablaSimbolos, t_tabla_quad* tablaCuadruplas, FILE *file);
#endif
