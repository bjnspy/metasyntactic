package com.google.automata.compiler.python.scanner.keywords;

public class TryKeywordToken extends KeywordToken {
  public static final TryKeywordToken instance = new TryKeywordToken();

  private TryKeywordToken() {
    super("try");
  }
}
