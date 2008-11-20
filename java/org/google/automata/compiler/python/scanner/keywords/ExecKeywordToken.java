package com.google.automata.compiler.python.scanner.keywords;

public class ExecKeywordToken extends KeywordToken {
  public static final ExecKeywordToken instance = new ExecKeywordToken();

  private ExecKeywordToken() {
    super("exec");
  }
}
