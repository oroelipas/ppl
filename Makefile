LEX=flex
CC=gcc
BIS=bison
#-Wall
all: lex.yy.c y.tab.c y.tab.h tablaCuadruplas.c tablaSimbolos.c listaIndicesQuad.c tablaCuadruplas.h tablaSimbolos.h listaIndicesQuad.h y.output defines.c defines.h
	$(CC)  lex.yy.c y.tab.c tablaSimbolos.c tablaCuadruplas.c listaIndicesQuad.c defines.c -lfl
lex.yy.c: scanner.l 
	$(LEX) -i scanner.l
y.output y.tab.c y.tab.h: parser.y
	$(BIS) -y -v -d --report=solved parser.y
clean:
	rm -f a.out y.tab.c y.tab.h lex.yy.o lex.yy.c *.gch y.output
