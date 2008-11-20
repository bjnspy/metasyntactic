package com.google.automata.compiler.python.scanner.keywords;

public class PassKeywordToken extends KeywordToken {
  public static final PassKeywordToken instance = new PassKeywordToken();

  private PassKeywordToken() {
    super("pass");
  }
}
