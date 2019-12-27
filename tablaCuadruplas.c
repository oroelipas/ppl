
/*  DEFINICION DEL MODULO tabla_quad 
	Autores: Oroel Ipas y Carlos Moyano */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "tablaCuadruplas.h"
#include "defines.h"
#include <string.h>

// DECLARACION DE FUNCIONES ESTATICAS
static int getCampo1 (t_tabla_quad* header, int indice);
static int getCampo2 (t_tabla_quad* header, int indice);
static int getCampo3 (t_tabla_quad* header, int indice);
static int getCampo4 (t_tabla_quad* header, int indice);
static void printQuad (t_tabla_quad* header, int indice);
static int modificaCampoQuad (t_tabla_quad* header, int indice, int num_campo, int nuevo_valor);

// DEFINICION DE FUNCIONES ESTATICAS

/* 
* Funcionalidad: Devuelve el contenido del campo1 de una cuadrupla determinada.
*/
int getCampo1 (t_tabla_quad* header, int indice) {
    return header -> t_quad[indice].campo1;
}

/* 
* Funcionalidad: Devuelve el contenido del campo2 de una cuadrupla determinada.
*/
int getCampo2 (t_tabla_quad* header, int indice) {
    return header -> t_quad[indice].campo2;
}

/* 
* Funcionalidad: Devuelve el contenido del campo3 de una cuadrupla determinada.
*/
int getCampo3 (t_tabla_quad* header, int indice) {
    return header -> t_quad[indice].campo3;
}

/* 
* Funcionalidad: Devuelve el contenido del campo4 de una cuadrupla determinada.
*/
int getCampo4 (t_tabla_quad* header, int indice) {
    return header -> t_quad[indice].campo4;
}

/* 
* Funcionalidad: Muestra por pantalla el contenido de una cuadrupla determinada.
*/
void printQuad (t_tabla_quad* header, int indice) {
    printf("    Contenido de la cuadrupla número %d:\n", indice);
    printf("        operando:  %d\n", getCampo1(header, indice));
    printf("        elemento1: %d\n", getCampo2(header, indice));
    printf("        elemento2: %d\n", getCampo3(header, indice));
    printf("        resultado: %d\n", getCampo4(header, indice));
    printf("\n");
}

/* 
* Funcionalidad: Modifica el contenido de un campo determinado de una cuadrupla determinada.
*/
int modificaCampoQuad (t_tabla_quad* header, int indice, int num_campo, int nuevo_valor) {
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
/////////////////////////////////////////////////////////////////////////////////////////////////

// DECLARACION DE FUNCIONES GLOBALES
t_tabla_quad* crearTablaQuad();
void gen (t_tabla_quad* header, int operando, int elem1, int elem2, int resultado);
int addDestinoGoto (t_tabla_quad* header, int indice, int destino);
int getNextquad (t_tabla_quad* header);
void printTablaQuad (t_tabla_quad* header);
void escribirTablaCuadruplas (lista_ligada* tablaSimbolos, t_tabla_quad* tablaCuadruplas, FILE *file);
void insertarOutputEnTablaCuadruplas (t_tabla_quad* tablaCuadruplas, lista_ligada* tablaSimbolos, t_lista_ligada_int* output);
void insertarInputEnTablaCuadruplas (t_tabla_quad* tablaCuadruplas, simbolo *var);

// DEFINICION DE FUNCIONES GLOBALES

/*
 * Funcionalidad: Crea una tabla de cuadruplas vacía y devuelve una referencia a la misma.
 */
t_tabla_quad* crearTablaQuad() {
    t_tabla_quad* header = (t_tabla_quad*)malloc(sizeof(t_tabla_quad));
    header -> nextquad = 0;
    return header;
}

/*
 * Funcionalidad: Genera una nueva cuadrupla en la tabla de cuadruplas cuya referencia se pasa como parámetro.
 * Parámetros:
 * 	 t_tabla_quad* header -> referencia a la tabla de cuadruplas
 *	 int operando 		  -> código del operando
 *	 int elem1 			  -> id del simbolo que contiene el valor necesario
 *	 int elem2 			  -> id del simbolo que contiene el valor necesario
 *	 int resultado 		  -> id del simbolo que recibirá el resultado de la operación
 *
 * Return: void
 */
void gen (t_tabla_quad* header, int operando, int elem1, int elem2, int resultado) {
    header -> t_quad[header -> nextquad].campo1 = operando;
    header -> t_quad[header -> nextquad].campo2 = elem1;
    header -> t_quad[header -> nextquad].campo3 = elem2;
    header -> t_quad[header -> nextquad].campo4 = resultado;
    header -> nextquad = (header -> nextquad) + 1;
}

/*
 * Funcionalidad: Añade un destino a una operación goto, asignando contenido al campo4 de la cuadrupla que lo contiene si este se
 * encuentra vacío (tiene valor -1).
 * Parámetros:
 * 	 t_tabla_quad* header -> referencia a la tabla de cuadruplas
 *	 int operando 		  -> código del operando
 *	 int indice 		  -> indice de la cuadrupla a la que queremos añadirle el destino
 *	 int destino 		  -> indice de la cuadrupla que es el destino de la operación goto
 *
 * Return: 
 * 	  1 -> si la cuadrupla cuyo campo4 queremos modificar tenía el campo vacío (y por lo tanto se ha podido añadir el destino)
 *	  0 -> si la cuadrupla cuyo campo4 queremos modificar no tenía el campo vacío (y por lo tanto no se ha podido añadir el destino)
 */
int addDestinoGoto (t_tabla_quad* header, int indice, int destino) {
    if (getCampo4(header, indice) == -1) {
        modificaCampoQuad(header, indice, 4, destino);
        return 1;
    } else {
        return 0;
    }
}

/*
 * Funcionalidad: Devuelve el indice de la próxima cuadrupla que será escrita en la tabla de cuadruplas.
 */
int getNextquad (t_tabla_quad* header) {
    return header -> nextquad;
}

/*
 * Funcionalidad: Muestra por pantalla el contenido de la tabla de cuadruplas cuya referencia se pasa como parámetro.
 */
void printTablaQuad (t_tabla_quad* header) {
    printf("Contenido tabla de cuadruplas:\n");
    int i = 0;
    while (i < getNextquad(header)) {
        printQuad(header, i);
        i++;
    }
}

/*
 * Funcionalidad: Busca y copia el nombre de la variable cuya id es el valor de un campo de una cuadrupla de la tabla de cuadruplas.
 */
void index2Name (char *name, lista_ligada *tablaSimbolos, int index) {
    if (index == -1) {
        strcpy(name, "NULL");
    } else {
        strcpy(name, getNombreSimbolo(getSimboloPorId(tablaSimbolos, index)));
    }
}

/*
 * Funcionalidad: Nos dice si una operación cuyo nombre se pasa como parámetro es un salto (goto).
 */
int op_es_goto (const char *pre) {
    return strncmp(pre, "GOTO", strlen("GOTO")) == 0;
}

/*
 * Funcionalidad: Escribe el contenido de la tabla de cuadruplas en un fichero de texto en un formato legible.
 */
void escribirTablaCuadruplas (lista_ligada *tablaSimbolos, t_tabla_quad *tablaCuadruplas, FILE *file) {
    char *operacion;
    char operando1[TAM_MAX_NOMBRE_SIMBOLO];
    char operando2[TAM_MAX_NOMBRE_SIMBOLO];
    char destino[TAM_MAX_NOMBRE_SIMBOLO];
    int i = 0;
    int hayOpAlterada = 0;
    int n = getNextquad(tablaCuadruplas);
    while(i < n) {
        char* operacion = getNombreDeConstante(getCampo1(tablaCuadruplas,i));
        if ((getCampo1(tablaCuadruplas,i) != 700) && (getCampo1(tablaCuadruplas,i) != 701)) {
            index2Name(operando1, tablaSimbolos, getCampo2(tablaCuadruplas,i));
            index2Name(operando2, tablaSimbolos, getCampo3(tablaCuadruplas,i));
        } else {
            hayOpAlterada = 1;
            index2Name(operando1, tablaSimbolos, getCampo2(tablaCuadruplas,i));
            sprintf(operando1, "%s", operando1);
            sprintf(operando2, "%d", getCampo3(tablaCuadruplas,i));
        }
        if(op_es_goto(operacion)) {
            sprintf(destino, "%i", getCampo4(tablaCuadruplas, i));
        } else {
            index2Name(destino, tablaSimbolos, getCampo4(tablaCuadruplas, i));
        }
        fprintf(file, "%i: (%s,  %s,  %s,  %s)\n", i, operacion, operando1, operando2, destino);
        // printf("%i: (%s,  %s,  %s,  %s)\n", i, operacion, operando1, operando2, destino);
        i++;

    }
    if (hayOpAlterada) {
        fprintf(file, "\n\n\n\n\nNota informativa programa4.alg: En la(s) cuadrupla(s) con la operación MULT_ALTERADA, el campo 2 indica que el offset sería el valor de la variable cuyo nombre se indica.\nEn esta operación, ese offset es multiplicado por el bpw del tipo que contiene el array; hemos puesto 100 como bpw por defecto de todos los tipos básicos del\nlenguaje, por pura claridad a la hora de depurar. El motivo de que sea una multiplicación alterada es que estamos tomándonos una licencia para poder mezclar cifras\nque identifican variables de la tabla de símbolos (como es el caso del número en el segundo campo de la tupla que hace que se muestre la Tx correspondiente) con\ncifras que realmente tienen valor numérico (como es el caso del bpw del tercer campo de la cuadrupla). Este tercer campo también puede tomar valor numérico 1, como\nes el caso de la cuadrupla número 12.\n");
    	fprintf(file, "\n\n\nBreve explicación de lo que pasa de la cuadrupla 8 a la 15:\ncuadrupla 8 : Se le resta 1 al valor de la variable a (ya que lo que se quiere es acceder a la posición a - 1 en la primera dimensión del array).\ncuadrupla 9 : Se multiplica ese desplazamiento en la primera dimensión del array por lo que ocupa la segunda dimensión, que está calculado en T11.\ncuadrupla 10 : Se asigna el resultado de esa multiplicación entera comentada en la cuadrupla anterior a la variable T19.\ncuadrupla 11 : Se le resta 1 al valor de la variable b (ya que lo que se quiere es acceder a la posición b - 1 en la segunda dimensión del array).\ncuadrupla 12 : Se multiplica este desplazamiento por 1, ya que no hay tercera dimensión por la que multiplicar.\ncuadrupla 13 : Se suma el resultado de esta multiplicación a lo almacenado en T19 en la cuadrupla 10, el resultado se guarda otra vez en T19.\ncuadrupla 14 : Se multiplica lo almacenado en T19 por el btw del tipo entero que almacena el tipo de array al que pertenece array1.\ncuadrupla 15 : Se asigna el valor de la variable 'a' a la zona de memoria resultante de desplazar el contenido de la variable T19 sobre la variable array1.\n\n\n");
    }
}

/*
 * Funcionalidad: Inserta una variables de entrada del algoritmo que estamos parseando como operaciones INPUT en la tabla de cuadruplas.
 * Estas cuadruplas con operaciones INPUT deben ser las primeras de la tabla de cuadruplas que se genere (esto lo controlamos desde el parser).
 */
void insertarInputEnTablaCuadruplas (t_tabla_quad* tablaCuadruplas, simbolo *var){
    gen(tablaCuadruplas, INPUT, -1, -1, var -> id);
}

/*
 * Funcionalidad: Inserta las variables de salida del algoritmo que hemos parseado como operaciones OUTPUT en la tabla de cuadruplas.
 * Estas cuadruplas con operaciones OUTPUT deben ser las últimas de la tabla de cuadruplas que se genere (esto lo controlamos desde el parser).
 */
void insertarOutputEnTablaCuadruplas (t_tabla_quad* tablaCuadruplas, lista_ligada* tablaSimbolos, t_lista_ligada_int* output) {
    simbolo *misimbolo;
    int id;
    if (output -> first == NULL) {
        gen(tablaCuadruplas, OUTPUT, -1, -1, -1);
    } else {
        while (id = popListaIndices(output)) {
            misimbolo = getSimboloPorId(tablaSimbolos, id);
            gen(tablaCuadruplas, OUTPUT, -1, -1, misimbolo -> id);
	    }
    }
}
