package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class InKeywordToken extends KeywordToken {
  public static final InKeywordToken instance = new InKeywordToken();

  private InKeywordToken() {
    super("in");
  }
}
