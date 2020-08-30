grammar myChecker;

options{
    language = Java;
}

@header {
    import java.util.HashMap;
}

@members {
    boolean TRACEON = false;
    HashMap<String,Integer> symtab = new HashMap<String,Integer>();

	/*
    public enum TypeInfo {
        Integer,
		Float,
		Unknown,
		No_Exist,
		Error
    }
    */

    /* attr_type:
       1 => integer,
       2 => float,
       3 => char,
       4 => boolean,
       5 => compare_operand,
       -1 => do not exist,
       -2 => error
     */	   
}

program:VOID_TYPE MAIN '(' ')' '{' declarations statements '}';

declarations:type ID ';' declarations
             { 
               if (symtab.containsKey($ID.text)){
                   System.out.println("Type Error:"+$ID.getLine()+":Redeclared ID");
               }
               else{
                   symtab.put($ID.text,$type.attr_type);
               }
             }
           | ;

type returns [int attr_type]
    :INT_TYPE {$attr_type = 1;}
   | FLOAT_TYPE {$attr_type = 2;}
   | CHAR_TYPE {$attr_type = 3;};

statements:statement statements|
        ;

arith_expression returns [int attr_type]
                : a=multExpr  {$attr_type = $a.attr_type;}
                ( '+' b=multExpr
                {
                    if($a.attr_type != $b.attr_type && $a.attr_type>0 && $b.attr_type>0){
                        System.out.println("Type Error: " + 
			                     $a.start.getLine() +
					                 ": Type mismatch for the operator + in an expression.");
		                $attr_type = -2;
                  
                    }
                }
			    | '-' c=multExpr 
                {
                    if($a.attr_type != $c.attr_type && $a.attr_type>0 && $c.attr_type>0){
                        System.out.println("Type Error: " + 
			                 $a.start.getLine() +
					             ": Type mismatch for the operator - in an expression.");
		                $attr_type = -2;
                   
                    }                    
                }
                )*
                ;

multExpr returns [int attr_type]
        : a=signExpr {$attr_type = $a.attr_type;}
        ( '*' b=signExpr 
        {
            if($a.attr_type != $b.attr_type && $a.attr_type>0 && $b.attr_type>0){
                System.out.println("Type Error: " + 
			                 $a.start.getLine() +
					         ": Type mismatch for the operator * in an expression.");
		        $attr_type = -2;
              //  return $attr_type;
            }
        }
        | '/' c=signExpr  
        {
            if($a.attr_type != $c.attr_type && $a.attr_type>0 && $c.attr_type>0){
                System.out.println("Type Error: " + 
			                 $a.start.getLine() +
					         ": Type mismatch for the operator / in an expression.");
		        $attr_type = -2;
             //   return $attr_type;
            }
        }
		)* 
		;

signExpr returns [int attr_type]
        : primaryExpr  
        {
            $attr_type = $primaryExpr.attr_type;
        }
        | '-' primaryExpr  
        {
            $attr_type = $primaryExpr.attr_type;
        }
		;
		  
primaryExpr returns[int attr_type]
        : DEC_NUM  {$attr_type = 1;}
           | FLOAT_NUM  {$attr_type = 2;}
           | ID
           {
                if(symtab.containsKey($ID.text)){
                    $attr_type = symtab.get($ID.text);
                }
                else{
                     System.out.println("Type Error: "+ $ID.getLine()+": '"+$ID.text + "' undeclared");
                     $attr_type = -2;
                     return $attr_type;
                }
           }
		   | '(' arith_expression ')'  {$attr_type = $arith_expression.attr_type;}
           ;

statement returns [int attr_type]
    : ID ('=' arith_expression 
         {
             if(symtab.containsKey($ID.text)){
                 $attr_type = symtab.get($ID.text);
             }
             else{
                 System.out.println("Type Error: "+ $ID.getLine()+": '"+$ID.text + "' undeclared");
                 $attr_type = -2;
                 return $attr_type;
             }
             
            if(attr_type != $arith_expression.attr_type && $arith_expression.attr_type>0 && $attr_type>0){
                System.out.println("Type Error: "+ $arith_expression.start.getLine()+": Type mismatch for the two side operands in an assignment statement.");
                $attr_type = -2;
            
             }
         }|PP_OP|MM_OP) ';' 
         | IF_TYPE '('bool_generator ')' (if_then_statements | ';')
         {
             if($bool_generator.attr_type!=4){
                 System.out.println("Type Error: "+ $bool_generator.start.getLine()+": need boolean value");
                 $attr_type = -2;
             }
         }
         | FOR_TYPE '(' (statement|';')   cmp_expression ';' (increasing_decreasing|) ')' (for_statements |';')
         {
             if($cmp_expression.attr_type!=4){
                 System.out.println("Type Error: "+ $cmp_expression.start.getLine()+": need boolean value");
                 $attr_type = -2;
             }
         }
         | WHILE_TYPE '(' bool_generator ')' (while_statements | ';')
         {
             if($bool_generator.attr_type!=4){
                 System.out.println("Type Error: "+ $bool_generator.start.getLine()+": need boolean value");
                 $attr_type = -2;
             }
         }
         | ELSE_IF_TYPE '(' bool_generator ')' if_then_statements
         {
             if($bool_generator.attr_type!=4){
                 System.out.println("Type Error: "+ $bool_generator.start.getLine()+": need boolean value");
                 $attr_type = -2;
             }
         }
         | ELSE_TYPE if_then_statements 
		 ;

if_then_statements:  statement | '{' statements '}'     
                    ;

while_statements: '{' statements '}'
                ;

for_statements: statement|'{' statements '}'
                ;

bool_generator returns[int attr_type]
            :  cmp_expression      
                {
                    $attr_type = $cmp_expression.attr_type; 
                }   
                | 'true'           
                {
                    $attr_type = 4;
                }
                | 'false'
                {
                    $attr_type = 4;
                }
                ;

cmp_expression returns [int attr_type]
            : a=arith_expression 
            {
                $attr_type = -2;
            }
            (cmp_operand b=arith_expression
            {  
                if($a.attr_type!=$b.attr_type){
                    System.out.println("Type Error: "+ $a.start.getLine()+": Type mismatch for the two side operands in an assignment statement.");
                }
                if($cmp_operand.attr_type==5){
                    $attr_type = 4;
                }
            }
            |)  
            (and_or c=cmp_expression
            {   $attr_type = -2;
                if($a.attr_type!=$b.attr_type){
                    System.out.println("Type Error: "+ $a.start.getLine()+": Type mismatch for the two side operands in an assignment statement.");
                }
                if($cmp_operand.attr_type==5){
                    $attr_type = 4;
                }
            }|) 

            ;

cmp_operand returns [int attr_type]
            : '=='  {$attr_type = 5 ;}// return $attr_type;}
            | '<='  {$attr_type = 5 ;}// return $attr_type;}
            | '>='  {$attr_type = 5 ;}// return $attr_type;}
            | '>'   {$attr_type = 5 ;}// return $attr_type;}
            | '<'   {$attr_type = 5 ;}// return $attr_type;}
            ;
and_or returns [int attr_type]
        : '&&'  {$attr_type = 5 ;}// return $attr_type;}
        | '||'  {$attr_type = 5 ;}// return $attr_type;}
        ;

increasing_decreasing returns [int attr_type]
                    : ID
                    {
                        if(symtab.containsKey($ID.text)){
                            $attr_type = symtab.get($ID.text);
                        }
                        else{
                            System.out.println("Type Error: "+ $ID.getLine()+": '"+$ID.text + "' undeclared");
                            $attr_type = -2;
                        
                        }
                    } 
                    (PP_OP |  MM_OP)  
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
