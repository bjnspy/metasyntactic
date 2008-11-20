package org.metasyntactic.automata.compiler.python.scanner.operators;

public class AndOperatorToken extends OperatorToken {
  public static AndOperatorToken instance = new AndOperatorToken();

  private AndOperatorToken() {
    super("&");
  }
}
