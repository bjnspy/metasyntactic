package com.google.automata.compiler.python.scanner.keywords;

public class ElseKeywordToken extends KeywordToken {
  public static final ElseKeywordToken instance = new ElseKeywordToken();

  private ElseKeywordToken() {
    super("else");
  }
}
