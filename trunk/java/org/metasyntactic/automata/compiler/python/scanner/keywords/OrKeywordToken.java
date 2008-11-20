package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class OrKeywordToken extends KeywordToken {
  public static final OrKeywordToken instance = new OrKeywordToken();

  private OrKeywordToken() {
    super("or");
  }
}
