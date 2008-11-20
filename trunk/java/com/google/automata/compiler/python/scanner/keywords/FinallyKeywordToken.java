package com.google.automata.compiler.python.scanner.keywords;

public class FinallyKeywordToken extends KeywordToken {
  public static final FinallyKeywordToken instance = new FinallyKeywordToken();

  private FinallyKeywordToken() {
    super("finally");
  }
}
