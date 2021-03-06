%{
#include <string.h>

enum {MAX_SIZE = 100,TITLE,NAME,TENNIS_PLAYER,GENDER,
		COMP,COMMA,YEAR_NUM,HYPHEN,APOSTROPHES,STARS};    
enum gender{WOMAN, MAN, NUM};
union {
	char str[MAX_SIZE];
	int year;
	enum gender gen;
}yylval;
%}

%option noyywrap
%option yylineno

%%

"Winners"									{ strcpy (yylval.str, yytext); return TITLE; }

"**"										{ strcpy (yylval.str, yytext); return STARS; }

"<name>"									{ return NAME;   }

[a-zA-Z]+(" "[a-zA-Z]+)*					{ strcpy(yylval.str, yytext); return TENNIS_PLAYER; }

'|\" 										{ return APOSTROPHES; }

"<Man>"										{ yylval.gen = MAN; return GENDER; }

"<Woman>"									{ yylval.gen = WOMAN; return GENDER; }

18[5-9][0-9]|19[0-9]{2}|[2-9][0-9]{3,}    	{ yylval.year = atoi(yytext); yylval.year = yylval.year == 2020 ? 2021 
														: yylval.year; return YEAR_NUM; }

[\-?]										{ return HYPHEN; }

,											{ return COMMA; }

\<[A-Za-z]+(" "[A-Za-z]+)*\>				{ strcpy(yylval.str, yytext); return COMP; }

[ \t\n\r]+									{ /* skip white space */ }               

. 											{ fprintf(stderr, "Line: %d unrecognized token %c (0x%x)\n", yylineno, yytext[0], yytext[0]); }			

%%

int main (int argc, char **argv)
{
	int token;
	const char* genders[NUM] = {"Woman", "Man"};
	extern FILE *yyin;

	if (argc != 2) {
		fprintf(stderr, "Usage: %s <input file name>\n", argv [0]);
		exit (1);
	}

	yyin = fopen (argv[1], "r");
	if (yyin == NULL) { 
		fprintf(stderr, "failed to open file %s\n", argv[1]);
		exit(1);
	}

	printf("%s\t\t\t%s\t\t\t%s\n", "TOKEN", "LEXEME", "SEMANTIC VALUE");
	printf("-----------------------------------------------------------\n");
	while ((token = yylex()) != 0) {
		switch (token) {
			case TENNIS_PLAYER: 	
				printf("NAME\t\t\t%s\t\t\t%s\n", yytext, yylval.str);
			      	break;
			case COMP: 	
				printf("COMP\t\t\t%s\t\t\t%s\n", yytext, yylval.str);
			      	break;
			case YEAR_NUM:
				printf("YEAR\t\t\t%s\t\t\t%d\n", yytext, yylval.year);
			      	break;
			case COMMA:
				printf("COMMA\t\t\t%s\n", yytext);
			      	break;
			case GENDER: 	
				printf("GENDER\t\t\t%s\t\t\t%s\n", yytext, genders[yylval.gen]);
			      	break;
			case NAME: 	
				printf("ID\t\t\t%s\n", yytext);
			      	break;
			case TITLE: 	
				printf("TITLE\t\t\t%s\t\t\t%s\n", yytext, yylval.str);
			      	break;
			case HYPHEN: 	
				printf("HYPHEN\t\t\t%s\n", yytext);
			      	break;
			case APOSTROPHES: 	
				printf("APOSTROPHES\t\t\t%s\n", yytext);
			      	break;
			case STARS: 	
				printf("STARS\t\t\t%s\n", yytext);
			      	break;
			default:
				fprintf (stderr, "error ... \n");
				exit(1);
		}
	}

	fclose(yyin);
	exit (0);
}