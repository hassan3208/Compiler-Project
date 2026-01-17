%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h" 


%}

%option noyywrap
%option yylineno

%%

[ \t\n]+      {  }

"AAGHAZ"      { return KW_START; }
"IKHTITAM"    { return KW_END; }
"AMAL"        { return KW_FUNC; }
"PUNJI"       { return KW_INT; }
"MEEZAN"      { return KW_FLOAT; }
"LISAN"       { return KW_STRING; }
"MANZUR"      { return KW_CONFIRM; }
"SHART"       { return KW_IF; }
"FARZ"        { return KW_FOR; }
"WARNAH"      { return KW_ELSE; }
"TADAAD"      { return KW_COUNTER; }
"CHALA"       { return KW_WHILE; }
"DAKHAL"      { return KW_INPUT; }
"NIKAL"       { return KW_OUTPUT; }
"VAPIS"       { return KW_RETURN; }

":?"          { return OP_CONDASSIGN; }
"++++"        { return OP_INCR2; }
"<>"          { return OP_SWAP; }
"=="          { return OP_EQ; }
"!="          { return OP_NEQ; }
"<="          { return OP_LEQ; }
">="          { return OP_GEQ; }
"&&"          { return OP_AND; }
"||"          { return OP_OR; }
"+="          { return OP_ADD_ASSIGN; }
"-="          { return OP_SUB_ASSIGN; }

"+"           { return OP_ADD; }
"-"           { return OP_SUB; }
"*"           { return OP_MUL; }
"/"           { return OP_DIV; }
"="           { return OP_ASSIGN; }
"<"           { return OP_LT; }
">"           { return OP_GT; }
"!"           { return OP_NOT; }
"%"           { return OP_MOD; }

"=>"          { return PUNC_ARROW; }
"$"           { return PUNC_SCOPE; }
"::"          { return PUNC_DBL_COLON; }
";"           { return PUNC_SEMI; }
"{"           { return LBRACE; }
"}"           { return RBRACE; }
"("           { return LPAREN; }
")"           { return RPAREN; }
"["           { return LBRACKET; }
"]"           { return RBRACKET; }

[0-9]+\.[0-9]+([eE][+-]?[0-9]+)?    { return NUMBER_FLOAT; }
[0-9]+                              { return NUMBER_INT; }

\"([^\"\\\n]|\\.)*\"                { return STRING_LITERAL; }
\'([^'\\\n]|\\.)\'                  { return CHAR_LITERAL; }

[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFIER; }

.                                   { printf("Line %d: Lexical Error - Unknown Token %s\n", yylineno, yytext); }

%%
