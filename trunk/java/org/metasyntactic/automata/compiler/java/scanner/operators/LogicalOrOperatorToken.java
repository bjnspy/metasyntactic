package com.google.automata.compiler.java.scanner.operators;

public class LogicalOrOperatorToken extends OperatorToken {
  public final static LogicalOrOperatorToken instance = new LogicalOrOperatorToken();

  private LogicalOrOperatorToken() {
    super("||");
  }
}
