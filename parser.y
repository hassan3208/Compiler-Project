%{
#include <stdio.h>
#include <stdlib.h>

extern int yylineno;
void yyerror(const char *s);
int yylex(void);
%}

%union {
  int num;
  char* id;
}

/* Tokens */
%token WELCOME VIBE IFY ELF WHILE TAKE
%token FOR
%token FUN BREAK CONTINUE
%token ID NUMBER
%token ASSIGN PLUS LT EQ
%token MIN MUL DIV
%token LPAREN RPAREN LBRACE RBRACE SEMI COMMA
%token INC DEC

%left PLUS MIN
%left MUL DIV
%right UMINUS UPLUS


%type <num> expr

%%

/* ================= START SYMBOL ================= */

program
  : function_list WELCOME LPAREN RPAREN block
  ;

/* ================= FUNCTIONS ================= */

function_list
  : function_list function
  | /* empty */
  ;

function
  : FUN ID LPAREN RPAREN block
  ;

/* ================= NORMAL BLOCK ================= */

block
  : LBRACE stmt_list RBRACE
  ;

stmt_list
  : stmt_list stmt
  | /* empty */
  ;

stmt
  : declaration
  | assignment
  | inc_dec_stmt 
  | if_stmt
  | while_stmt
  | for_stmt
  | return_stmt
  ;

/* ================= LOOP BLOCK ================= */

loop_block
  : LBRACE loop_stmt_list RBRACE
  ;

loop_stmt_list
  : loop_stmt_list loop_stmt
  | /* empty */
  ;

loop_stmt
  : declaration
  | assignment
  | inc_dec_stmt   
  | loop_if_stmt
  | while_stmt
  | for_stmt
  ;


/* ================= LOOP IF (ONLY PLACE FOR break/continue) ================= */

loop_if_stmt
  : IFY LPAREN condition RPAREN loop_if_block loop_else_part
  ;

loop_else_part
  : ELF loop_if_block
  | /* empty */
  ;


loop_if_block
  : LBRACE loop_if_stmt_list RBRACE
  ;

loop_if_stmt_list
  : loop_if_stmt_list loop_if_stmt
  | /* empty */
  ;

loop_if_stmt
  : declaration
  | assignment
  | inc_dec_stmt
  | break_stmt
  | continue_stmt
  ;

/* ================= NORMAL IF ================= */

if_stmt
  : IFY LPAREN condition RPAREN block else_part
  ;

else_part
  : ELF LPAREN condition RPAREN block else_part
  | ELF block
  | /* empty */
  ;

/* ================= WHILE ================= */

while_stmt
  : WHILE LPAREN condition RPAREN loop_block
  ;
  
for_stmt
  : FOR LPAREN for_init SEMI condition SEMI for_update RPAREN loop_block
  ;


for_init
  : assign_no_semi
  | /* empty */
  ;

for_update
  : assign_no_semi
  | inc_dec_no_semi
  | /* empty */
  ;



/* ================= STATEMENTS ================= */

break_stmt
  : BREAK SEMI
  ;

continue_stmt
  : CONTINUE SEMI
  ;

declaration
  : VIBE ID SEMI
  ;

assignment
  : ID ASSIGN expr SEMI
  ;

inc_dec_stmt
  : ID INC SEMI
  | ID DEC SEMI
  | INC ID SEMI
  | DEC ID SEMI
  ;

assign_no_semi
  : ID ASSIGN expr
  ;

inc_dec_no_semi
  : ID INC
  | ID DEC
  | INC ID
  | DEC ID
  ;



return_stmt
  : TAKE expr SEMI
  ;

/* ================= EXPRESSIONS ================= */

condition
  : expr LT expr
  | expr EQ expr
  ;

expr
  : expr PLUS expr
  | expr MIN expr
  | expr MUL expr
  | expr DIV expr
  | MIN expr   %prec UMINUS
  | PLUS expr  %prec UPLUS
  | NUMBER
  | ID
  ;

%%

/* ================= ERROR & MAIN ================= */

void yyerror(const char *s) {
  fprintf(stderr, "❌ Syntax Error at line %d: %s\n", yylineno, s);
}

int main() {
  if (yyparse() == 0) {
    printf("✅ Parsing successful. No syntax errors found.\n");
  }
  return 0;
}

