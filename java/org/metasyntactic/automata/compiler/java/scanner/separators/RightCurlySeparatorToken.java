package org.metasyntactic.automata.compiler.java.scanner.separators;

public class RightCurlySeparatorToken extends SeparatorToken {
  public final static RightCurlySeparatorToken instance = new RightCurlySeparatorToken();

  private RightCurlySeparatorToken() {
    super("}");
  }
}
