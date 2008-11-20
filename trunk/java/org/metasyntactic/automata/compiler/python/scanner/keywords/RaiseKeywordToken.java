package com.google.automata.compiler.python.scanner.keywords;

public class RaiseKeywordToken extends KeywordToken {
  public static final RaiseKeywordToken instance = new RaiseKeywordToken();

  private RaiseKeywordToken() {
    super("raise");
  }
}
