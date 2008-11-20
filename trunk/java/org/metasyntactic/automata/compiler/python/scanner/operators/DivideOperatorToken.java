package org.metasyntactic.automata.compiler.python.scanner.operators;

public class DivideOperatorToken extends OperatorToken {
  public static DivideOperatorToken instance = new DivideOperatorToken();

  private DivideOperatorToken() {
    super("/");
  }
}
