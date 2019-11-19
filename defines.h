#ifndef CM_OI_DEFINES_H
#define CM_OI_DEFINES_H
	
#ifndef RED
    #define RED "\033[0;31m"
#endif

#ifndef RESET
    #define RESET "\033[0m"
#endif

//definiciones de tipos de nodos
#define SIM_VARIABLE 101
#define SIM_TIPO 102
#define SIM_FUNCION 103
#define SIM_SIN_TIPO 104

//definiciones de tipos de varibles
#define ENTERO 1
#define REAL 2
#define BOOLEANO 3
#define CARACTER 4
#define CADENA 5

#define ASIGNACION 201
#define SUMA_INT 202
#define SUMA_REAL 203
#define RESTA_INT 204
#define RESTA_REAL 205
#define MULT_INT 206
#define MULT_REAL 207
#define INT_TO_REAL 208
#define GOTO_OP_REL_IGUALDAD 209
#define GOTO 210

#define TAM_MAX_NOMBRE_SIMBOLO 100 	// Número de caracteres máximo que podrá tener el nombre de un tipo, variable, funcion...

#endif


//aqui pone 5 para que ambios ficheros (lista.c y parsey.y (y.tab.c)) puedan ver cual es el tamaño
//al parecer la funcion sizeof() no hace una llamada en tiempo real y por eso no solo decesita que la variable 
//este definida (extern char *tiposBase[]) sino tambien que declaremos su dimension
//https://stackoverflow.com/questions/5240435/invalid-application-of-sizeof-to-incomplete-type-int-when-accessing-intege
//https://stackoverflow.com/questions/12873142/invalid-application-of-sizeof-to-incomplete-type-struct-array
//extern char *tiposBase[5];
