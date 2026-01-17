%{
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern int yylineno;

void yyerror(const char *s);
%}

/* TOKEN DEFINITIONS */
%token KW_START KW_END KW_FUNC KW_INT KW_FLOAT KW_STRING KW_CONFIRM
%token KW_IF KW_FOR KW_ELSE KW_COUNTER KW_WHILE KW_INPUT KW_OUTPUT KW_RETURN

%token OP_CONDASSIGN OP_INCR2 OP_SWAP OP_EQ OP_NEQ OP_LEQ OP_GEQ
%token OP_AND OP_OR OP_ADD_ASSIGN OP_SUB_ASSIGN
%token OP_ADD OP_SUB OP_MUL OP_DIV OP_ASSIGN OP_LT OP_GT OP_NOT OP_MOD

%token PUNC_ARROW PUNC_SCOPE PUNC_DBL_COLON PUNC_SEMI
%token LBRACE RBRACE LPAREN RPAREN LBRACKET RBRACKET

%token NUMBER_FLOAT NUMBER_INT STRING_LITERAL CHAR_LITERAL IDENTIFIER

/* Precedence */
%left OP_ADD OP_SUB
%left OP_MUL OP_DIV
%left OP_AND OP_OR

%%

/* GRAMMAR RULES */

/* UNIQUE STRUCTURE: Whole file is an AAGHAZ block */
program:
    KW_START func_list KW_END
    { 
        printf("\n=== PARSING COMPLETE ===\n");
        printf("Status: AAGHAZ (Start) to IKHTITAM (End) verified successfully.\n");
    }
    ;

func_list:
    function
    | function func_list
    ;

/* Function: AMAL name () { ... } */
function:
    KW_FUNC IDENTIFIER LPAREN RPAREN LBRACE stmt_list RBRACE
    { printf("[System Report] Line %d: Defined Function '%s' (AMAL)\n", yylineno, "func"); }
    ;

stmt_list:
    stmt
    | stmt stmt_list
    ;

stmt:
    declaration
    | assignment
    | conditional
    | loop_while
    | loop_for
    | io_stmt
    | return_stmt
    ;

/* Declaration: PUNJI x; or MEEZAN y; */
declaration:
    type IDENTIFIER PUNC_SEMI
    { printf("[System Report] Line %d: Variable Declaration detected.\n", yylineno); }
    | type IDENTIFIER OP_ASSIGN expression PUNC_SEMI
    { printf("[System Report] Line %d: Variable Initialization detected.\n", yylineno); }
    ;

type:
    KW_INT | KW_FLOAT | KW_STRING | KW_CONFIRM
    ;

/* Assignment: x = 10; or x :? 10 (Her special conditional assign) */
assignment:
    IDENTIFIER OP_ASSIGN expression PUNC_SEMI
    { printf("[System Report] Line %d: Standard Assignment (=).\n", yylineno); }
    | IDENTIFIER OP_CONDASSIGN expression PUNC_SEMI
    { printf("[System Report] Line %d: Conditional Assignment (:?).\n", yylineno); }
    | IDENTIFIER OP_INCR2 PUNC_SEMI
    { printf("[System Report] Line %d: Double Increment (++++).\n", yylineno); }
    ;

/* Conditional: SHART (cond) { } WARNAH { } */
conditional:
    KW_IF LPAREN expression RPAREN LBRACE stmt_list RBRACE
    { printf("[System Report] Line %d: Conditional Block (SHART).\n", yylineno); }
    | KW_IF LPAREN expression RPAREN LBRACE stmt_list RBRACE KW_ELSE LBRACE stmt_list RBRACE
    { printf("[System Report] Line %d: Conditional Block with Else (WARNAH).\n", yylineno); }
    ;

/* While Loop: CHALA (cond) { } */
loop_while:
    KW_WHILE LPAREN expression RPAREN LBRACE stmt_list RBRACE
    { printf("[System Report] Line %d: While Loop (CHALA) detected.\n", yylineno); }
    ;

/* For Loop: FARZ ( ... ) { } */
loop_for:
    KW_FOR LPAREN expression PUNC_SEMI expression PUNC_SEMI expression RPAREN LBRACE stmt_list RBRACE
    { printf("[System Report] Line %d: For Loop (FARZ) detected.\n", yylineno); }
    ;

/* IO: NIKAL => "Text"; */
io_stmt:
    KW_OUTPUT PUNC_ARROW expression PUNC_SEMI
    { printf("[System Report] Line %d: Output Operation (NIKAL).\n", yylineno); }
    | KW_INPUT PUNC_ARROW IDENTIFIER PUNC_SEMI
    { printf("[System Report] Line %d: Input Operation (DAKHAL).\n", yylineno); }
    ;

return_stmt:
    KW_RETURN expression PUNC_SEMI
    { printf("[System Report] Line %d: Return Statement (VAPIS).\n", yylineno); }
    ;

expression:
    term
    | expression OP_ADD term
    | expression OP_SUB term
    | expression OP_LT term
    | expression OP_GT term
    ;

term:
    factor
    | term OP_MUL factor
    | term OP_DIV factor
    ;

factor:
    LPAREN expression RPAREN
    | IDENTIFIER
    | NUMBER_INT
    | NUMBER_FLOAT
    | STRING_LITERAL
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "\n[CRITICAL ERROR] Line %d: %s\n", yylineno, s);
}

int main(int argc, char **argv) {
    printf("Compiling Phase 2 (Inshrah 0384)...\n");
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) {
            perror("File error");
            return 1;
        }
        yyin = f;
    }
    yyparse();
    return 0;
}
