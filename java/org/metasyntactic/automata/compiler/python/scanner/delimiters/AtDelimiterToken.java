package com.google.automata.compiler.python.scanner.delimiters;

import com.google.automata.compiler.python.scanner.PythonToken;

public class AtDelimiterToken extends DelimiterToken {
  public static final AtDelimiterToken instance = new AtDelimiterToken();

  private AtDelimiterToken() {
    super("@");
  }
}
