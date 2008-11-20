package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class LambdaKeywordToken extends KeywordToken {
  public static final LambdaKeywordToken instance = new LambdaKeywordToken();

  private LambdaKeywordToken() {
    super("lambda");
  }
}
