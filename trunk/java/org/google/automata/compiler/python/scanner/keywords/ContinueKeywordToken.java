package com.google.automata.compiler.python.scanner.keywords;

public class ContinueKeywordToken extends KeywordToken {
  public static final ContinueKeywordToken instance = new ContinueKeywordToken();

  private ContinueKeywordToken() {
    super("continue");
  }
}
