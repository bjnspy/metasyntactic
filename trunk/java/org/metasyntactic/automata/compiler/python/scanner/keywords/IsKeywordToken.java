package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class IsKeywordToken extends KeywordToken {
  public static final IsKeywordToken instance = new IsKeywordToken();

  private IsKeywordToken() {
    super("is");
  }
}
