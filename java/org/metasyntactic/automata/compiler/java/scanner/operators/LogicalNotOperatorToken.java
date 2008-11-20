package org.metasyntactic.automata.compiler.java.scanner.operators;

public class LogicalNotOperatorToken extends OperatorToken {
  public final static LogicalNotOperatorToken instance = new LogicalNotOperatorToken();

  private LogicalNotOperatorToken() {
    super("!");
  }
}
