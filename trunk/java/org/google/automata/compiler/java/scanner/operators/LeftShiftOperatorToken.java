package com.google.automata.compiler.java.scanner.operators;

public class LeftShiftOperatorToken extends OperatorToken {
  public final static LeftShiftOperatorToken instance = new LeftShiftOperatorToken();

  private LeftShiftOperatorToken() {
    super("<<");
  }
}
