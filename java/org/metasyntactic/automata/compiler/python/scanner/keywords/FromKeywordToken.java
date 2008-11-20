package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class FromKeywordToken extends KeywordToken {
  public static final FromKeywordToken instance = new FromKeywordToken();

  private FromKeywordToken() {
    super("from");
  }
}
