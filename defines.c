
#include "defines.h"
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>//esto es para poder usar va_list y va_start() para tener funciones con nº de arg indefinidos: yyerror y warning


/**
 * Esta función sirve para poder printear cada valor de los enum de defines.h
 * Se usa para printear en out.TablaSimbolos, out.TablaCuadruplas 
 * y tambien para dar errores de compilación por pantalla.
 * Aqui se reserva memoria y nuca se libera. 
 * Liberarla sería muy complicado porque a veces se usa para 
 * la funcion yyerror, otras para la funcion warning y otras para la funcion
 * escribirTablaCuadruplas, con lo cual habria que liberar memoria una vez se usara getName en esas funciones.
 * Pero... los parametros de esas funciones a veces son strings que no quieres liberar.
 * Conclusion: nunca se liberaran y punto.
 */
char* getNombreDeConstante (int cod) {
    char *nombre = malloc(TAM_MAX_NOMBRE_SIMBOLO * sizeof(char));
    switch(cod) {
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
            strcpy(nombre,"*real");
            break;
        case DIV:
            strcpy(nombre,"/");
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
        case DIV_ENT:
            strcpy(nombre,"DIV_ENT");
            break;
        case MOD:
            strcpy(nombre,"MOD");
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
        case MULT_ALTERADA:
            strcpy(nombre,"MULT_ALTERADA");
            break;
        case ASIGNACION_A_POS_TABLA:
            strcpy(nombre,"[]=");
            break;
        case ASIGNACION_DE_POS_TABLA:
            strcpy(nombre,"=[]");
            break;
        case SUMA_1:
            strcpy(nombre,"+1");
            break;
        default:
            strcpy(nombre,"OP_NO_DEFINIDA");
            break;
    }
    return nombre;
}

void warningSinLinea(const char *warningText, ...){
    va_list args;
    va_start(args, warningText);
    printf(MAGENTA"%s: Warning "RESET, programName);  
    vprintf(warningText, args);
}