package com.google.automata.compiler.python.scanner.keywords;

public class DelKeywordToken extends KeywordToken {
  public static final DelKeywordToken instance = new DelKeywordToken();

  private DelKeywordToken() {
    super("del");
  }
}
