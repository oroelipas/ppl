LEX=flex
CC=gcc
BIS=bison

all: lex.yy.c y.tab.c y.tab.h
	$(CC) lex.yy.c y.tab.c -lfl
lex.yy.c: scanner.l
	$(LEX) -i scanner.l
y.tab.c y.tab.h: parser.y
	$(BIS) -y -d parser.y

