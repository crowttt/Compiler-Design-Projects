grammar myparser;

options{
    language = Java;
}

@header {
    // import packages here.
}

@members {
    boolean TRACEON = true;
}

program:VOID_TYPE MAIN '(' ')' '{' declarations statements '}'
        {if (TRACEON) System.out.println("VOID MAIN () {declarations statements}");};

declarations:type ID ';' declarations
             { if (TRACEON) System.out.println("declarations: type ID ; declarations"); }
           | { if (TRACEON) System.out.println("declarations: ");} ;

type:INT_TYPE { if (TRACEON) System.out.println("type: INT"); }
   | FLOAT_TYPE {if (TRACEON) System.out.println("type: FLOAT"); }
   | CHAR_TYPE {if (TRACEON) System.out.println("type: CHAR");};

statements:statement statements {if (TRACEON) System.out.println("statements:statement statements"); }
        | { if (TRACEON) System.out.println("statements:");}
        ;

arith_expression: multExpr  
                  ( '+' multExpr
				  | '-' multExpr 
                  )* {if (TRACEON) System.out.println("arith_expression: multiExpr ('+' multExpr | '-' multExp )*"); }
                  ;

multExpr: signExpr
          ( '*' signExpr 
          | '/' signExpr  
		  )* {if (TRACEON) System.out.println("multiExpr : signExpr ('*' signExpr | '/' signExpr)*"); }
		  ;

signExpr: primaryExpr  {if (TRACEON) System.out.println("signExpr: primaryExpr"); }
        | '-' primaryExpr  {if (TRACEON) System.out.println("signExpr: '-' primaryExpr"); }
		;
		  
primaryExpr: DEC_NUM  {if (TRACEON) System.out.println("primaryExpr: DEC_NUM"); }
           | FLOAT_NUM  {if (TRACEON) System.out.println("primaryExpr: FLOAT_NUM"); }
           | ID  {if (TRACEON) System.out.println("primaryExpr: ID"); }
		   | '(' arith_expression ')'  {if (TRACEON) System.out.println("primaryExpr: '(' (arith_expression ')'"); }
           ;

statement: ID ('=' arith_expression|PP_OP|MM_OP) ';'  
         {if (TRACEON) System.out.println("statement: ID ('=' arith_expression|PP_OP|MM_OP)"); }
         | IF_TYPE '(' bool_generator ')' if_then_statements  
         {if (TRACEON) System.out.println("statement: IF_TYPE '(' bool_generator ')' if_then_statements"); }
         | FOR_TYPE '(' statement  cmp_expression ';' increasing_decreasing ')' for_statements
         {if (TRACEON) System.out.println("FOR_TYPE '(' statement ';' cmp_expression ';' increasing_decreasing ')' for_statements"); }
         | WHILE_TYPE '(' bool_generator ')'while_statements
         {if (TRACEON) System.out.println("statement: WHILE_TYPE '(' bool_generator ')'while_statements"); }
         | ELSE_IF_TYPE '(' bool_generator ')' if_then_statements
         {if (TRACEON) System.out.println("statement: ELSE_IF_TYPE '(' bool_generator ')' if_then_statements"); }
         | ELSE_TYPE if_then_statements 
         {if (TRACEON) System.out.println("statement: ELSE_TYPE if_then_statements");}
		 ;

if_then_statements:  statement 
                    {if (TRACEON) System.out.println("if_then_statements: statement");}
                    | '{' statements '}'      
                    {if (TRACEON) System.out.println("if_then_statements: '{' statements '}'");}
                    ;

while_statements: '{' statements '}'   
                {if (TRACEON) System.out.println("'{' statements '}'"); }
                ;

for_statements: statement
                {if (TRACEON) System.out.println("statement"); }
                |'{' statements '}'
                {if (TRACEON) System.out.println("'{'statements '}'"); }
                ;

bool_generator:  cmp_expression      {if (TRACEON) System.out.println("bool_generator: cmp_expression"); }
                | 'true'                {if (TRACEON) System.out.println("bool_generator: True"); }
                | 'false'                {if (TRACEON) System.out.println("bool_generator: False"); }
                ;

cmp_expression: arith_expression (cmp_operand arith_expression|)  (and_or cmp_expression | )
            {if (TRACEON) System.out.println("cmp_expression: arith_expression (and_or arith_expression|)"); } 
            ;

cmp_operand: '=='   {if (TRACEON) System.out.println("cmp_operand: '=='"); }
            | '<='  {if (TRACEON) System.out.println("cmp_operand: '<='"); }
            | '>='  {if (TRACEON) System.out.println("cmp_operand: '>='"); }
            | '>'   {if (TRACEON) System.out.println("cmp_operand: '>'"); }
            | '<'   {if (TRACEON) System.out.println("cmp_operand: '<'"); }
            ;
and_or: '&&'  {if (TRACEON) System.out.println("and_or: '&&'"); }
        | '||'  {if (TRACEON) System.out.println("and_or: '||'"); }
        ;

increasing_decreasing: ID PP_OP  {if (TRACEON) System.out.println("increasing_decreasing: ID PP_OP"); }
                    | ID MM_OP   {if (TRACEON) System.out.println("increasing_decreasing: ID MM_OP"); }
                    ;

comment : COMMENT {if(TRACEON) System.out.println("comment : COMMENT");};

/* description of the tokens */
INT_TYPE  : 'int';
CHAR_TYPE : 'char';
VOID_TYPE : 'void';
FLOAT_TYPE: 'float';
WHILE_TYPE : 'while';
FOR_TYPE : 'for' ;
ELSE_IF_TYPE : 'else if' ; 
ELSE_TYPE : 'else' ;
IF_TYPE : 'if' ; 
MAIN : 'main';

PP_OP : '++';
MM_OP : '--'; 

ASSIGN : '=';
PLUS : '+';
MINUS : '-';

SEMICOLON : ';';

EQ_OP : '==';
LE_OP : '<=';
GE_OP : '>=';
NE_OP : '!=';

RSHIFT_OP : '<<';
LSHIFT_OP : '>>';


LEFT_PARENTHESIS : '(';
RIGHT_PARENTHESIS : ')';

LEFT_CURLY_PARENTHESIS : '{';
RIGHT_CURLY_PARENTHESIS : '}';

DEC_NUM : '0'..'9'+;

fragment LETTER : 'a'..'z' | 'A'..'Z' | '_';
fragment DIGIT : '0'..'9';
ID : (LETTER)(LETTER|DIGIT)*;

fragment FLOAT_1 : (DIGIT)+'.'(DIGIT)*;
fragment FLOAT_2 : '.'(DIGIT)+;
fragment FLOAT_3 : (DIGIT)+;
FLOAT_NUM : FLOAT_1 | FLOAT_2 |FLOAT_3;

NEW_LINE : '\n' {$channel=HIDDEN;};

WS : (' '|'\r'|'\t') {$channel=HIDDEN;};

QUOTATION_CHAR : '\'' ;
QUOTATION_STRING : '"';

COMMENT:'/*' .* '*/' {$channel=HIDDEN;};