LEX=flex
CC=gcc

all: lex.yy.o
	$(CC) lex.yy.o -lfl
lex.yy.o: lex.yy.c
	$(CC) -c lex.yy.c
lex.yy.c: scanner.l
	$(LEX) -i scanner.l
