LEX=flex
CC=gcc
BIS=bison

all: y.output lex.yy.c y.tab.c y.tab.h
	$(CC) lex.yy.c y.tab.c -lfl
lex.yy.c: scanner.l
	$(LEX) -i scanner.l
y.output y.tab.c y.tab.h: parser.y
	$(BIS) -y -v -d --report=solved parser.y

