package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class ExceptKeywordToken extends KeywordToken {
  public static final ExceptKeywordToken instance = new ExceptKeywordToken();

  private ExceptKeywordToken() {
    super("except");
  }
}
