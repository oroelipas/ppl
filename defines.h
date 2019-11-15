
/*
 TODO .H TIENE QUE EMPEZAR POR "#ifndef CM_OI_LISTA_H" <------------PARA QUE SEA UNA MACRO UNICA
    dentro de este if va toooooooodo el .h
#ENDIF 
 */
	
#ifndef RED
    #define RED "\033[0;31m"
#endif

#ifndef RESET
    #define RESET "\033[0m"
#endif

//definiciones de tipos de nodos
#define SIM_VARIABLE 1
#define SIM_TIPO 2
#define SIM_FUNCION 3
#define SIM_SIN_TIPO 4

//definiciones de tipos de varibles
//TAMBIEN SERIA IGUAL INTERESANTE QUE NO FUESEN STRINGS SINO INTEGERS. PARA HACER COMPARACIONES DE TIPO MAS FACIL
#define ENTERO 1
#define REAL 2
#define BOOLEANO 3
#define CARACTER 4
#define CADENA 5

//aqui pone 5 para que ambios ficheros (lista.c y parsey.y (y.tab.c)) puedan ver cual es el tamaño
//al parecer la funcion sizeof() no hace una llamada en tiempo real y por eso no solo decesita que la variable 
//este definida (extern char *tiposBase[]) sino tambien que declaremos su dimension
//https://stackoverflow.com/questions/5240435/invalid-application-of-sizeof-to-incomplete-type-int-when-accessing-intege
//https://stackoverflow.com/questions/12873142/invalid-application-of-sizeof-to-incomplete-type-struct-array
//extern char *tiposBase[5];
