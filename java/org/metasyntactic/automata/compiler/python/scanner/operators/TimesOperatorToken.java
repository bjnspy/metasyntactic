package com.google.automata.compiler.python.scanner.operators;

public class TimesOperatorToken extends OperatorToken {
  public static TimesOperatorToken instance = new TimesOperatorToken();

  private TimesOperatorToken() {
    super("*");
  }
}
