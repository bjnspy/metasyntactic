package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class DefKeywordToken extends KeywordToken {
  public static final DefKeywordToken instance = new DefKeywordToken();

  private DefKeywordToken() {
    super("def");
  }
}
