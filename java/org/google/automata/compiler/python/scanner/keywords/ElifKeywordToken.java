package com.google.automata.compiler.python.scanner.keywords;

public class ElifKeywordToken extends KeywordToken {
  public static final ElifKeywordToken instance = new ElifKeywordToken();

  private ElifKeywordToken() {
    super("elif");
  }
}
