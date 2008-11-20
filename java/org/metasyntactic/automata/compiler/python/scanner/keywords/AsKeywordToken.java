package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class AsKeywordToken extends KeywordToken {
  public static final AsKeywordToken instance = new AsKeywordToken();

  private AsKeywordToken() {
    super("as");
  }
}
