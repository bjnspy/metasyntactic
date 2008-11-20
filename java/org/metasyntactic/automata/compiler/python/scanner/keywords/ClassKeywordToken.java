package com.google.automata.compiler.python.scanner.keywords;

public class ClassKeywordToken extends KeywordToken {
  public static final ClassKeywordToken instance = new ClassKeywordToken();

  private ClassKeywordToken() {
    super("class");
  }
}
