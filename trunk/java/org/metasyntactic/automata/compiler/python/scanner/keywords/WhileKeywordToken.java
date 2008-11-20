package com.google.automata.compiler.python.scanner.keywords;

public class WhileKeywordToken extends KeywordToken {
  public static final WhileKeywordToken instance = new WhileKeywordToken();

  private WhileKeywordToken() {
    super("while");
  }
}
