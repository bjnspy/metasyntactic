package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class RaiseKeywordToken extends KeywordToken {
  public static final RaiseKeywordToken instance = new RaiseKeywordToken();

  private RaiseKeywordToken() {
    super("raise");
  }
}
