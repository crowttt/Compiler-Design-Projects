all: myparserLexer.java myparserLexer.java  testParser.class

myparserLexer.java myparserParser.java: myparser.g
	java -cp ./antlr-3.5.2-complete.jar org.antlr.Tool myparser.g

testParser.class: myparserLexer.java myparserParser.java testParser.java
	javac -cp ./antlr-3.5.2-complete.jar testParser.java myparserLexer.java myparserParser.java

clean:
	rm *.class *.tokens myparserLexer.java myparserParser.java 
