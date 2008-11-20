package com.google.automata.compiler.python.scanner.operators;

public class TruncatingDivideOperatorToken extends OperatorToken {
  public static TruncatingDivideOperatorToken instance = new TruncatingDivideOperatorToken();

  private TruncatingDivideOperatorToken() {
    super("//");
  }
}
