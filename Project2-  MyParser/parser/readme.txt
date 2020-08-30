supported token types:

    key:
        'int' 'float' 'char' 'void' 'for' 'while'

    operation:
        '+' '=' '-' '==' '>' '<' '<=' '>=' '>>' '<<' '++' '--' '!='

    number:
        every decimal number

    float number:
        every float number 

    ID
    
    quotation:
        '\'' '\"'
    
    white space:
        '\t' ' ' '\r'

    new line:
        '\n'

    seperator:
        '(' ')' '{' '}'

lexical analyzer:

    program "void main(){}"
    declarations
    arithmetic expression
    for loop
    while loop
    if then
    else if
    else
    boolen 
    comment /**/
    ++ --

how to compile:
    just type make in command line


how to execute:

    java -cp ../antlr-3.5.2-complete.jar:. testParser test1.c
    java -cp ../antlr-3.5.2-complete.jar:. testParser test2.c
    java -cp ../antlr-3.5.2-complete.jar:. testParser test3.c
    

