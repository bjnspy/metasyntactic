package org.metasyntactic.automata.compiler.python.scanner.delimiters;

import org.metasyntactic.automata.compiler.python.scanner.PythonToken;

public class LeftCurlyDelimiterToken extends DelimiterToken {
  public static final LeftCurlyDelimiterToken instance = new LeftCurlyDelimiterToken();

  private LeftCurlyDelimiterToken() {
    super("{");
  }
}
