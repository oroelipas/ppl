%{
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
#include "defines.h"

extern FILE *fSaR;//fichero para escribir los SHIFTs que hacemos
extern char *programName;
extern int hayErrores;

%}

%option yylineno
  //esto es para permitir dar la linea del error

dr_letra [A-Za-z]
dr_cifra [0-9]
dr_id {dr_letra}({dr_letra}|{dr_cifra})*
dr_entero {dr_cifra}{dr_cifra}*((e){dr_cifra}{dr_cifra}*)?
  //PORQUE AQUI SE USA \- Y EN LA LINEA DE dr_op_arit_resta Y dr_entonces SOLO SE USA -?????????????????????????????????
dr_real  {dr_cifra}{dr_cifra}*(\.{dr_cifra}{dr_cifra}*)?((e)(\-)?{dr_cifra}{dr_cifra}*)?
  // HEMOS QUITADO EL (+|-)? de dr_entero y dr_real para no tener problemas de suma binaria vs. signo mas
  //                                                                          resta binaria vs. signo menos
dr_caracter \"(.|\\.)\"
dr_cadena '([^']|(\/'))*'
dr_comentario \{([^\}]|(\/\}))*\}
dr_coment_prec \{Prec:([^\}]|(\/\}))*\}
dr_coment_post \{Post:([^\}]|(\/\}))*\}

dr_pr_accion  accion
dr_pr_algoritmo algoritmo
dr_pr_booleano booleano
dr_pr_cadena cadena
dr_pr_caracter caracter
dr_pr_const const
dr_pr_continuar continuar
dr_pr_de de
dr_pr_dev dev
dr_pr_ent ent
dr_pr_entero entero
dr_pr_es e\/s
dr_pr_faccion faccion
dr_pr_falgoritmo falgoritmo
dr_pr_falso falso
dr_pr_fconst fconst
dr_pr_ffuncion ffuncion
dr_pr_fmientras fmientras
dr_pr_fpara fpara
dr_pr_fsi fsi
dr_pr_ftipo ftipo
dr_pr_ftupla ftupla
dr_pr_funcion funcion
dr_pr_fvar fvar
dr_pr_hacer hacer
dr_pr_hasta hasta
dr_pr_mientras mientras
dr_pr_no no
dr_pr_o o
dr_pr_para para
dr_pr_real real
dr_pr_ref ref
dr_pr_sal sal
dr_pr_si si
dr_pr_tabla tabla
dr_pr_tipo tipo
dr_pr_tupla tupla
dr_pr_var var
dr_pr_verdadero verdadero
dr_pr_y y

dr_asignacion :=
dr_comp_secuencial ;
dr_separador ,
dr_subrango \.\.
dr_tipo_var :
dr_punto \.
dr_entonces ->
dr_si_no_si \[\]
dr_inicio_array \[
dr_fin_array \]

dr_simbolo_igual =

dr_op_rel_mayor_que >
dr_op_rel_menor_que <
dr_op_rel_mayor_igual_que >=
dr_op_rel_menor_igual_que <=
dr_op_rel_desigual <>

dr_op_arit_suma \+
dr_op_arit_resta -
dr_op_arit_mult \*
dr_op_arit_div \/
dr_op_arit_mod mod
dr_op_arit_div_ent div

dr_parentesis_inicial \(
dr_parentesis_final \)

dr_tk_inesperado [^\n\t ]

dr_entrada_a_omitir [\n\t ]

%%
{dr_parentesis_inicial} {
    fprintf(fSaR,"SHIFT  parentesis_inicial: (\n");
    return TK_PARENTESIS_INICIAL;
}
{dr_parentesis_final} {
    fprintf(fSaR,"SHIFT  parentesis_final: )\n");
    return TK_PARENTESIS_FINAL;
}



{dr_op_rel_mayor_que} {
    fprintf(fSaR,"SHIFT  op_relacional (>)\n");
    yylval.str = strdup(yytext);
    return TK_OP_RELACIONAL;
}
{dr_op_rel_menor_que} {
    fprintf(fSaR,"SHIFT  op_relacional (<)\n");
    yylval.str = strdup(yytext);
    return TK_OP_RELACIONAL;
}
{dr_op_rel_mayor_igual_que} {
    fprintf(fSaR,"SHIFT  op_relacional (>=)\n");
    yylval.str = strdup(yytext);
    return TK_OP_RELACIONAL;
}
{dr_op_rel_menor_igual_que} {
    fprintf(fSaR,"SHIFT  op_relacional (<=)\n");
    yylval.str = strdup(yytext);
    return TK_OP_RELACIONAL;
}
{dr_op_rel_desigual} {
    fprintf(fSaR,"SHIFT  op_relacional (<>)\n");
    yylval.str = strdup(yytext);
    return TK_OP_RELACIONAL;
}

{dr_simbolo_igual} {
    fprintf(fSaR,"SHIFT  simbolo_igual: =\n");
    return TK_IGUAL;
}


{dr_op_arit_suma} {
    fprintf(fSaR,"SHIFT  op_aritmetico (+)\n");
    yylval.caracter = yytext[0];
    return TK_MAS;
}
{dr_op_arit_resta} {
    fprintf(fSaR,"SHIFT  op_aritmetico (-)\n");
    yylval.caracter = yytext[0];
    return TK_MENOS;
}
{dr_op_arit_mult} {
    fprintf(fSaR,"SHIFT  op_aritmetico (*)\n");
    yylval.caracter = yytext[0];
    return TK_MULT;
}
{dr_op_arit_div} {
    fprintf(fSaR,"SHIFT  op_aritmetico (/)\n");
    yylval.caracter = yytext[0];
    return TK_DIV;
}
{dr_op_arit_mod} {
    fprintf(fSaR,"SHIFT  op_aritmetico (mod)\n");
    yylval.caracter = yytext[0];//ESTO VA A DEVOLVER UNA 'M'
    return TK_MOD;
}
{dr_op_arit_div_ent} {
    fprintf(fSaR,"SHIFT  op_aritmetico (div)\n");
    yylval.caracter = yytext[0];//ESTO VA A DEVOLVER UNA 'D'
    return TK_DIV_ENT;
}



{dr_asignacion} {
    fprintf(fSaR,"SHIFT  asignacion (:=)\n");
    return TK_ASIGNACION;
}
{dr_comp_secuencial} {
    fprintf(fSaR,"SHIFT  comp_secuencial (;)\n");
    return TK_PUNTOYCOMA;
}
{dr_separador} {
    fprintf(fSaR,"SHIFT  separador (,)\n");
    return TK_SEPARADOR;
}
{dr_subrango} {
    fprintf(fSaR,"SHIFT  subrango (..)\n");//CHECKEAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    return TK_SUBRANGO;
}
{dr_tipo_var} {
    fprintf(fSaR,"SHIFT  tipo_var (:)\n");
    return TK_TIPO_VAR;
}
{dr_punto} {
    fprintf(fSaR,"SHIFT  punto (.)\n");
    return TK_PUNTO;
}

{dr_entonces} {
    fprintf(fSaR,"SHIFT  entonces (->)\n");
    return TK_ENTONCES;
}
{dr_si_no_si} {
    fprintf(fSaR,"SHIFT  si_no_si: []\n");//CHECKEAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    return TK_SINOSI;
}
{dr_inicio_array} {
    fprintf(fSaR,"SHIFT  inicio_array ([)\n");
    return TK_INICIO_ARRAY;
}
{dr_fin_array} {
    fprintf(fSaR,"SHIFT  fin_array (])\n");
    return TK_FIN_ARRAY;
}



{dr_pr_accion} {
    fprintf(fSaR,"SHIFT  palabra reservada: accion\n");
	return TK_PR_ACCION;
}
{dr_pr_algoritmo} {
    fprintf(fSaR,"SHIFT  palabra reservada: algoritmo\n");
	return TK_PR_ALGORITMO;
}
{dr_pr_booleano} {
    fprintf(fSaR,"SHIFT  palabra reservada: booleano\n");
	return TK_PR_BOOLEANO;
}
{dr_pr_cadena} {
    fprintf(fSaR,"SHIFT  palabra reservada: cadena\n");
	return TK_PR_CADENA;
}
{dr_pr_caracter} {
    fprintf(fSaR,"SHIFT  palabra reservada: caracter\n");
	return TK_PR_CARACTER;
}
{dr_pr_const} {
    fprintf(fSaR,"SHIFT  palabra reservada: const\n");
	return TK_PR_CONST;
}
{dr_pr_continuar} {
    fprintf(fSaR,"SHIFT  palabra reservada: continuar\n");
	return TK_PR_CONTINUAR;
}
{dr_pr_de} {
    fprintf(fSaR,"SHIFT  palabra reservada: de\n");
	return TK_PR_DE;
}
{dr_pr_dev} {
    fprintf(fSaR,"SHIFT  palabra reservada: dev\n");
	return TK_PR_DEV;
}
{dr_pr_ent} {
    fprintf(fSaR,"SHIFT  palabra reservada: ent\n");
	return TK_PR_ENT;
}
{dr_pr_entero} {
    fprintf(fSaR,"SHIFT  palabra reservada: entero\n");
	return TK_PR_ENTERO;
}
{dr_pr_es} {
    fprintf(fSaR,"SHIFT  palabra reservada: es\n");
	return TK_PR_ES;
}
{dr_pr_faccion} {
    fprintf(fSaR,"SHIFT  palabra reservada: faccion\n");
	return TK_PR_FACCION;
}
{dr_pr_falgoritmo} {
    fprintf(fSaR,"SHIFT  palabra reservada: falgoritmo\n");
	return TK_PR_FALGORITMO;
}
{dr_pr_falso} {
    fprintf(fSaR,"SHIFT  booleano: 0\n");
    yylval.entero = 0;
	return TK_BOOLEANO;
}
{dr_pr_fconst} {
    fprintf(fSaR,"SHIFT  palabra reservada: fconst\n");
	return TK_PR_FCONST;
}
{dr_pr_ffuncion} {
    fprintf(fSaR,"SHIFT  palabra reservada: ffuncion\n");
	return TK_PR_FFUNCION;
}
{dr_pr_fmientras} {
    fprintf(fSaR,"SHIFT  palabra reservada: fmientras\n");
	return TK_PR_FMIENTRAS;
}
{dr_pr_fpara} {
    fprintf(fSaR,"SHIFT  palabra reservada: fpara\n");
	return TK_PR_FPARA;
}
{dr_pr_fsi} {
    fprintf(fSaR,"SHIFT  palabra reservada: fsi\n");
	return TK_PR_FSI;
}
{dr_pr_ftipo} {
    fprintf(fSaR,"SHIFT  palabra reservada: ftipo\n");
	return TK_PR_FTIPO;
}
{dr_pr_ftupla} {
    fprintf(fSaR,"SHIFT  palabra reservada: ftupla\n");
	return TK_PR_FTUPLA;
}
{dr_pr_funcion} {
    fprintf(fSaR,"SHIFT  palabra reservada: funcion\n");
	return TK_PR_FUNCION;
}
{dr_pr_fvar} {
    fprintf(fSaR,"SHIFT  palabra reservada: fvar\n");
	return TK_PR_FVAR;
}
{dr_pr_hacer} {
    fprintf(fSaR,"SHIFT  palabra reservada: hacer\n");
	return TK_PR_HACER;
}
{dr_pr_hasta} {
    fprintf(fSaR,"SHIFT  palabra reservada: hasta\n");
	return TK_PR_HASTA;
}
{dr_pr_mientras} {
    fprintf(fSaR,"SHIFT  palabra reservada: mientras\n");
	return TK_PR_MIENTRAS;
}
{dr_pr_no} {
    fprintf(fSaR,"SHIFT  palabra reservada: no\n");
	return TK_PR_NO;
}
{dr_pr_o} {
    fprintf(fSaR,"SHIFT  palabra reservada: o\n");
	return TK_PR_O;
}
{dr_pr_para} {
    fprintf(fSaR,"SHIFT  palabra reservada: para\n");
	return TK_PR_PARA;
}
{dr_pr_real} {
    fprintf(fSaR,"SHIFT  palabra reservada: real\n");
	return TK_PR_REAL;
}
{dr_pr_ref} {
    fprintf(fSaR,"SHIFT  palabra reservada: ref\n");
	return TK_PR_REF;
}
{dr_pr_sal} {
    fprintf(fSaR,"SHIFT  palabra reservada: sal\n");
	return TK_PR_SAL;
}
{dr_pr_si} {
    fprintf(fSaR,"SHIFT  palabra reservada: si\n");
	return TK_PR_SI;
}
{dr_pr_tabla} {
    fprintf(fSaR,"SHIFT  palabra reservada: tabla\n");
	return TK_PR_TABLA;
}
{dr_pr_tipo} {
    fprintf(fSaR,"SHIFT  palabra reservada: tipo\n");
	return TK_PR_TIPO;
}
{dr_pr_tupla} {
    fprintf(fSaR,"SHIFT  palabra reservada: tupla\n");
	return TK_PR_TUPLA;
}
{dr_pr_var} {
    fprintf(fSaR,"SHIFT  palabra reservada: var\n");
	return TK_PR_VAR;
}
{dr_pr_verdadero} {
    fprintf(fSaR,"SHIFT  booleano: 1\n");
    yylval.entero = 1;
	return TK_BOOLEANO;
}
{dr_pr_y} {
    fprintf(fSaR,"SHIFT  palabra reservada: y\n");
	return TK_PR_Y;
}


{dr_coment_prec} {
    fprintf(fSaR,"SHIFT  comentario precondicion: %s\n", yytext);
    return TK_COMENT_PREC;
}
{dr_coment_post} {
    fprintf(fSaR,"SHIFT  comentario postcondicion: %s\n", yytext);
    return TK_COMENT_POST;
}
{dr_comentario} {
    fprintf(fSaR,"Comentario omitido: %s\n", yytext);
}
{dr_cadena} {
    fprintf(fSaR,"SHIFT  Una cadena: %s\n", yytext);
    yylval.str = strdup(yytext);
    return TK_CADENA;
}
{dr_caracter} {
    fprintf(fSaR,"SHIFT  caracter: %c\n", yytext[1]);
    yylval.caracter = yytext[1];//mirar si esto esta mal y en realidad es una cadena de un elemento
    return TK_CARACTER;
}
{dr_id} {
    char lowerId[yyleng+1];
    for(int i=0; i<yyleng; i++){
        if(yytext[i] >= 'A' && yytext[i] <= 'Z'){
            lowerId[i] = tolower(yytext[i]);
        }else{
            lowerId[i] = yytext[i];
        }
    }
    lowerId[yyleng] = '\0';
    yylval.str = strdup(lowerId);
    fprintf(fSaR,"SHIFT  identificador: %s\n", yytext);
    return TK_IDENTIFICADOR;
}
{dr_entero} {
    fprintf(fSaR,"SHIFT  entero: %f\n", atof(yytext));
    yylval.doble = atof( yytext );//atoi o atof???
    return TK_ENTERO;
}
{dr_real} {
	fprintf(fSaR,"SHIFT  real: %g\n",atof( yytext ));
	yylval.doble = atof(yytext);
	return TK_REAL;
}

{dr_tk_inesperado} {
	printf("%s:%i:"RED" token inesperado: '%s'\n"RESET,programName, yylineno, yytext);
	hayErrores = 1;
    //yylval.str = strdup(yytext);
	//return TK_INESPERADO;g   
}

{dr_entrada_a_omitir} {}
%%

/*

-He modificado la exp regular de los enteros y decimales para que admitan un signo menos desdes de la 'e'.
Ahora pueden existir numeros como 3e-4 PERO NO 3e+4

-ojo con no escribir un string Y CON LOS ENTEROS (QUE TIPO ENVIAR, PORQUE NUESTROS ENTEROS NO SON ENTEROS

-LIBRO DE COMO HACER COMPILADORES
 http://dlsiisv.fi.upm.es/traductores/Software/Flex-Bison.pdf


-PARA PASAR STRING USAR LA FUNCION strdup(), QUE COPIA EL STRING
    https://stackoverflow.com/questions/1853204/yylval-and-union


-LEER DOCUMENTACION DE FLEX Y BISON DE UNIZAR:
 http://webdiis.unizar.es/asignaturas/LGA/material_2004_2005/Intro_Flex_Bison.pdf
 http://webdiis.unizar.es/asignaturas/LGA/

- Introducing Flex and Bison:
https://www.oreilly.com/library/view/flex-bison/9780596805418/ch01.html

*/
