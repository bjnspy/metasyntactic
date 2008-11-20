package com.google.automata.compiler.java.scanner.separators;

public class EllipsisSeparatorToken extends SeparatorToken {
  public final static EllipsisSeparatorToken instance = new EllipsisSeparatorToken();

  private EllipsisSeparatorToken() {
    super("...");
  }
}