package com.google.automata.compiler.python.scanner.keywords;

public class WithKeywordToken extends KeywordToken {
  public static final WithKeywordToken instance = new WithKeywordToken();

  private WithKeywordToken() {
    super("with");
  }
}
