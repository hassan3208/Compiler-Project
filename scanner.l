%option noyywrap yylineno
%{
#include "parser.tab.h"
#include <stdio.h>
%}

%%
"//".* ;
"welcome"      return WELCOME;
"fun"          return FUN;
"vibe"         return VIBE;
"ify"          return IFY;
"elfy"         return ELF;
"while"        return WHILE;
"for"          return FOR; 
"take"         return TAKE;
"break"        return BREAK;
"continue"     return CONTINUE;

"=="            return EQ;
"<"             return LT;
"="             return ASSIGN;
"++"    { return INC; }
"--"    { return DEC; }
"+"           {  return PLUS;}
"-"          {   return MIN;}
"*"          { return MUL; }
"/"          { return DIV; }

";"             return SEMI;
","             return COMMA;
"("             return LPAREN;
")"             return RPAREN;
"{"             return LBRACE;
"}"             return RBRACE;

[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.id = strdup(yytext); return ID; }

[ \t\r\n]+      ;
.               { printf("Unknown character: %s\n", yytext); }

%%

