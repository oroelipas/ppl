
/*  MÓDULO QUE IMPLEMENTA UNA LISTA LIGADA DE SIMBOLOS
	Autores: Oroel Ipas y Carlos Moyano */

// Si queremos printear todas las operaciones de la lista poner DEBUG_MODE A 1, sino a 0
#define DEBUG_MODE 0
#if DEBUG_MODE
    #define debugFile stdout
#else
    #define debugFile fopen("/dev/null","w")
#endif

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "defines.h"
#include <string.h>
#include "tablaSimbolos.h"

// DECLARACIÓN DE FUNCIONES ESTÁTICAS
static void liberarSimbolo (simbolo* misimbolo);
static int esTipoBase (int tipo);
static void printInfosimbolo (simbolo *simbolo);
static int existeNombresimbolo (lista_ligada *header, char* nombre);
static simbolo* crearSimbolo (char *nombre, int tipo);

// DEFINCIÓN DE FUNCIONES ESTÁTICAS

/**
* Funcionalidad: Libera el espacio en memoria del simbolo que se pasa como parámetro.
* Se libera todo el espacio que el simbolo y su info ocupan.
* Parámetros: 
*	simbolo* misimbolo -> el símbolo cuyo espacio en memoria queremos liberar
* Return: void
*/
void liberarSimbolo (simbolo* misimbolo) {
    switch(misimbolo -> tipo) {
        case SIM_VARIABLE:
            break;
        case SIM_TIPO:
            free(misimbolo->info.t2.info);
            break;
        case SIM_FUNCION:
            free(misimbolo->info.t3.ent);
            free(misimbolo->info.t3.sal);
            break;
    }
    free(misimbolo);
}

/**
* Funcionalidad: Comprueba si el id que se pasa como parámetro pertenece a alguno de los tipos básicos del lenguaje.
* Parámetros: 
*	int id -> id a comprobar
* Return:
* 	1 -> el id pertenece a un tipo básico del lenguaje
*	0 -> el id no pertenece a un tipo básico del lenguaje
*/
int esTipoBase (int id) {
    return id < 6;
}

/**
* Funcionalidad: Imprime en pantalla toda la información del simbolo que se pasa como parámetro.
* Parámetros: 
*	simbolo* misimbolo -> simbolo cuya información queremos mostrar por pantalla
* Return: void
*/
void printInfosimbolo (simbolo *misimbolo) {
    printf("Id: %i, Nombre: %s\n", misimbolo->id, misimbolo -> nombre);
    switch(misimbolo->tipo) {
        case SIM_VARIABLE:
            printf("    El objeto es una variable\n");
            printf("    El tipo de la variable es : %i\n\n", misimbolo -> info.t1.tipo_variable);
            break;
        case SIM_TIPO:
            printf("    El objeto es un tipo\n");
            /*if( misimbolo -> info.t2 != NULL){
                printf("    El tipo del tipo es: %s\n\n", misimbolo -> info.t2.tipo_tipo);
            }*/
            break;
        case SIM_FUNCION:
            printf("    El objeto es una funcion\n");
            /*if( misimbolo -> info.t3 != NULL){
                printf("    Los parametros de entrada son: %s\n", misimbolo -> info.t3 -> ent);
                printf("    Los parametros de salida son: %s\n\n", misimbolo -> info.t3 -> sal);
            }*/                  
            break;
    }
}

/**
* Funcionalidad: Inserta un nuevo simbolo en la tabla de simbolos.
* Parámetros: 
*	lista_ligada* header -> referencia a la tabla de simbolos
*	simbolo* misimbolo -> simbolo a insertar
* Return:
*   - 1 	 -> inserción incorrecta del simbolo
*	  X >= 0 -> id del simbolo insertado correctamente
*/
int insertarSimbolo (lista_ligada *header, simbolo* misimbolo){
    if (existeNombresimbolo(header, misimbolo->nombre)) {
        fprintf(debugFile, "EL OBJETO '%s' ya estaba en la lista\n", misimbolo->nombre);
        return -1;
    }
    misimbolo -> next = header ->first;
    misimbolo -> id = header -> contador;
    header -> contador ++;
    header -> first = misimbolo;
    fprintf(debugFile, "Inserción CORRECTA del objeto de nombre : %s\n", misimbolo->nombre);
    return header -> contador - 1;
}

/**
* Funcionalidad: Comprueba si el nombre del simbolo que se pasa como parámetro existe ya en la tabla de simbolos.
* Parámetros: 
*	char* nombre -> nombre del simbolo a comprobar
* Return:
*	1 -> el simbolo existe en la tabla de simbolos
*	0 -> el simbolo no existe en la tabla de simbolos
*/
int existeNombresimbolo (lista_ligada *header, char* nombre) {
    if (getSimboloPorNombre(header, nombre) != NULL) {
        fprintf(debugFile, "El objeto de nombre [%s] se encuentra en la lista\n", nombre);
        return 1;
    } else {
        fprintf(debugFile, "El objeto de nombre [%s] no se encuentra en la lista\n", nombre);
        return 0;
    }
}

/**
 * Funcionalidad: Crea un nuevo simbolo y devuelve una referencia a él. Inicialmente el simbolo se marca como no usado.
 * Parámetros:
 *   char* nombre -> nombre del simbolo
 * 	 int tipo -> tipo del simbolo (Ej: variable, tipo, funcion...). Se usan las macros de define.h
 * Return: referencia al nuevo simbolo que se acabada de crear.
 */
simbolo* crearSimbolo(char *nombre, int tipo) {
    simbolo *nuevo = (simbolo *)malloc(sizeof(simbolo));
    nuevo -> usado = 0;
    nuevo -> nombre = (char *)malloc(sizeof(char) * TAM_MAX_NOMBRE_SIMBOLO);
    if (strlen(nombre) <= TAM_MAX_NOMBRE_SIMBOLO) {
        strcpy(nuevo -> nombre, nombre);
        nuevo -> tipo = tipo;
        nuevo -> next = NULL;
        // No reservamos memoria para la info de momento
    } else {
        fprintf(debugFile, "Creacion de simbolo incorrecta: Nombre demasiado largo %s\n", nombre);
        return NULL;
    }
    return nuevo;
}
/////////////////////////////////////////////////////////////////////////////////////////////////

// DECLARACIÓN DE FUNCIONES GLOBALES
extern lista_ligada* crearListaLigada();
extern lista_ligada* crearTablaDeSimbolos();
extern simbolo* pop (lista_ligada *header);
extern void vaciarListaLigada (lista_ligada *header);
extern void vaciarTablaSimbolos (lista_ligada *header);
extern void printListaLigada (lista_ligada *header);
extern void printSimbolosNoUsados (lista_ligada *header);
extern int consulta_bpw_TS (lista_ligada *header, int id);
extern simbolo* newTemp (lista_ligada *header);
extern void marcarComoUsado (simbolo *misimbolo);
extern void addNombreSimbolo (lista_ligada *header, int id, char* nombre);
extern simbolo* getSimboloPorId (lista_ligada *header, int id);
extern simbolo* getSimboloPorNombre (lista_ligada *header, char* nombre);
extern char *getNombreSimbolo (simbolo* misimbolo);
extern int getTipoSimbolo (simbolo* misimbolo);
extern int getIdSimbolo (simbolo* misimbolo);
extern int simboloEsUnaVariable (simbolo* misimbolo);
extern simbolo* insertarVariable (lista_ligada *header, char *nombre, int tipo);
extern int insertarSimbolo (lista_ligada *header, simbolo* misimbolo);
extern void modificaTipoVar (simbolo* var, int tipo_var);
extern infoTipo* crearInfoTipoDeTabla (int tipoContenido, int cuadruplaQueCalculaSuLongitud);
extern infoTipo* crearInfoTipoBasico (int btw);
extern simbolo* insertarTipo (lista_ligada *header, infoTipo* info);
extern void addInfoTipo (simbolo* s, infoTipo* info);
extern int simboloEsUnTipo (simbolo* misimbolo);
extern int simboloEsUnaVariable (simbolo* misimbolo);
extern char* getNombreTipoContenidoVariableTabla (lista_ligada *header, simbolo* misimbolo);
extern int getIdTipoContenidoVariableTabla (lista_ligada *header, simbolo* misimbolo);
extern int getTipoVar (simbolo* misimbolo);

// DEFINICIÓN DE FUNCIONES GLOBALES

/**
 * Funcionalidad: Crea una lista ligada de símbolos vacia y devuelve una referencia a ella.
 * Parámetros: none
 * Return: referencia a la lista ligada de simbolos que se acaba de crear
 */
lista_ligada* crearListaLigada() {
    lista_ligada *lista = (lista_ligada *)malloc(sizeof(lista_ligada));
    lista -> first = NULL;
    lista -> contador = 0;
    return lista;
}

/**
 * Funcionalidad: Crea una lista ligada de símbolos vacia y devuelve una referencia a ella. La diferencia con crearListaLigada
 * es que en esta función se insertan en la nueva lista, que es la tabla de simbolos, los tipos básicos del lenguaje en las primeras
 * 5 posiciones.
 * Parámetros: none
 * Return: referencia a la lista ligada de simbolos que se acaba de crear
 */
lista_ligada* crearTablaDeSimbolos() {
    lista_ligada *lista = crearListaLigada();
    //TODO: ESTO ES UNA CHAPUZAAAAAAAAA!!!!!!
    char* nombres_tipos_base[5];
    nombres_tipos_base[ENTERO] = "entero";
    nombres_tipos_base[REAL] = "real";
    nombres_tipos_base[BOOLEANO] = "booleano";
    nombres_tipos_base[CARACTER] = "caracter";
    nombres_tipos_base[CADENA] = "cadena";
    int id;
    infoTipo* info = crearInfoTipoBasico(BTW_GENERICO);
    for(int i=0; i < sizeof(nombres_tipos_base) / sizeof(nombres_tipos_base[0]); i++){
        simbolo *nuevoTipo = crearSimbolo(nombres_tipos_base[i], SIM_TIPO);
        id = insertarSimbolo(lista, nuevoTipo);
        addInfoTipo(nuevoTipo, info);
    }
    return lista;
}

/**
 * Funcionalidad: Añade información al simbolo de tipo 2 (un tipo del lenguaje) que se pasa como parámetro.
 * Parámetros:
 *   simbolo* s -> simbolo al que queremos añadirle información
 *   infoTipo* info -> información que queremos añadir
 * Return: void
 */
void addInfoTipo(simbolo* s, infoTipo* info) {
	if (simboloEsUnTipo(s)) {
    	s -> info.t2.info = info;
    }
}

/**
 * Funcionalidad: Crea un simbolo de tipo 1 (SIM_VARIABLE) de nombre Tx, siendo x el id del simbolo. Después
 * lo inserta en la tabla de simbolos.
 * Parámetros:
 *   lista_ligada* header -> referencia a la tabla de simbolos
 * Return: referencia al nuevo simbolo de tipo 1 insertado en la tabla de simbolos
 */
simbolo* newTemp(lista_ligada *header){
    int id = header->contador;
    char nombre[TAM_NOMBRE_T];
    sprintf(nombre,"T%i", id);
    simbolo* T =  insertarVariable(header, nombre, SIM_SIN_TIPO);
    marcarComoUsado(T);
    return T;
}

/**
 * Funcionalidad: Inserta un nuevo simbolo de tipo 1 (SIM_VARIABLE) con un nombre determinado en la tabla de 
 * simbolos, si no existe uno con el mismo nombre.
 * Parámetros:
 *   lista_ligada* header -> referencia a la tabla de simbolos
 *   char* nombre 		  -> nombre de la variable a insertar
 *	 int tipo 			  -> tipo de la variable a insertar (no confundir con tipo de simbolo, son cosas
 *							  totalmente distintas)
 * Return: referencia al simbolo cuyo nombre se ha pasado como parametro
 */
simbolo* insertarVariable(lista_ligada* header, char* nombre, int tipo){
    simbolo* nuevaVar = crearSimbolo(nombre, SIM_VARIABLE);
    nuevaVar -> info.t1.tipo_variable = tipo;
    insertarSimbolo(header, nuevaVar);
    return nuevaVar;
}

/**
 * Funcionalidad: Crea una estructura del tipo infoTipo para una tabla y devuelve una referencia a ella.
 * Parámetros:
 *   int tipoContenido 					-> tipo que contiene la tabla
 *	 int cuadruplaQueCalculaSuLongitud	-> numero de cuadrupla en la que se calcula la longitud del array (necesario debido
 *											nuestro compilador no maneja asignaciones a literales)
 *
 * Return:  referencia a la estructura de tipo infoTipo que se acaba de crear
 */
infoTipo* crearInfoTipoDeTabla (int tipoContenido, int cuadruplaQueCalculaSuLongitud) {
    // De una tabla nos interesa almacenar el tipo de los elementos que contiene y su longitud (solo dejamos que tengan 1 dimensión)
    infoTipo* info = (infoTipo*)malloc(sizeof(infoTipo));
    info -> quadLen = cuadruplaQueCalculaSuLongitud;
    info -> tipoContenido = tipoContenido;
    info -> btw = BTW_VACIO;
}

/**
 * Funcionalidad: Crea una estructura del tipo infoTipo para un tipo básico del lenguaje y devuelve una referencia a ella.
 * Parámetros:
 *   int btw -> tamaño en bytes que ocupa el tipo básico cuya información vamos a crear
 *
 * Return:  referencia a la estructura de tipo infoTipo que se acaba de crear
 */
infoTipo* crearInfoTipoBasico (int btw) {
    // De un tipo básico nos interesa almacenar su btw
    infoTipo* info = (infoTipo*)malloc(sizeof(infoTipo));
    info -> btw = btw;
}

/**
 * Funcionalidad: Inserta un nuevo simbolo de tipo 2 (SIM_TIPO) sin nombre en la tabla de 
 * simbolos, si no existe uno con el mismo nombre. Se le añade la información que se pasa
 * como parámetro. LA GRAMATICA DE NUESTRO LENGUAJE NOS OBLIGA A TENER QUE INSERTAR TIPOS
 * SIN NOMBRE Y DARLES NOMBRE EN LA SIGUIENTE REDUCCION.
 * Parámetros:
 *   lista_ligada* header -> referencia a la tabla de simbolos
 *   infoTipo* info 	  -> información del tipo que se va a insertar en la tabla de simbolos
 *
 * Return: referencia al simbolo insertado
 */
simbolo* insertarTipo (lista_ligada *header, infoTipo* info) {
    simbolo *nuevoTipo = crearSimbolo("TIPO_SIN_NOMBRE", SIM_TIPO);
    nuevoTipo -> info.t2.info = info;
    int id = insertarSimbolo(header, nuevoTipo);
    return getSimboloPorId(header, id);  
}

/**
 * Funcionalidad: Cambia el nombre de un simbolo con una id determinada al nombre que
 * se pasa como parámetro.
 * Parámetros:
 *   lista_ligada* header -> referencia a la tabla de simbolos
 *	 int id 			  -> id del simbolo cuyo nombre queremos cambiar
 *   char* nombre 	  	  -> nuevo nombre que queremos darle al simbolo
 *
 * Return: void
 */
void addNombreSimbolo (lista_ligada *header, int id, char* nombre) {
    simbolo* aux = getSimboloPorId(header, id);
    if (aux != NULL)
        aux -> nombre = nombre;
}

/**
 * Funcionalidad: Busca en la tabla de simbolos un simbolo cuyo nombre coincida
 * con el que se pasa como parámetro y devuelve una referencia a él si lo
 * encuentra.
 * Parámetros:
 *   lista_ligada* header -> referencia a la tabla de simbolos
 *   char* nombre 	  	  -> nombre del simbolo que queremos buscar en la tabla de simbolos
 *
 * Return:
 *   NULL 						   -> si el simbolo no se ha encontrado
 *   Puntero al simbolo encontrado -> si el simbolo se ha encontrado
 */
simbolo* getSimboloPorNombre (lista_ligada *header, char* nombre) {
    if (header -> first == NULL) {
        return NULL;
    }
    simbolo *misimbolo;
    misimbolo = header -> first;//busqueda del simbolo
    while ((misimbolo -> next != NULL) && (strcmp(nombre, misimbolo -> nombre) != 0)) {
        misimbolo = misimbolo -> next;
    }
    if (strcmp(nombre, misimbolo -> nombre) == 0) {
        return misimbolo;
    } else {
        return NULL;
    }
}

/**
 * Funcionalidad: Busca en la tabla de simbolos un simbolo cuyo id coincida
 * con el que se pasa como parámetro y devuelve una referencia a él si lo
 * encuentra.
 * Parámetros:
 *   lista_ligada* header -> referencia a la tabla de simbolos
 *   int id 	  	  	  -> id del simbolo que queremos buscar en la tabla de simbolos
 *
 * Return:
 *   NULL 						   -> si el simbolo no se ha encontrado
 *   Puntero al simbolo encontrado -> si el simbolo se ha encontrado
 */
simbolo* getSimboloPorId (lista_ligada *header, int id) {
    if (header -> first == NULL) {
        return NULL;
    }
    simbolo *misimbolo;
    misimbolo = header -> first;
    while ((misimbolo -> next != NULL) && (misimbolo -> id != id)) {
        misimbolo = misimbolo -> next;
    }
    if (misimbolo -> id == id) {
        return misimbolo;
    } else {
        return NULL;
    }
}

/**
 * Funcionalidad: devuelve el tipo del simbolo que se pasa como parametro
 */
int getTipoSimbolo(simbolo* misimbolo) {
    return misimbolo -> tipo;
}

/**
 * Funcionalidad: devuelve el nombre del simbolo que se pasa como parametro
 */
char *getNombreSimbolo(simbolo* misimbolo) {
    return misimbolo -> nombre;
}

/**
 * Funcionalidad: Modifica el tipo del la variable (simbolo de tipo SIM_VARIABLE) que se pasa como parametro
 * Parámetros:
 *   simbolo* var -> referencia a la variable cuyo tipo queremos modificar
 *   int tipo_vat -> id del simbolo que contiene el tipo por el que queremos modificar el tipo de lavariable
 *
 * Return: void
 */
void modificaTipoVar(simbolo* var, int tipo_var) {
    if (getTipoSimbolo(var) == SIM_VARIABLE) {
        var -> info.t1.tipo_variable = tipo_var;
    } else {
        printf("ERROR: Esta intentando cambiar el tipo de variable de un simbolo que no es una variable\n");
    }
}

/**
 * Funcionalidad: devuelve el tipo de la variable (simbolo de tipo SIM_VARIABLE) que se pasa como parametro
 */
int getTipoVar (simbolo* misimbolo) {
    if (simboloEsUnaVariable(misimbolo)) {
        return misimbolo->info.t1.tipo_variable;
    }
}

/**
 * Funcionalidad: Modifica el tipo del la variable (simbolo de tipo SIM_VARIABLE) que se pasa como parametro
 * Parámetros:
 *   simbolo* var -> referencia a la variable cuyo tipo queremos modificar
 *   int tipo_vat -> id del simbolo que contiene el tipo por el que queremos modificar el tipo de lavariable
 *
 * Return: void
 */
char* getNombreTipoContenidoVariableTabla (lista_ligada *header, simbolo* misimbolo) {
    if(simboloEsUnaVariable(misimbolo)) {
        simbolo* aux1 = getSimboloPorId(header, misimbolo->info.t1.tipo_variable);
        simbolo* aux2 = getSimboloPorId(header, aux1 -> info.t2.info -> tipoContenido);
        return getNombreSimbolo(aux2);
    }
}

/**
 * Funcionalidad: Modifica el tipo del la variable (simbolo de tipo SIM_VARIABLE) que se pasa como parametro
 * Parámetros:
 *   simbolo* var -> referencia a la variable cuyo tipo queremos modificar
 *   int tipo_vat -> id del simbolo que contiene el tipo por el que queremos modificar el tipo de lavariable
 *
 * Return: void
 */
int getIdTipoContenidoVariableTabla (lista_ligada *header, simbolo* misimbolo) {
    if(simboloEsUnaVariable(misimbolo)) {
        simbolo* aux1 = getSimboloPorId(header, misimbolo->info.t1.tipo_variable);
        simbolo* aux2 = getSimboloPorId(header, aux1 -> info.t2.info -> tipoContenido);
        return aux2 -> id;
    }
}

/**
 * Funcionalidad: Consulta el bpw del simbolo de tipo SIM_TIPO cuya id se pasa como parámetro
 * Parámetros:
 *   lista_ligada* header -> referencia a la tabla de simbolos
 *   int id -> id del simbolo de tipo SIM_TIPO cuyo bpw queremos obtener
 *
 * Return:
 * 	 -1 	-> la id que se ha pasado como parametro no pertenece a un simbolo de tipo SIM_TIPO
 * 	  X > 0 -> bpw del simbolo de tipo SIM_TIPO cuya id se ha pasado como parámetro
 */
int consulta_bpw_TS (lista_ligada *header, int id) {
    simbolo* aux = getSimboloPorId(header, id);
    if (simboloEsUnTipo(aux)) {
    	return aux -> info.t2.info -> btw;
    } else {
    	return -1;
    }
};

/**
 * Funcionalidad: Indica que el simbolo que se pasa como parámetro ha sido utilizado en el codigo
 * Return: void
 */
void marcarComoUsado (simbolo *misimbolo) {
    misimbolo -> usado = 1;
}

/**
 * Funcionalidad: Vacia la lista, haciendo que su first apunte a NULL.
 * Libera todo el espacio que ocupaban los elementos de la lista
 * Parámetros:
 *   lista_ligada* header -> referencia a la lista ligada
 *
 * Return: void
 */
void vaciarListaLigada (lista_ligada *header) {
    if (header -> first == NULL) {
        fprintf(debugFile, "VaciarListaLigada: La lista YA estaba vacía\n");
    } else {
        simbolo *auxant = NULL;
        simbolo *aux = header -> first;
        while (aux -> next != NULL) {
            auxant = aux;
            aux = aux -> next;
            liberarSimbolo(auxant);
        }
        liberarSimbolo(aux);
        header -> first = NULL;
    }
}

/**
 * Funcionalidad: Vacia la tabla de simbolos, haciendo que su first apunte a NULL.
 * Libera todo el espacio que ocupaban los elementos de la lista
 * Parámetros:
 *   lista_ligada* header -> referencia a la tabla de simbolos
 *
 * Return: void
 */
void vaciarTablaSimbolos (lista_ligada *header) {
    vaciarListaLigada(header);
}

/**
 * Funcionalidad: Devuelve el primer simbolo de la lista y lo elimina de la misma.
 * Es especialmente útil cuando se quiere sacar todos los elementos de una lista uno a uno.
 * Parámetros:
 *   lista_ligada* header -> referencia a la lista ligada
 *
 * Return:
 *	 NULL    -> si la lista ligada esta vacía
 *   simbolo -> si la lista ligada no está vacía
 */
simbolo* pop (lista_ligada *header) {
    if (header -> first != NULL) {
        simbolo* misimbolo = header -> first;
        header -> first = header -> first -> next;
        misimbolo -> next = NULL;
        return misimbolo;
    } else {
        return NULL;
    }
}

/**
* Funcionalidad: Imprime el contenido de la lista y llama a funciones que imprimen por pantalla la info de los simbolos.
*/
void printListaLigada (lista_ligada *header) {
    printf("---------------------------------------------------------\n");
    printf("CONTADOR DE LA LISTA:%i\n",header->contador);
    printf("Contenido Lista Ligada:\n");
    simbolo *misimbolo = header -> first;
    while (misimbolo != NULL) {
        printInfosimbolo(misimbolo);
        misimbolo = misimbolo -> next;
    }
}

/**
 * Funcionalidad: Al final del parseo, notifica queé simbolos fueron declarados y nunca usados.
 */
void printSimbolosNoUsados(lista_ligada *header) {
    simbolo *misimbolo = header -> first;
    while (misimbolo  != NULL) {
        if (misimbolo->usado == 0) {
            switch(misimbolo->tipo) {
                case SIM_VARIABLE:
                    warningSinLinea("Variable %s %s declarada y nunca usada\n", getNombreSimbolo(getSimboloPorId(header, getTipoVar(misimbolo))), getNombreSimbolo(misimbolo));
                    break;
                case SIM_TIPO:
                    if(!esTipoBase(misimbolo->id))
                        warningSinLinea("Tipo %s declarado y nunca usado\n", getNombreSimbolo(misimbolo));
                    break;
                case SIM_FUNCION:
                    warningSinLinea("Funcion %s declarada y nunca usada\n", getNombreSimbolo(misimbolo));
                    break;
            }
        }
        misimbolo = misimbolo -> next;
    }
}

/**
* Funcionalidad: Comprueba si el simbolo que se pasa como parametro es de tipo SIM_TIPO
* Parámetros: 
*	simbolo* misimbolo -> simbolo a comprobar
* Return:
* 	1 -> el simbolo es un tipo
*	0 -> el simbolo no es un tipo
*/
int simboloEsUnTipo(simbolo* misimbolo) {
    return misimbolo -> tipo == SIM_TIPO;
}

/**
* Funcionalidad: Comprueba si el simbolo que se pasa como parámetro es una variable.
* Parámetros: 
*	simbolo* misimbolo -> simbolo a comprobar
* Return:
* 	1 -> el simbolo es una variable
*	0 -> el simbolo no es una variable
*/
int simboloEsUnaVariable (simbolo* misimbolo) {
    return misimbolo->tipo == SIM_VARIABLE;
}

/**
 * Funcionalidad: Devuelve la id del simbolo que se pasa como parámetro.
 */
int getIdSimbolo(simbolo* misimbolo) {
    return misimbolo -> id;
}