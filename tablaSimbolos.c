/* MÓDULO QUE IMPLEMENTA UNA LISTA LIGADA */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "defines.h"

#include <string.h>
#include "tablaSimbolos.h"


#define TAM_MAX_NOMBRE 50		// Número de caracteres máximo que podrá tener el nombre del objeto almacenado
#define TAM_MAX_TIPO_VAR 100 	// Número de caracteres máximo que podrá tener el nombre de un tipo de variable (tanto básico como definido por el usuario. Ej: entero, booleano, miTipo...)

//#define LENGTH(x)  (sizeof(x) / sizeof((x)[0]))igual esto es guay para la longitud de los arrays https://stackoverflow.com/questions/37538/how-do-i-determine-the-size-of-my-array-in-c

/*PONER "static" vendria a significar private. La funcion no sale de este fichero*/
lista_ligada* crearListaLigada();
lista_ligada* crearTablaDeSimbolos();

simbolo *insertarVariable(lista_ligada *header, char *nombre, int tipo);
simbolo* getSimboloPorNombre (lista_ligada *header, char* nombre);
int  existesimbolo (lista_ligada *header, char* nombre);
info_simbolo crearInfoVariable (int tipo_var);
info_simbolo crearInfoTipo (char *tipo_tipo);
info_simbolo crearInfoFunc (char *ent, char *sal);
void marcarComoUsado (simbolo *misimbolo);
void addInfosimbolo (simbolo* misimbolo, info_simbolo info);
int  addInfosimboloEnLista (lista_ligada *header, char* nombre, info_simbolo info);
info_simbolo getInfosimbolo (simbolo* misimbolo);
info_simbolo getInfosimboloEnLista (lista_ligada *header, char* nombre);
int   getTipo (simbolo* misimbolo);
char *getNombreSimbolo (simbolo* misimbolo);
void vaciarLista (lista_ligada *header);
int deletesimbolo (lista_ligada *header, char *nombre);
static void liberarsimbolo (simbolo* misimbolo);
int esTipoBase(int tipo);
void printListaLigada (lista_ligada *header);
void printSimbolosNoUsados (lista_ligada *header);
void printInfosimbolo (simbolo *simbolo);
int simboloEsUnaVariable(simbolo* misimbolo);
void modificaTipoVar(simbolo* var, int tipo_var);
void insertarSimbolo(lista_ligada *header, simbolo* misimbolo);
int existeNombresimbolo (lista_ligada *header, char* nombre);
simbolo* crearSimbolo(char *nombre, int tipo);

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
        simbolo *nuevoTipo = crearSimbolo(nombres_tipos_base[i], SIM_TIPO);
        insertarSimbolo(lista, nuevoTipo);
    }
    return lista;
}


/**
 * Crea un simbolo y lo devuelve
 * @param nombre: nombre del simbolo
 * @param tipo: tipo del simbolo (Ej: variable, tipo, funcion...). Se usan las macros de define.h
 * Lo marcamos inicialmente como no usado
 */

simbolo* crearSimbolo(char *nombre, int tipo){
    // Nota para el futuro: tendremos un sistema de números de bloque, que nos indicarán la visibilidad
    simbolo *nuevo = (simbolo *)malloc(sizeof(simbolo));
    nuevo -> usado = 0;
    nuevo -> nombre = (char *)malloc(sizeof(char) * TAM_MAX_NOMBRE);
    if (strlen(nombre) <= TAM_MAX_NOMBRE) {
        strcpy(nuevo -> nombre, nombre);
        nuevo -> tipo = tipo;
        nuevo -> next = NULL;
        //No reservamos memoria para la info de momento
    } else {
        fprintf(debugFile, "Creacion de simbolo incorrecta: Nombre muy largo %s\n", nombre);
        return NULL;
    }
    return nuevo;
}


//PRIVATE
void insertarSimbolo(lista_ligada *header, simbolo* misimbolo){
    if (existeNombresimbolo(header, misimbolo->nombre)){
        fprintf(debugFile, "EL OBJETO '%s' ya estaba en la lista\n", misimbolo->nombre);
        return;
    }
    misimbolo -> next = header ->first;
    misimbolo -> id = header -> contador;
    header -> contador ++;
    header -> first = misimbolo;
}

/**
 * Crea un simbolo variable sin tipo  con nombre Tx, siendo x su id
 *  
 */
simbolo* newTemp(lista_ligada *header){
    int id = header->contador;
    char nombre[5];//5 sera suficiente
    sprintf(nombre,"T%i", id);
    simbolo* T =  insertarVariable(header, nombre, SIM_SIN_TIPO);
    marcarComoUsado(T);
    return T;
}

/**
 * Inserta un simbolo en la lista
 * Return:
 *   -1 si ya existe un simbolo con ese nombre
 *   id del simbolo si es correcto
 */
simbolo* insertarVariable(lista_ligada *header, char *nombre, int tipo){
    simbolo *nuevaVar = crearSimbolo(nombre, SIM_VARIABLE);
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
 *    No es una copia, es un puntero. No se saca el simbolo de la lista
 */
simbolo* getSimboloPorNombre (lista_ligada *header, char* nombre) {
    if(header -> first == NULL) {
        return NULL;
    }
    simbolo *misimbolo;
    misimbolo = header -> first;//busqueda del simbolo
    while ((misimbolo -> next != NULL) && (strcmp(nombre, misimbolo -> nombre) != 0)) {
        misimbolo = misimbolo -> next;
    }
    if (strcmp(nombre, misimbolo -> nombre) == 0) {
        return misimbolo;
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
 *    No es una copia, es un puntero. No se saca el simbolo de la lista
 */
simbolo* getSimboloPorId (lista_ligada *header, int id) {
    if(header -> first == NULL) {
        return NULL;
    }
    simbolo *misimbolo;
    misimbolo = header -> first;//busqueda del simbolo
    while ((misimbolo -> next != NULL) && misimbolo -> id != id) {
        misimbolo = misimbolo -> next;
    }
    if (misimbolo -> id == id) {
        return misimbolo;
    }else{
        return NULL;
    }
}

/**
 * return tipo del simbolo (Ej: variable, tipo, funcion...)
 * Esta funcion es corta y parece estupida pero es mejor tener una buena interfaz 
 */
int getTipoSimbolo(simbolo* misimbolo){
    return misimbolo -> tipo;
}

/**
 * Get nombre del tipo
 * Esta funcion es corta y parece estupida pero es mejor tener una buena interfaz 
 */
char *getNombreSimbolo(simbolo* misimbolo){
    return misimbolo -> nombre;
}

/**
 * Return
 *   1 si existe un simbolo con ese nombre en la lista
 *   0 si no exite
 */
int existeNombresimbolo (lista_ligada *header, char* nombre) {
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
void modificaTipoVar(simbolo* var, int tipo_var){
    if(getTipoSimbolo(var) == SIM_VARIABLE){
        var->info.t1.tipo_variable = tipo_var;
    }else{
        printf("ERROR: Esta intentando cambiar el tipo de variable de un simbolo que no es una variable\n");
    }
}
int getTipoVar (simbolo* misimbolo){
    if(simboloEsUnaVariable(misimbolo)){
        return misimbolo->info.t1.tipo_variable;
    }
}


/**
 * Devuelve un info_simbolo cuyo campo t1 apunta a una struct de infoVar
 * @param char *tipo_var: el tipo a asignar a la variable 
 *
info_simbolo crearInfoVariable(int tipo_var){
    //Habra que haber comprobado antes que el tipo_var es un tipo valido
    info_simbolo info;
    info.t1.tipo_variable = tipo_var;
    return info;
}


/**
 * Devuelve un info_simbolo cuyo campo t2 apunta a una struct de infoTipo
 * Esto es solo una prueba. Para almacenar tipos obviamente no usaremos un string.
 * Es un ejemplo para poder probar a meter diferentes tipos de simbolos
 *
info_simbolo crearInfoTipo(char *tipo_tipo){
    info_simbolo info;
    info.t2.tipo_tipo = (char *)malloc(sizeof(tipo_tipo));
    strcpy(info.t2.tipo_tipo, tipo_tipo);
    return info;
}


/**
 * Devuelve un info_simbolo cuyo campo t3 apunta a una struct de infoFunc
 * Esto es solo una prueba. Para almacenar funciones obviamente no usaremos dos string.
 * Es un ejemplo para poder probar a meter diferentes tipos de simbolos
 *
info_simbolo crearInfoFunc(char *ent, char *sal){
    info_simbolo info;
    info.t3.ent = (char *)malloc(sizeof(ent));
    info.t3.sal = (char *)malloc(sizeof(sal));
    strcpy(info.t3.ent, ent);
    strcpy(info.t3.sal, sal);
    return info;
}
*/



/**
 * Añade info a un simbolo
 * info_simbolo info es un puntero a una struct tipo infoVar, infoTipo o infoFunc...
 * Esta funcion sirve para todo los tipos de simbolos
 
void addInfosimbolo (simbolo* misimbolo, info_simbolo info){
    misimbolo -> info = info;
}*/


/**
 * Busca un simbolo en la lista y le añade la info
 *
int addInfosimboloEnLista (lista_ligada *header, char* nombre, info_simbolo info) {
    simbolo *misimbolo = getSimboloPorNombre(header, nombre);
    if (misimbolo != NULL) {
        addInfosimbolo(misimbolo, info);
        fprintf(debugFile, "Información añadida en el objeto correspondiente\n");
        return 1;
    }
    fprintf(debugFile, "El objeto de nombre [%s] no se encuentra en la lista\n", nombre);
    return 0;
}*/



/**
 * Busca un simbolo y devulve su info
 *
info_simbolo getInfosimboloEnLista (lista_ligada *header, char* nombre) {
    simbolo *misimbolo = getSimboloPorNombre(header, nombre);
    if (misimbolo != NULL) {
        return misimbolo -> info;
    }
    fprintf(debugFile, "El objeto de nombre [%s] no se encuentra en la lista, no se puede obtener su información\n", nombre);
    //return NULL;aqui da error porque no podemos devulver NULL porque no es un info_simbolo
}*/



/**
 * Marca que el simbolo ha sido utilizado en el codigo
 * Esa funcion es util para despues poder imprimir que simbolos han sido declarados y nunca usados
 */
void marcarComoUsado(simbolo *misimbolo){
    misimbolo -> usado = 1;
}
/**
 * Vacia la lista, haciendo que su first apunte a NULL
 * Libera todo el espacio que ocupaban los elementos de la lista
 */
void vaciarLista (lista_ligada *header) {
    if (header -> first == NULL) {
        fprintf(debugFile, "Vaciar lista: La lista YA estaba vacía\n");
    } else {
        simbolo *auxant = NULL;
        simbolo *aux = header -> first;
        while (aux -> next != NULL) {
            auxant = aux;
            aux = aux -> next;
            liberarsimbolo(auxant);
        }
        liberarsimbolo(aux);
        header -> first = NULL;
        fprintf(debugFile, "La lista se ha vaciado\n");
    }
}


/**
* Busca y elimina un simbolo, liberando todo su espacio
* Seria muuuuucho mas facil si fues una lista doblemnte ligada. Asi solo (casi) habria que hacer get y liberar
**/
int deletesimbolo(lista_ligada *header, char *nombre){
    if (header -> first == NULL) {
        fprintf(debugFile, "deletesimbolo: La lista está vacía\n");
    } else {
        if(strcmp(nombre, header->first->nombre)  == 0){
            //si es el primer simbolo
            simbolo *aux = header->first;
            header->first = header->first->next;
            liberarsimbolo(aux);
        }else{
            simbolo *auxant = NULL;
            simbolo *aux = header -> first;
            while (aux -> next != NULL &&  strcmp(nombre, aux -> nombre) != 0) {
                auxant = aux;
                aux = aux -> next;
            }
            if(strcmp(nombre, aux -> nombre) == 0){
                printInfosimbolo(aux);
                auxant -> next = aux -> next;
                liberarsimbolo(aux);
            }else{
                fprintf(debugFile, "deletesimbolo: simbolo no encontrado\n");
            }
        }
    }
}


/**
* Elimina el simbolo
* Libera todo el espacio que el simbolo y su info ocupan
*/
void liberarsimbolo(simbolo* misimbolo){
    switch(misimbolo -> tipo){
        case SIM_VARIABLE:
            break;
        case SIM_TIPO:
            free(misimbolo->info.t2.tipo_tipo);
            break;
        case SIM_FUNCION:
            free(misimbolo->info.t3.ent);
            free(misimbolo->info.t3.sal);
            break;
    }
    free(misimbolo);
    //misimbolo = NULL; no estamos pasando el puntero a simbolo misimbolo por referencia
    //lo mejor despues de liberarlo seria ponerlo a NULL par que no esté apuntando a una celda 
    //que puede que ya no almacene los valores del simbolo.
    //si por ejemplo declaras un simbolo, despues lo liberas y despues no insertas TODO ESO ES POSIBLE!!!
    //porque en C no hay forma de saber si has liberado un puntero o no :(
}

/**
 * Devuelve el primer simbolo de la lista y lo quita de la lista
 * Util cuando quieres sacar todos los elementos de una lista uno a uno
 */
simbolo* pop(lista_ligada *header){
    if(header->first != NULL){
        simbolo* misimbolo = header->first;
        header->first = header->first->next;
        misimbolo->next = NULL;
        return misimbolo;
    }else{
        return NULL;
    }
}

/**
* Imprime el contenido de la lista y llama a metodos que imprimen la info de los simbolos
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
    simbolo *misimbolo = header -> first;
    while (misimbolo  != NULL) {
        if(misimbolo->usado == 0){
            switch(misimbolo->tipo){
                case SIM_VARIABLE:
                    printf("Variable %i %s declarada y nunca usada\n",misimbolo->info.t1.tipo_variable, misimbolo->nombre);
                    break;
                case SIM_TIPO:
                    if(!esTipoBase(misimbolo->id))
                        printf("Tipo %s declarado y nunca usado\n",misimbolo->nombre);
                    break;
                case SIM_FUNCION:
                    printf("Funcion %s declarada y nunca usada\n",misimbolo->nombre);
                    break;
            }
        }
        misimbolo = misimbolo -> next;
    }
}



/**
 * Imprime toda la info de una variable
 */
void printInfosimbolo (simbolo *misimbolo) {
    printf("Nombre del objeto: %s\n", misimbolo -> nombre);
    switch(misimbolo->tipo){
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

int simboloEsUnTipo(simbolo* misimbolo){
    return misimbolo->tipo == SIM_TIPO;
}
int simboloEsUnaVariable(simbolo* misimbolo){
    return misimbolo->tipo == SIM_VARIABLE;
}   
int getIdSimbolo(simbolo* misimbolo){
    return misimbolo->id;
}

/*
int main (int argc, char** argv) {

    lista_ligada* listaId = crearListaLigada();
    insertarSimbolo(listaId, "mivar");
    insertarSimbolo(listaId, "mivar2");
    printListaLigada(listaId);

    lista_ligada* listaSimbolos =  crearTablaDeSimbolos();
    simbolo* simboloTipo = getSimboloPorId(listaSimbolos, ENTERO);
    printf("%i\n", simboloEsUnTipo(simboloTipo));
    marcarComoUsado(simboloTipo);
    simbolo* idsimbolo;
    while((idsimbolo = pop(listaId))){//para cada id de la lista ty_lista_id
        insertarVariable(listaSimbolos, getNombreSimbolo(idsimbolo), getIdSimbolo(simboloTipo));
    }
        printListaLigada(listaSimbolos

}*/
