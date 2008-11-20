package com.google.automata.compiler.python.scanner.keywords;

public class AssertKeywordToken extends KeywordToken {
  public static final AssertKeywordToken instance = new AssertKeywordToken();

  private AssertKeywordToken() {
    super("assert");
  }
}
