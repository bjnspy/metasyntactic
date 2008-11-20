package com.google.automata.compiler.python.scanner.operators;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 24, 2008 Time: 3:03:25 PM To change this template use File |
 * Settings | File Templates.
 */
public class RightShiftOperatorToken extends OperatorToken {
  public static RightShiftOperatorToken instance = new RightShiftOperatorToken();

  private RightShiftOperatorToken() {
    super(">>");
  }
}