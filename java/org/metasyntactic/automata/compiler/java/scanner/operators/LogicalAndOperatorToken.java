package org.metasyntactic.automata.compiler.java.scanner.operators;

public class LogicalAndOperatorToken extends OperatorToken {
  public final static LogicalAndOperatorToken instance = new LogicalAndOperatorToken();

  private LogicalAndOperatorToken() {
    super("&&");
  }
}
