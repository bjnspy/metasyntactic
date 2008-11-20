package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class IfKeywordToken extends KeywordToken {
  public static final IfKeywordToken instance = new IfKeywordToken();

  private IfKeywordToken() {
    super("if");
  }
}
