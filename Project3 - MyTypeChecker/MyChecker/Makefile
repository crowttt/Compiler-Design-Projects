all: myCheckerLexer.java myCheckerLexer.java  myChecker_test.class

myCheckerLexer.java myCheckerParser.java: myChecker.g
	java -cp ../antlr-3.5.2-complete.jar org.antlr.Tool myChecker.g

myChecker_test.class: myCheckerLexer.java myCheckerParser.java myChecker_test.java
	javac -cp ../antlr-3.5.2-complete.jar myChecker_test.java myCheckerLexer.java myCheckerParser.java

clean:
	rm *.class *.tokens myCheckerLexer.java myCheckerParser.java 