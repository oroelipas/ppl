/* MÓDULO QUE IMPLEMENTA UNA LISTA LIGADA */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "defines.h"

#include <string.h>
#include "lista.h"


#define TAM_MAX_NOMBRE 50		// Número de caracteres máximo que podrá tener el nombre del objeto almacenado
#define TAM_MAX_TIPO_VAR 100 	// Número de caracteres máximo que podrá tener el nombre de un tipo de variable (tanto básico como definido por el usuario. Ej: entero, booleano, miTipo...)

//#define LENGTH(x)  (sizeof(x) / sizeof((x)[0]))igual esto es guay para la longitud de los arrays https://stackoverflow.com/questions/37538/how-do-i-determine-the-size-of-my-array-in-c

/*PONER "static" vendria a significar private. La funcion no sale de este fichero*/
lista_ligada* crearListaLigada();
lista_ligada* crearTablaDeSimbolos();

nodo *insertarVariable(lista_ligada *header, char *nombre, int tipo);
nodo* getSimboloPorNombre (lista_ligada *header, char* nombre);
int  existeNodo (lista_ligada *header, char* nombre);
info_nodo crearInfoVariable (int tipo_var);
info_nodo crearInfoTipo (char *tipo_tipo);
info_nodo crearInfoFunc (char *ent, char *sal);
void marcarComoUsado (nodo *minodo);
void addInfoNodo (nodo* minodo, info_nodo info);
int  addInfoNodoEnLista (lista_ligada *header, char* nombre, info_nodo info);
info_nodo getInfoNodo (nodo* minodo);
info_nodo getInfoNodoEnLista (lista_ligada *header, char* nombre);
int   getTipo (nodo* minodo);
char *getNombreSimbolo (nodo* minodo);
void vaciarLista (lista_ligada *header);
int deleteNodo (lista_ligada *header, char *nombre);
static void liberarNodo (nodo* minodo);
int esTipoBase(int tipo);
void printListaLigada (lista_ligada *header);
void printSimbolosNoUsados (lista_ligada *header);
void printInfoNodo (nodo *nodo);
int simboloEsUnaVariable(nodo* minodo);
void modificaTipoVar(nodo* var, int tipo_var);
void insertarSimbolo(lista_ligada *header, nodo* minodo);
int existeNombreNodo (lista_ligada *header, char* nombre);
nodo* crearSimbolo(char *nombre, int tipo);

//si queremos printear todas las operaciones de la lista poner DEBUG_MODE A 1, sino a 0
#define DEBUG_MODE 1
#if DEBUG_MODE
    #define debugFile stdout
#else
    #define debugFile fopen("/dev/null","w")
#endif


/**
 * Crea y devuelve una lista vacia
 * se crea un puntero a lista y no una lista para poder modificarla por referencia
 */
lista_ligada* crearListaLigada() {
    lista_ligada *lista = (lista_ligada *)malloc(sizeof(lista_ligada));
    lista -> first = NULL;
    lista -> contador = 1;
    return lista;
}

/**
 * Crea una lista ligada e introduce en ella los tipos basicos
 */
lista_ligada* crearTablaDeSimbolos() {
    lista_ligada *lista = crearListaLigada();
    char* nombres_tipos_base[5];
    nombres_tipos_base[ENTERO-1] = "entero";
    nombres_tipos_base[REAL-1] = "real";
    nombres_tipos_base[BOOLEANO-1] = "booleano";
    nombres_tipos_base[CARACTER-1] = "caracter";
    nombres_tipos_base[CADENA-1] = "cadena";

    for(int i=0; i < sizeof(nombres_tipos_base) / sizeof(nombres_tipos_base[0]); i++){
        nodo *nuevoTipo = crearSimbolo(nombres_tipos_base[i], SIM_TIPO);
        insertarSimbolo(lista, nuevoTipo);
    }
    return lista;
}


/**
 * Crea un nodo y lo devuelve
 * @param nombre: nombre del nodo
 * @param tipo: tipo del nodo (Ej: variable, tipo, funcion...). Se usan las macros de define.h
 * Lo marcamos inicialmente como no usado
 */

nodo* crearSimbolo(char *nombre, int tipo){
    // Nota para el futuro: tendremos un sistema de números de bloque, que nos indicarán la visibilidad
    nodo *nuevo = (nodo *)malloc(sizeof(nodo));
    nuevo -> usado = 0;
    nuevo -> nombre = (char *)malloc(sizeof(char) * TAM_MAX_NOMBRE);
    if (strlen(nombre) <= TAM_MAX_NOMBRE) {
        strcpy(nuevo -> nombre, nombre);
        nuevo -> tipo = tipo;
        nuevo -> next = NULL;
        //No reservamos memoria para la info de momento
    } else {
        fprintf(debugFile, "Creacion de nodo incorrecta: Nombre muy largo %s\n", nombre);
        return NULL;
    }
    return nuevo;
}


//PRIVATE
void insertarSimbolo(lista_ligada *header, nodo* minodo){
    if (existeNombreNodo(header, minodo->nombre)){
        fprintf(debugFile, "EL OBJETO '%s' ya estaba en la lista\n", minodo->nombre);
        return;
    }
    minodo -> next = header ->first;
    minodo -> id = header -> contador;
    header -> contador ++;
    header -> first = minodo;
}

/**
 * Crea un simbolo variable sin tipo  con nombre Tx, siendo x su id
 *  
 */
nodo* newTemp(lista_ligada *header){
    int id = header->contador;
    char nombre[5];//5 sera suficiente
    sprintf(nombre,"T%i", id);
    nodo* T =  insertarVariable(header, nombre, SIM_SIN_TIPO);
    marcarComoUsado(T);
    return T;
}

/**
 * Inserta un nodo en la lista
 * Return:
 *   -1 si ya existe un nodo con ese nombre
 *   id del simbolo si es correcto
 */
nodo* insertarVariable(lista_ligada *header, char *nombre, int tipo){
    nodo *nuevaVar = crearSimbolo(nombre, SIM_VARIABLE);
    nuevaVar->info.t1.tipo_variable = tipo;
    insertarSimbolo(header, nuevaVar);
    fprintf(debugFile, "Inserción CORRECTA del objeto de nombre : %s\n", nombre);
    return nuevaVar;
}



/**
 * Busca y devuelve un simbolo por el nombre
 * @param nombre: nombre del simbolo a buscar
 * Return
 *   -NULL si el simbolo no ha sido encontrado
 *   -Puntero al simbolo encontrado si exito. 
 *    No es una copia, es un puntero. No se saca el nodo de la lista
 */
nodo* getSimboloPorNombre (lista_ligada *header, char* nombre) {
    if(header -> first == NULL) {
        return NULL;
    }
    nodo *minodo;
    minodo = header -> first;//busqueda del nodo
    while ((minodo -> next != NULL) && (strcmp(nombre, minodo -> nombre) != 0)) {
        minodo = minodo -> next;
    }
    if (strcmp(nombre, minodo -> nombre) == 0) {
        return minodo;
    }else{
        return NULL;
    }
}

/**
 * Busca y devuelve un simbolo por el id
 * @param id: id del simbolo a buscar
 * Return
 *   -NULL si el simbolo no ha sido encontrado
 *   -Puntero al simbolo encontrado si exito. 
 *    No es una copia, es un puntero. No se saca el nodo de la lista
 */
nodo* getSimboloPorId (lista_ligada *header, int id) {
    if(header -> first == NULL) {
        return NULL;
    }
    nodo *minodo;
    minodo = header -> first;//busqueda del nodo
    while ((minodo -> next != NULL) && minodo -> id != id) {
        minodo = minodo -> next;
    }
    if (minodo -> id == id) {
        return minodo;
    }else{
        return NULL;
    }
}

/**
 * return tipo del simbolo (Ej: variable, tipo, funcion...)
 * Esta funcion es corta y parece estupida pero es mejor tener una buena interfaz 
 */
int getTipoSimbolo(nodo* minodo){
    return minodo -> tipo;
}

/**
 * Get nombre del tipo
 * Esta funcion es corta y parece estupida pero es mejor tener una buena interfaz 
 */
char *getNombreSimbolo(nodo* minodo){
    return minodo -> nombre;
}

/**
 * Return
 *   1 si existe un nodo con ese nombre en la lista
 *   0 si no exite
 */
int existeNombreNodo (lista_ligada *header, char* nombre) {
    if (getSimboloPorNombre(header, nombre) != NULL) {
        fprintf(debugFile, "El objeto de nombre [%s] se encuentra en la lista\n", nombre);
        return 1;
    }else{
        fprintf(debugFile, "El objeto de nombre [%s] no se encuentra en la lista\n", nombre);
        return 0;
    }  
}

/**
 * Modifica el tipo de la variable var 
 */
void modificaTipoVar(nodo* var, int tipo_var){
    if(getTipoSimbolo(var) == SIM_VARIABLE){
        var->info.t1.tipo_variable = tipo_var;
    }else{
        printf("ERROR: Esta intentando cambiar el tipo de variable de un simbolo que no es una variable\n");
    }
}
int getTipoVar (nodo* minodo){
    if(simboloEsUnaVariable(minodo)){
        return minodo->info.t1.tipo_variable;
    }
}


/**
 * Devuelve un info_nodo cuyo campo t1 apunta a una struct de infoVar
 * @param char *tipo_var: el tipo a asignar a la variable 
 *
info_nodo crearInfoVariable(int tipo_var){
    //Habra que haber comprobado antes que el tipo_var es un tipo valido
    info_nodo info;
    info.t1.tipo_variable = tipo_var;
    return info;
}


/**
 * Devuelve un info_nodo cuyo campo t2 apunta a una struct de infoTipo
 * Esto es solo una prueba. Para almacenar tipos obviamente no usaremos un string.
 * Es un ejemplo para poder probar a meter diferentes tipos de nodos
 *
info_nodo crearInfoTipo(char *tipo_tipo){
    info_nodo info;
    info.t2.tipo_tipo = (char *)malloc(sizeof(tipo_tipo));
    strcpy(info.t2.tipo_tipo, tipo_tipo);
    return info;
}


/**
 * Devuelve un info_nodo cuyo campo t3 apunta a una struct de infoFunc
 * Esto es solo una prueba. Para almacenar funciones obviamente no usaremos dos string.
 * Es un ejemplo para poder probar a meter diferentes tipos de nodos
 *
info_nodo crearInfoFunc(char *ent, char *sal){
    info_nodo info;
    info.t3.ent = (char *)malloc(sizeof(ent));
    info.t3.sal = (char *)malloc(sizeof(sal));
    strcpy(info.t3.ent, ent);
    strcpy(info.t3.sal, sal);
    return info;
}
*/



/**
 * Añade info a un nodo
 * info_nodo info es un puntero a una struct tipo infoVar, infoTipo o infoFunc...
 * Esta funcion sirve para todo los tipos de nodos
 
void addInfoNodo (nodo* minodo, info_nodo info){
    minodo -> info = info;
}*/


/**
 * Busca un nodo en la lista y le añade la info
 *
int addInfoNodoEnLista (lista_ligada *header, char* nombre, info_nodo info) {
    nodo *minodo = getSimboloPorNombre(header, nombre);
    if (minodo != NULL) {
        addInfoNodo(minodo, info);
        fprintf(debugFile, "Información añadida en el objeto correspondiente\n");
        return 1;
    }
    fprintf(debugFile, "El objeto de nombre [%s] no se encuentra en la lista\n", nombre);
    return 0;
}*/



/**
 * Busca un nodo y devulve su info
 *
info_nodo getInfoNodoEnLista (lista_ligada *header, char* nombre) {
    nodo *minodo = getSimboloPorNombre(header, nombre);
    if (minodo != NULL) {
        return minodo -> info;
    }
    fprintf(debugFile, "El objeto de nombre [%s] no se encuentra en la lista, no se puede obtener su información\n", nombre);
    //return NULL;aqui da error porque no podemos devulver NULL porque no es un info_nodo
}*/



/**
 * Marca que el nodo ha sido utilizado en el codigo
 * Esa funcion es util para despues poder imprimir que nodos han sido declarados y nunca usados
 */
void marcarComoUsado(nodo *minodo){
    minodo -> usado = 1;
}
/**
 * Vacia la lista, haciendo que su first apunte a NULL
 * Libera todo el espacio que ocupaban los elementos de la lista
 */
void vaciarLista (lista_ligada *header) {
    if (header -> first == NULL) {
        fprintf(debugFile, "Vaciar lista: La lista YA estaba vacía\n");
    } else {
        nodo *auxant = NULL;
        nodo *aux = header -> first;
        while (aux -> next != NULL) {
            auxant = aux;
            aux = aux -> next;
            liberarNodo(auxant);
        }
        liberarNodo(aux);
        header -> first = NULL;
        fprintf(debugFile, "La lista se ha vaciado\n");
    }
}


/**
* Busca y elimina un nodo, liberando todo su espacio
* Seria muuuuucho mas facil si fues una lista doblemnte ligada. Asi solo (casi) habria que hacer get y liberar
**/
int deleteNodo(lista_ligada *header, char *nombre){
    if (header -> first == NULL) {
        fprintf(debugFile, "deleteNodo: La lista está vacía\n");
    } else {
        if(strcmp(nombre, header->first->nombre)  == 0){
            //si es el primer simbolo
            nodo *aux = header->first;
            header->first = header->first->next;
            liberarNodo(aux);
        }else{
            nodo *auxant = NULL;
            nodo *aux = header -> first;
            while (aux -> next != NULL &&  strcmp(nombre, aux -> nombre) != 0) {
                auxant = aux;
                aux = aux -> next;
            }
            if(strcmp(nombre, aux -> nombre) == 0){
                printInfoNodo(aux);
                auxant -> next = aux -> next;
                liberarNodo(aux);
            }else{
                fprintf(debugFile, "deleteNodo: Nodo no encontrado\n");
            }
        }
    }
}


/**
* Elimina el nodo
* Libera todo el espacio que el nodo y su info ocupan
*/
void liberarNodo(nodo* minodo){
    switch(minodo -> tipo){
        case SIM_VARIABLE:
            break;
        case SIM_TIPO:
            free(minodo->info.t2.tipo_tipo);
            break;
        case SIM_FUNCION:
            free(minodo->info.t3.ent);
            free(minodo->info.t3.sal);
            break;
    }
    free(minodo);
    //minodo = NULL; no estamos pasando el puntero a nodo minodo por referencia
    //lo mejor despues de liberarlo seria ponerlo a NULL par que no esté apuntando a una celda 
    //que puede que ya no almacene los valores del nodo.
    //si por ejemplo declaras un nodo, despues lo liberas y despues no insertas TODO ESO ES POSIBLE!!!
    //porque en C no hay forma de saber si has liberado un puntero o no :(
}

/**
 * Devuelve el primer nodo de la lista y lo quita de la lista
 * Util cuando quieres sacar todos los elementos de una lista uno a uno
 */
nodo* pop(lista_ligada *header){
    if(header->first != NULL){
        nodo* minodo = header->first;
        header->first = header->first->next;
        minodo->next = NULL;
        return minodo;
    }else{
        return NULL;
    }
}

/**
* Imprime el contenido de la lista y llama a metodos que imprimen la info de los nodos
*/
void printListaLigada (lista_ligada *header) {
    printf("---------------------------------------------------------\n");
    printf("CONTADOR DE LA LISTA:%i\n",header->contador);
    printf("Contenido Lista Ligada:\n");
    nodo *minodo = header -> first;
    while (minodo != NULL) {
        printInfoNodo(minodo);
        minodo = minodo -> next;
    }
}

/**
 * comprueba si el tipo es un tipo base del lenguaje
 */
int esTipoBase(int id){
    return id < 6;
}

/**
 * Funcion a usar al final de haber visto un algoritmo (o una funcion)
 * Para notificar que simbolos fueron declarados y nunca usados
 */
void printSimbolosNoUsados(lista_ligada *header) {
    nodo *minodo = header -> first;
    while (minodo  != NULL) {
        if(minodo->usado == 0){
            switch(minodo->tipo){
                case SIM_VARIABLE:
                    printf("Variable %i %s declarada y nunca usada\n",minodo->info.t1.tipo_variable, minodo->nombre);
                    break;
                case SIM_TIPO:
                    if(!esTipoBase(minodo->id))
                        printf("Tipo %s declarado y nunca usado\n",minodo->nombre);
                    break;
                case SIM_FUNCION:
                    printf("Funcion %s declarada y nunca usada\n",minodo->nombre);
                    break;
            }
        }
        minodo = minodo -> next;
    }
}



/**
 * Imprime toda la info de una variable
 */
void printInfoNodo (nodo *minodo) {
    printf("Nombre del objeto: %s\n", minodo -> nombre);
    switch(minodo->tipo){
        case SIM_VARIABLE:
            printf("    El objeto es una variable\n");
            printf("    El tipo de la variable es : %i\n\n", minodo -> info.t1.tipo_variable);
            break;
        case SIM_TIPO:
            printf("    El objeto es un tipo\n");
            /*if( minodo -> info.t2 != NULL){
                printf("    El tipo del tipo es: %s\n\n", minodo -> info.t2.tipo_tipo);
            }*/
            break;
        case SIM_FUNCION:
            printf("    El objeto es una funcion\n");
            /*if( minodo -> info.t3 != NULL){
                printf("    Los parametros de entrada son: %s\n", minodo -> info.t3 -> ent);
                printf("    Los parametros de salida son: %s\n\n", minodo -> info.t3 -> sal);
            }*/                  
            break;
    }
}

int simboloEsUnTipo(nodo* minodo){
    return minodo->tipo == SIM_TIPO;
}
int simboloEsUnaVariable(nodo* minodo){
    return minodo->tipo == SIM_VARIABLE;
}   
int getIdSimbolo(nodo* minodo){
    return minodo->id;
}

/*
int main (int argc, char** argv) {

    lista_ligada* listaId = crearListaLigada();
    insertarSimbolo(listaId, "mivar");
    insertarSimbolo(listaId, "mivar2");
    printListaLigada(listaId);

    lista_ligada* listaSimbolos =  crearTablaDeSimbolos();
    nodo* nodoTipo = getSimboloPorId(listaSimbolos, ENTERO);
    printf("%i\n", simboloEsUnTipo(nodoTipo));
    marcarComoUsado(nodoTipo);
    nodo* idNodo;
    while((idNodo = pop(listaId))){//para cada id de la lista ty_lista_id
        insertarVariable(listaSimbolos, getNombreSimbolo(idNodo), getIdSimbolo(nodoTipo));
    }
        printListaLigada(listaSimbolos

}*/
