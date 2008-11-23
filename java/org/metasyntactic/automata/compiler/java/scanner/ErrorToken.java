package org.metasyntactic.automata.compiler.java.scanner;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:54:34 PM To change this template use File |
 * Settings | File Templates.
 */
public class ErrorToken extends JavaToken {
  public ErrorToken(String text) {
    super(text);
  }

  @Override protected Type getTokenType() {
    return Type.Error;
  }
}
