#include "defines.h"
#include <string.h>
#include <stdlib.h>

/**
 * Esto sirve para poder printear cada valor de los enum de defines.h
 * Se usa para printear en out.TablaSimbolos, out.TablaCuadruplas 
 *    y tambien para dar errores de compilación por terminal.
 * Aqui se reserva memoria y nuca se libera. 
 * Pero liberarla seria muy jodido porque a veces se usar para 
 *   la funcion yyerror, para la warning, para la escribirTablaCuadruplas
 *   y entonces habria que liberarlo una vez usado en esas funciones.
 * PERO los parametros de esasa funciones a veces son strings que no quieres liberar.
 * Conclusion: nunca se liberaran y punto.
 * getName IGUAL NO ES UN NOMBRE MUY DESCRIPTIVO
 */
char* getName(int cod){
    char *nombre = malloc(TAM_MAX_NOMBRE_SIMBOLO * sizeof(char));
    switch(cod){
        case ENTERO:
            strcpy(nombre,"entero");
            break;
        case REAL:
            strcpy(nombre,"real");
            break;
        case BOOLEANO:
            strcpy(nombre,"booleano");
            break;
        case CARACTER:
            strcpy(nombre,"caracter");
            break;
        case CADENA:
            strcpy(nombre,"cadena");
            break;
        case ASIGNACION:
            strcpy(nombre,":=");
            break;
        case SUMA_INT:
            strcpy(nombre,"+int");
            break;
        case SUMA_REAL:
            strcpy(nombre,"+real");
            break;
        case RESTA_INT:
            strcpy(nombre,"-int");
            break;
        case RESTA_REAL:
            strcpy(nombre,"-real");
            break;
        case MULT_INT:
            strcpy(nombre,"*int");
            break;
        case MULT_REAL:
            strcpy(nombre,"*rel");
            break;
        case INT_TO_REAL:
            strcpy(nombre,"int->real");
            break;
         case GOTO:
            strcpy(nombre,"GOTO");
            break;
        case GOTO_IF_OP_REL_IGUAL:
            strcpy(nombre,"GOTO_IF_OP_REL_IGUAL");
            break;
        case GOTO_IF_OP_REL_DESIGUAL:
            strcpy(nombre,"GOTO_IF_OP_REL_DESIGUAL");
            break;
        case GOTO_IF_OP_REL_MENOR:
            strcpy(nombre,"GOTO_IF_OP_REL_MENOR");
            break;
        case GOTO_IF_OP_REL_MENOR_IGUAL:
            strcpy(nombre,"GOTO_IF_OP_REL_MENOR_IGUAL");
            break;
        case GOTO_IF_OP_REL_MAYOR:
            strcpy(nombre,"GOTO_IF_OP_REL_MAYOR");
            break;
        case GOTO_IF_OP_REL_MAYOR_IGUAL:
            strcpy(nombre,"GOTO_IF_OP_REL_MAYOR_IGUAL");
            break;
        case GOTO_IF_VERDADERO:
            strcpy(nombre,"GOTO_IF_VERDADERO");
            break;
        case ASIGNAR_VALOR_VERDADERO:
            strcpy(nombre,"ASIGNAR_VALOR_VERDADERO");
            break;
        case ASIGNAR_VALOR_FALSO:
            strcpy(nombre,"ASIGNAR_VALOR_FALSO");
            break;
        case MAYOR:
            strcpy(nombre,">");
            break;
        case MENOR:
            strcpy(nombre,"<");
            break;
        case MAYOR_O_IGUAL:
            strcpy(nombre,">=");
            break;
        case MENOR_O_IGUAL:
            strcpy(nombre,"<=");
            break;
        case IGUAL:
            strcpy(nombre,"=");
            break;
        case DESIGUAL:
            strcpy(nombre,"<>");
            break;
        case INPUT:
            strcpy(nombre,"INPUT");
            break;
        case OUTPUT:
            strcpy(nombre,"OUTPUT");
            break;
        default:
            strcpy(nombre,"OP_NO_DEFINIDA");
            break;
    }
    return nombre;
}