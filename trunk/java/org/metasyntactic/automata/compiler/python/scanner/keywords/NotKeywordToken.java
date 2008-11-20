package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class NotKeywordToken extends KeywordToken {
  public static final NotKeywordToken instance = new NotKeywordToken();

  private NotKeywordToken() {
    super("not");
  }
}
