package com.google.automata.compiler.java.scanner.operators;

public class TimesEqualsOperatorToken extends OperatorToken {
  public final static TimesEqualsOperatorToken instance = new TimesEqualsOperatorToken();

  private TimesEqualsOperatorToken() {
    super("*=");
  }
}
