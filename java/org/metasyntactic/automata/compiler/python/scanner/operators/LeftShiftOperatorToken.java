package org.metasyntactic.automata.compiler.python.scanner.operators;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 24, 2008 Time: 3:03:25 PM To change this template use File |
 * Settings | File Templates.
 */
public class LeftShiftOperatorToken extends OperatorToken {
  public static LeftShiftOperatorToken instance = new LeftShiftOperatorToken();

  private LeftShiftOperatorToken() {
    super("<<");
  }
}
