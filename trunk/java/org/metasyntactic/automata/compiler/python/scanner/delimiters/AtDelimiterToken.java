package org.metasyntactic.automata.compiler.python.scanner.delimiters;

import org.metasyntactic.automata.compiler.python.scanner.PythonToken;

public class AtDelimiterToken extends DelimiterToken {
  public static final AtDelimiterToken instance = new AtDelimiterToken();

  private AtDelimiterToken() {
    super("@");
  }
}
