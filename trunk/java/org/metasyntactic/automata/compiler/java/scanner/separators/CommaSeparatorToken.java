package org.metasyntactic.automata.compiler.java.scanner.separators;

public class CommaSeparatorToken extends SeparatorToken {
  public final static CommaSeparatorToken instance = new CommaSeparatorToken();

  private CommaSeparatorToken() {
    super(",");
  }
}
