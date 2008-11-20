package com.google.automata.compiler.java.scanner.separators;

public class LeftCurlySeparatorToken extends SeparatorToken {
  public final static LeftCurlySeparatorToken instance = new LeftCurlySeparatorToken();

  private LeftCurlySeparatorToken() {
    super("{");
  }
}
