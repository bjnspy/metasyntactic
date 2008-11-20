package com.google.automata.compiler.python.scanner.keywords;

public class ReturnKeywordToken extends KeywordToken {
  public static final ReturnKeywordToken instance = new ReturnKeywordToken();

  private ReturnKeywordToken() {
    super("return");
  }
}
