package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class ElifKeywordToken extends KeywordToken {
  public static final ElifKeywordToken instance = new ElifKeywordToken();

  private ElifKeywordToken() {
    super("elif");
  }
}
