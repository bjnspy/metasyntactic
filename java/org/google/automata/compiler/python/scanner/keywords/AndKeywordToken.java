package com.google.automata.compiler.python.scanner.keywords;

public class AndKeywordToken extends KeywordToken {
  public static final AndKeywordToken instance = new AndKeywordToken();

  private AndKeywordToken() {
    super("and");
  }
}
