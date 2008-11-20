package com.google.automata.compiler.java.scanner.operators;

public class LogicalNotOperatorToken extends OperatorToken {
  public final static LogicalNotOperatorToken instance = new LogicalNotOperatorToken();

  private LogicalNotOperatorToken() {
    super("!");
  }
}
