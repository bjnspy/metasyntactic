package com.google.automata.compiler.python.scanner.operators;

public class ModulusOperatorToken extends OperatorToken {
  public static ModulusOperatorToken instance = new ModulusOperatorToken();

  private ModulusOperatorToken() {
    super("%");
  }
}
