%{
#include <stdio.h>
#include <string.h>
int line = 1;
FILE *errorFile, *tokensFile;
%}

%%
\n                  { line++; }
[ \t\r]+            ;   

"novibe"|"vibe"|"vi.be"|"chill"|"mood"|"chills"|"ify"|"elfy"|"elsy"|"skip"|"stop"|"welcome"|"yeap"|"nah"|"take"|"show"|"get" {
    printf("Line %d: KEYWORD → %s\n", line, yytext);
    fprintf(tokensFile, "Line %d: KEYWORD → %s\n", line, yytext);
}

[a-zA-Z_][a-zA-Z0-9_]*"++"[0-9]+ {
    printf("Line %d: SPECIAL OPERATOR →%s\n", line, yytext);
    fprintf(tokensFile, "Line %d: SPECIAL OPERATOR → %s\n", line, yytext);
}



"++"|"--"|"="|">="|"<="|"+"|"-"|"*"|"/"|"<"|">"|"=="|"!="|"/="|"*="|"+="|"-=" {
    printf("Line %d: OPERATOR → %s\n", line, yytext);
    fprintf(tokensFile, "Line %d: OPERATOR → %s\n", line, yytext);
}


"::"|";"|"{"|"}"|"("|")"|"["|"]" {
    printf("Line %d: PUNCTUATION → %s\n", line, yytext);
    fprintf(tokensFile, "Line %d: PUNCTUATION → %s\n", line, yytext);
}


[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)? {
    printf("Line %d: NUMBER → %s\n", line, yytext);
    fprintf(tokensFile, "Line %d: NUMBER → %s\n", line, yytext);
}


\"([^\"\\]|\\.)*\" {
    printf("Line %d: STRING → %s\n", line, yytext);
    fprintf(tokensFile, "Line %d: STRING → %s\n", line, yytext);
}

\'.\' {
    printf("Line %d: CHAR → %s\n", line, yytext);
    fprintf(tokensFile, "Line %d: CHAR → %s\n", line, yytext);
}


[a-zA-Z_][a-zA-Z0-9_]* {
    printf("Line %d: IDENTIFIER → %s\n", line, yytext);
    fprintf(tokensFile, "Line %d: IDENTIFIER → %s\n", line, yytext);
}


. {
    printf("Line %d: ERROR → %s\n", line, yytext);
    fprintf(errorFile, "Line %d: ERROR → %s\n", line, yytext);
}
%%

int yywrap() { return 1; }

int main() {
    errorFile = fopen("error_log.txt", "w");
    if (!errorFile) {
        printf("Could not open error_log.txt for writing!\n");
        return 1;
    }
    
    tokensFile = fopen("tokens.txt", "w");
    if (!tokensFile) {
        printf("Could not open tokens.txt for writing!\n");
        return 1;
    }


    printf("----- Lexical Analysis Output -----\n");
    yylex();
    printf("----- End of File -----\n");
    
    
    fclose(tokensFile);
    fclose(errorFile);
    
    return 0;
}
