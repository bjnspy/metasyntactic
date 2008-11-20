package com.google.automata.compiler.python.scanner.delimiters;

public class ModulusEqualsDelimiterToken extends DelimiterToken {
  public static final ModulusEqualsDelimiterToken instance = new ModulusEqualsDelimiterToken();

  private ModulusEqualsDelimiterToken() {
    super("%=");
  }
}
