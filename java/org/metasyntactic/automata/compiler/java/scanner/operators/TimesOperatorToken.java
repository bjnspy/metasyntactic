package org.metasyntactic.automata.compiler.java.scanner.operators;

public class TimesOperatorToken extends OperatorToken {
  public final static TimesOperatorToken instance = new TimesOperatorToken();

  private TimesOperatorToken() {
    super("*");
  }

  protected Type getTokenType() {
    return Type.TimesOperator;
  }
}
