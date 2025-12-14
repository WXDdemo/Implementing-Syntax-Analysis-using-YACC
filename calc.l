%{
#include "calc.tab.h"
#include <string.h>
void yyerror(const char *s);
%}
IDENTIFIER [a-zA-Z_][a-zA-Z0-9_]*
NUMBER     [0-9]+(\.[0-9]+)?
WHITESPACE [ \t\n]+
%%
{WHITESPACE}    {  }
quit            { return QUIT; }  // 优先匹配quit，避免被IDENTIFIER覆盖
{IDENTIFIER}    { 
    yylval.id = strdup(yytext);
    return ID;
}
{NUMBER}        { 
    yylval.num = atof(yytext);
    return NUMBER; 
}
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULT; }
"/"             { return DIV; }
"="             { return ASSIGN; }
";"             { return SEMICOLON; }
"("             { return LPAREN; }
")"             { return RPAREN; }
<<EOF>>         { return 0; }
.               { yyerror("Unknown character"); }
%%
int yywrap() {
    return 1;
}
