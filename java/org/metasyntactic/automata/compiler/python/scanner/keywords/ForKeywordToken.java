package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class ForKeywordToken extends KeywordToken {
  public static final ForKeywordToken instance = new ForKeywordToken();

  private ForKeywordToken() {
    super("for");
  }
}
