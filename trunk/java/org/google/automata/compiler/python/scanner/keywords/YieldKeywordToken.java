package com.google.automata.compiler.python.scanner.keywords;

public class YieldKeywordToken extends KeywordToken {
  public static final YieldKeywordToken instance = new YieldKeywordToken();

  private YieldKeywordToken() {
    super("yield");
  }
}
