package org.metasyntactic.automata.compiler.python.scanner.delimiters;

import org.metasyntactic.automata.compiler.python.scanner.PythonToken;

public class RightCurlyDelimiterToken extends DelimiterToken {
  public static final RightCurlyDelimiterToken instance = new RightCurlyDelimiterToken();

  private RightCurlyDelimiterToken() {
    super("}");
  }
}
