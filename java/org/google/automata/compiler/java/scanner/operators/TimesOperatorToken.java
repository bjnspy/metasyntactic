package com.google.automata.compiler.java.scanner.operators;

public class TimesOperatorToken extends OperatorToken {
  public final static TimesOperatorToken instance = new TimesOperatorToken();

  private TimesOperatorToken() {
    super("*");
  }
}
