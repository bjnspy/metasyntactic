package org.metasyntactic.automata.compiler.java.scanner.operators;

public class TimesEqualsOperatorToken extends OperatorToken {
  public final static TimesEqualsOperatorToken instance = new TimesEqualsOperatorToken();

  private TimesEqualsOperatorToken() {
    super("*=");
  }

  protected Type getTokenType() {
    return Type.TimesEqualsOperator;
  }
}
