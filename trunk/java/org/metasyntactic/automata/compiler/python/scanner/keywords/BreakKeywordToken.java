package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class BreakKeywordToken extends KeywordToken {
  public static final BreakKeywordToken instance = new BreakKeywordToken();

  private BreakKeywordToken() {
    super("break");
  }
}
