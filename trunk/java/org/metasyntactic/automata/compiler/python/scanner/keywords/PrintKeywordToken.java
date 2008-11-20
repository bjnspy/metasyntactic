package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class PrintKeywordToken extends KeywordToken {
  public static final PrintKeywordToken instance = new PrintKeywordToken();

  private PrintKeywordToken() {
    super("print");
  }
}
