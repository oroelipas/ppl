LEX=flex
CC=gcc
BIS=bison
#-Wall
all: lex.yy.c y.tab.c y.tab.h 
	$(CC)  lex.yy.c y.tab.c lista.c  -lfl
lex.yy.c: scanner.l 
	$(LEX) -i scanner.l
y.output y.tab.c y.tab.h: parser.y
	$(BIS) -y -v -d --report=solved parser.y
clean:
	rm a.out y.tab.c y.tab.h lex.yy.o lex.yy.c *.gch y.output
