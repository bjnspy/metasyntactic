package com.google.automata.compiler.python.scanner.keywords;

public class GlobalKeywordToken extends KeywordToken {
  public static final GlobalKeywordToken instance = new GlobalKeywordToken();

  private GlobalKeywordToken() {
    super("global");
  }
}
