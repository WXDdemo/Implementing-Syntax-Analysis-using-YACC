%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char* s);
typedef struct {
    char* name;
    double value;
} Symbol;
Symbol symtab[100];
int symcount = 0;
double get_var(char* name) {
    for (int i = 0; i < symcount; i++) {
        if (strcmp(symtab[i].name, name) == 0) {
            return symtab[i].value;
        }
    }
    yyerror("Undefined variable");
    return 0;
}
void set_var(char* name, double value) {
    for (int i = 0; i < symcount; i++) {
        if (strcmp(symtab[i].name, name) == 0) {
            symtab[i].value = value;
            return;
        }
    }
    if (symcount < 100) {
        symtab[symcount].name = strdup(name);
        symtab[symcount].value = value;
        symcount++;
    } else {
        yyerror("Symbol table full");
    }
}
void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}
int yylex();
%}
%union {
    double num;
    char* id;
}
%token <id> ID
%token <num> NUMBER
%token PLUS MINUS MULT DIV ASSIGN SEMICOLON LPAREN RPAREN QUIT
%nonassoc UMINUS
%left PLUS MINUS
%left MULT DIV
%type <num> expr stmt
%%
program: 
    | program stmt
    | QUIT SEMICOLON { exit(0); }
    ;
stmt: 
    expr SEMICOLON { printf("%.2f\n", $1); }  // 仅显示计算结果
    | ID ASSIGN expr SEMICOLON { set_var($1, $3); free($1); }
    ;
expr: 
    NUMBER { $$ = $1; }
    | ID { $$ = get_var($1); free($1); }
    | expr PLUS expr { $$ = $1 + $3; }
    | expr MINUS expr { $$ = $1 - $3; }
    | expr MULT expr { $$ = $1 * $3; }
    | expr DIV expr { 
        if ($3 == 0) {
            yyerror("Division by zero");
            $$ = 0;
        } else {
            $$ = $1 / $3;
        }
    }
    | MINUS expr %prec UMINUS { $$ = -$2; }
    | LPAREN expr RPAREN { $$ = $2; }
    ;
%%
int main() {
    yyparse();
    for (int i = 0; i < symcount; i++) {
        free(symtab[i].name);
    }
    return 0;
}
