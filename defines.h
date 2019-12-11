
/*  CABECERA DEL MODULO defines
	Autores: Oroel Ipas y Carlos Moyano */

#ifndef CM_OI_DEFINES_H
#define CM_OI_DEFINES_H
	
#define RED "\033[0;31m"
#define RESET "\033[0m"
#define MAGENTA "\033[1;35m"

// definiciones de tipos de simbolos
#define SIM_VARIABLE 101
#define SIM_TIPO 102
#define SIM_FUNCION 103
#define SIM_SIN_TIPO 104

// definiciones de tipos de varibles
#define ENTERO 0
#define REAL 1
#define BOOLEANO 2
#define CARACTER 3
#define CADENA 4

// definiciones de operaciones
#define ASIGNACION 201
#define SUMA_INT 202
#define SUMA_REAL 203
#define RESTA_INT 204
#define RESTA_REAL 205
#define MULT_INT 206
#define MULT_REAL 207
#define DIV 208
#define INT_TO_REAL 209
#define GOTO 210
#define GOTO_IF_OP_REL_IGUAL 211
#define GOTO_IF_OP_REL_DESIGUAL 212
#define GOTO_IF_OP_REL_MENOR 213
#define GOTO_IF_OP_REL_MENOR_IGUAL 214
#define GOTO_IF_OP_REL_MAYOR 215
#define GOTO_IF_OP_REL_MAYOR_IGUAL 216
#define GOTO_IF_VERDADERO 217
#define ASIGNAR_VALOR_VERDADERO 218
#define ASIGNAR_VALOR_FALSO 219
#define DIV_ENT 220
#define MOD 221
#define SUMA_1 222

#define MAYOR 300
#define MENOR 301
#define MAYOR_O_IGUAL 302
#define MENOR_O_IGUAL 303
#define IGUAL 304
#define DESIGUAL 305

// definiciones de entrada y salida
#define INPUT 400
#define OUTPUT 500

// definiciones relacionadas con el manejo de accesos a tablas
#define MULT_ALTERADA 700
#define ASIGNACION_A_POS_TABLA 701
#define ASIGNACION_DE_POS_TABLA 702
#define OFFSET_NULO -1

// definiciones de btw de los tipos básicos del lenguaje
#define BTW_GENERICO 100
#define BTW_VACIO -1

// definiciones de tamaños
#define TAM_MAX_NOMBRE_SIMBOLO 100 	// Número de caracteres máximo que podrá tener el nombre de un tipo, variable, funcion...
#define TAM_NOMBRE_T 5				// Número de caracteres máximos que podrá tener el nombre de una variable temporal

// DECLARACIÓN DE FUNCIONES GLOBALES
extern char* getNombreDeConstante (int cod);
#endif


//aqui pone 5 para que ambios ficheros (lista.c y parsey.y (y.tab.c)) puedan ver cual es el tamaño
//al parecer la funcion sizeof() no hace una llamada en tiempo real y por eso no solo decesita que la variable 
//este definida (extern char *tiposBase[]) sino tambien que declaremos su dimension
//https://stackoverflow.com/questions/5240435/invalid-application-of-sizeof-to-incomplete-type-int-when-accessing-intege
//https://stackoverflow.com/questions/12873142/invalid-application-of-sizeof-to-incomplete-type-struct-array
//extern char *tiposBase[5];
