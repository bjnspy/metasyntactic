package org.metasyntactic.automata.compiler.python.scanner.delimiters;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 24, 2008 Time: 4:53:21 PM To change this template use File |
 * Settings | File Templates.
 */
public class ColonDelimiterToken extends DelimiterToken {
  public static final ColonDelimiterToken instance = new ColonDelimiterToken();

  private ColonDelimiterToken() {
    super(":");
  }
}
