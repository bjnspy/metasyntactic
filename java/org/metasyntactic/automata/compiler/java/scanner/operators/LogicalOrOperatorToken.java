package org.metasyntactic.automata.compiler.java.scanner.operators;

public class LogicalOrOperatorToken extends OperatorToken {
  public final static LogicalOrOperatorToken instance = new LogicalOrOperatorToken();

  private LogicalOrOperatorToken() {
    super("||");
  }

  protected Type getTokenType() {
    return Type.LogicalOrOperator;
  }
}
