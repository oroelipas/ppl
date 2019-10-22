%{
#include <ctype.h>
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%option yylineno
  //esto es para permitir dar la linea del error

dr_letra [A-Za-z]
dr_cifra [0-9]
dr_id {dr_letra}({dr_letra}|{dr_cifra})*
dr_entero {dr_cifra}{dr_cifra}*((e){dr_cifra}{dr_cifra}*)?
dr_real  {dr_cifra}{dr_cifra}*(\.{dr_cifra}{dr_cifra}*)?((e)(\-)?{dr_cifra}{dr_cifra}*)?
  // HEMOS QUITADO EL (+|-)? de dr_entero y dr_real para no tener problemas de suma binaria vs. signo mas
  //                                                                          resta binaria vs. signo menos
dr_caracter \"(.|\\.)\"
dr_cadena '([^']|(\/'))*'
dr_comentario \{([^\}]|(\/\}))*\}

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


dr_entrada_a_omitir [\n\t ]

%%
{dr_parentesis_inicial} {
    printf("parentesis_inicial: (\n");
    return TK_PARENTESIS_INICIAL;
}
{dr_parentesis_final} {
    printf("parentesis_final: )\n");
    return TK_PARENTESIS_FINAL;
}



{dr_op_rel_mayor_que} {
    printf("op_relacional (>)\n");
    yylval.str = strdup(yytext);
    return TK_OP_RELACIONAL;
}
{dr_op_rel_menor_que} {
    printf("op_relacional (<)\n");
    yylval.str = strdup(yytext);
    return TK_OP_RELACIONAL;
}
{dr_op_rel_mayor_igual_que} {
    printf("op_relacional (>=)\n");
    yylval.str = strdup(yytext);
    return TK_OP_RELACIONAL;
}
{dr_op_rel_menor_igual_que} {
    printf("op_relacional (<=)\n");
    yylval.str = strdup(yytext);
    return TK_OP_RELACIONAL;
}
{dr_op_rel_desigual} {
    printf("op_relacional (<>)\n");
    yylval.str = strdup(yytext);
    return TK_OP_RELACIONAL;
}

{dr_simbolo_igual} {
    printf("simbolo_igual: =\n");
    return TK_IGUAL;
}


{dr_op_arit_suma} {
    printf("op_aritmetico (+)\n");
    yylval.caracter = yytext[0];
    return TK_OP_ARITMETICO;
}
{dr_op_arit_resta} {
    printf("op_aritmetico (-)\n");
    yylval.caracter = yytext[0];
    return TK_OP_ARITMETICO;
}
{dr_op_arit_mult} {
    printf("op_aritmetico (*)\n");
    yylval.caracter = yytext[0];
    return TK_OP_ARITMETICO;
}
{dr_op_arit_div} {
    printf("op_aritmetico (/)\n");
    yylval.caracter = yytext[0];
    return TK_OP_ARITMETICO;
}
{dr_op_arit_mod} {
    printf("op_aritmetico (mod)\n");
    yylval.caracter = yytext[0];//ESTO VA A DEVOLVER UNA 'M'
    return TK_OP_ARITMETICO;
}
{dr_op_arit_div_ent} {
    printf("op_aritmetico (div)\n");
    yylval.caracter = yytext[0];//ESTO VA A DEVOLVER UNA 'D'
    return TK_OP_ARITMETICO;
}



{dr_asignacion} {
    printf("asignacion (:=)\n");
    return TK_ASIGNACION;
}
{dr_comp_secuencial} {
    printf("comp_secuencial (;)\n");
    return TK_PUNTOYCOMA;
}
{dr_separador} {
    printf("separador (,)\n");
    return TK_SEPARADOR;
}
{dr_subrango} {
    printf("subrango (..)\n");//CHECKEAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    return TK_SUBRANGO;
}
{dr_tipo_var} {
    printf("tipo_var (:)\n");
    return TK_TIPO_VAR;
}
{dr_punto} {
    printf("punto (.)\n");
    return TK_PUNTO;
}

{dr_entonces} {
    printf("entonces (->)\n");
    return TK_ENTONCES;
}
{dr_si_no_si} {
    printf("si_no_si: []\n");//CHECKEAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    return TK_SINOSI;
}
{dr_inicio_array} {
    printf("inicio_array ([)\n");
    return TK_INICIO_ARRAY;
}
{dr_fin_array} {
    printf("fin_array (])\n");
    return TK_FIN_ARRAY;
}



{dr_pr_accion} {
    printf("palabra reservada: accion\n");
	return TK_PR_ACCION;
}
{dr_pr_algoritmo} {
    printf("palabra reservada: algoritmo\n");
	return TK_PR_ALGORITMO;
}
{dr_pr_booleano} {
    printf("palabra reservada: booleano\n");
	return TK_PR_BOOLEANO;
}
{dr_pr_cadena} {
    printf("palabra reservada: cadena\n");
	return TK_PR_CADENA;
}
{dr_pr_caracter} {
    printf("palabra reservada: caracter\n");
	return TK_PR_CARACTER;
}
{dr_pr_const} {
    printf("palabra reservada: const\n");
	return TK_PR_CONST;
}
{dr_pr_continuar} {
    printf("palabra reservada: continuar\n");
	return TK_PR_CONTINUAR;
}
{dr_pr_de} {
    printf("palabra reservada: de\n");
	return TK_PR_DE;
}
{dr_pr_dev} {
    printf("palabra reservada: dev\n");
	return TK_PR_DEV;
}
{dr_pr_ent} {
    printf("palabra reservada: ent\n");
	return TK_PR_ENT;
}
{dr_pr_entero} {
    printf("palabra reservada: entero\n");
	return TK_PR_ENTERO;
}
{dr_pr_es} {
    printf("palabra reservada: es\n");
	return TK_PR_ES;
}
{dr_pr_faccion} {
    printf("palabra reservada: faccion\n");
	return TK_PR_FACCOIN;
}
{dr_pr_falgoritmo} {
    printf("palabra reservada: falgoritmo\n");
	return TK_PR_FALGORITMO;
}
{dr_pr_falso} {
    printf("booleano: 0\n");
    yylval.entero = 0;
	return TK_BOOLEANO;
}
{dr_pr_fconst} {
    printf("palabra reservada: fconst\n");
	return TK_PR_FCONST;
}
{dr_pr_ffuncion} {
    printf("palabra reservada: ffuncion\n");
	return TK_PR_FFUNCION;
}
{dr_pr_fmientras} {
    printf("palabra reservada: fmientras\n");
	return TK_PR_FMIENTRAS;
}
{dr_pr_fpara} {
    printf("palabra reservada: fpara\n");
	return TK_PR_FPARA;
}
{dr_pr_fsi} {
    printf("palabra reservada: fsi\n");
	return TK_PR_FSI;
}
{dr_pr_ftipo} {
    printf("palabra reservada: ftipo\n");
	return TK_PR_FTIPO;
}
{dr_pr_ftupla} {
    printf("palabra reservada: ftupla\n");
	return TK_PR_FTUPLA;
}
{dr_pr_funcion} {
    printf("palabra reservada: funcion\n");
	return TK_PR_FUNCION;
}
{dr_pr_fvar} {
    printf("palabra reservada: fvar\n");
	return TK_PR_FVAR;
}
{dr_pr_hacer} {
    printf("palabra reservada: hacer\n");
	return TK_PR_HACER;
}
{dr_pr_hasta} {
    printf("palabra reservada: hasta\n");
	return TK_PR_HASTA;
}
{dr_pr_mientras} {
    printf("palabra reservada: mientras\n");
	return TK_PR_MIENTRAS;
}
{dr_pr_no} {
    printf("palabra reservada: no\n");
	return TK_PR_NO;
}
{dr_pr_o} {
    printf("palabra reservada: o\n");
	return TK_PR_O;
}
{dr_pr_para} {
    printf("palabra reservada: para\n");
	return TK_PR_PARA;
}
{dr_pr_real} {
    printf("palabra reservada: real\n");
	return TK_PR_REAL;
}
{dr_pr_ref} {
    printf("palabra reservada: ref\n");
	return TK_PR_REF;
}
{dr_pr_sal} {
    printf("palabra reservada: sal\n");
	return TK_PR_SAL;
}
{dr_pr_si} {
    printf("palabra reservada: si\n");
	return TK_PR_SI;
}
{dr_pr_tabla} {
    printf("palabra reservada: tabla\n");
	return TK_PR_TABLA;
}
{dr_pr_tipo} {
    printf("palabra reservada: tipo\n");
	return TK_PR_TIPO;
}
{dr_pr_tupla} {
    printf("palabra reservada: tupla\n");
	return TK_PR_TUPLA;
}
{dr_pr_var} {
    printf("palabra reservada: var\n");
	return TK_PR_VAR;
}
{dr_pr_verdadero} {
    printf("booleano: 1\n");
    yylval.entero = 1;
	return TK_BOOLEANO;
}
{dr_pr_y} {
    printf("palabra reservada: y\n");
	return TK_PR_Y;
}



{dr_comentario} {
    printf("comentario: %s\n", yytext);
    return TK_COMENTARIO;
}
{dr_cadena} {
    printf("Una cadena: %s\n", yytext);
    yylval.str = strdup(yytext);
    return TK_CADENA;
}
{dr_caracter} {
    printf("caracter: %c\n ", yytext[0]);
    yylval.caracter = yytext[0];//mirar si esto esta mal y en realidad es una cadena de un elemento
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
    return TK_IDENTIFICADOR;
}
{dr_entero} {
    printf("entero: %f\n", atof(yytext));
    yylval.doble = atof( yytext );//atoi o atof???
    return TK_ENTERO;
}
{dr_real} {
	printf("real: %g\n",atof( yytext ));
	yylval.doble = atof(yytext);
	return TK_REAL;
}

{dr_entrada_a_omitir} {}
%%

/*


-He modificado la exp regular de los enteros y decimales para que admitan un signo menos desdes de la 'e'.
Ahora pueden existir numeros como 3e-4 PERO NO 3e+4

-HAY QUE DISTRIBUIR LAS CONCATENACIONES!!!

-ojo con no escribir un string Y CON LOS ENTEROS (QUE TIPO ENVIAR, PORQUE NUESTROS ENTEROS NO SON ENTEROS


-SOBRE COMO HACER EL RETURN: https://www.gnu.org/software/bison/manual/html_node/Token-Values.html



-LIBRO DE COMO HACER COMPILADORES
 http://dlsiisv.fi.upm.es/traductores/Software/Flex-Bison.pdf


-PARA PASAR STRING USAR LA FUNCION strdup(), QUE COPIA EL STRING
    https://stackoverflow.com/questions/1853204/yylval-and-union


-LEER DOCUMENTACION DE FLEX Y BISON DE UNIZAR:
 http://webdiis.unizar.es/asignaturas/LGA/material_2004_2005/Intro_Flex_Bison.pdf
 http://webdiis.unizar.es/asignaturas/LGA/

- Introducing Flex and Bison:
https://www.oreilly.com/library/view/flex-bison/9780596805418/ch01.html


para ejecutarlo:
./a.out < programa.txt > salida.txt


dr_desc_algoritomo algoritmo{dr_id};{dr_cabezera_alg}{dr_bloque_alg}falgoritmo\.
dr_cabecera_alg {dr_decl_globales}{dr_decl_a_f}{dr_decl_ent_sal}{dr_comentario}
dr_bloque_alg {dr_bloque}{dr_comentario}
decl_globales ({dr_declaracion_tipo} | {dr_declaracion_const}){dr_decl_globales}|\0
dr_decl_a_f ({dr_accion_d}|{dr_funcion_d}){decl_a_f}|\0
dr_bloque {dr_declaraciones}{dr_instrucciones}
dr_declaraciones ({dr_declaracion_tipo}|{dr_declaracion_const}|{dr_declaracion_var}){dr_declaraciones}|\0

dr_declaracion_tipo tipo{dr_lista_d_tipo}ftipo
dr_declaracion_cte const{lista_d_cte}fconst
dr_declaracion_var var{lista_d_var}fvar

dr_lista_d_tipo {dr_id}={dr_d_tipo};{dr_lista_d_tipo}|\0
dr_d_tipo tupla{dr_lista_campos}ftupla|tabla\[{dr_expresion_t}\.\.{df_expresion_t}\]de{dr_d_tipo}
*/
