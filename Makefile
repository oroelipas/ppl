LEX=flex
CC=gcc
BIS=bison

all: lex.yy.c bison.tab.c bison.tab.h
	$(CC) lex.yy.c bison.tab.c -lfl
lex.yy.c: scanner.l
	$(LEX) -i scanner.l
bison.tab.c bison.tab.h: bison.y
	$(BIS) -d bison.y

