package com.google.automata.compiler.java.scanner.literals;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 22, 2008
 * Time: 6:54:57 PM
 * To change this template use File | Settings | File Templates.
 */
public class NullLiteralToken extends LiteralToken<Object> {
  public static final NullLiteralToken instance = new NullLiteralToken();

  private NullLiteralToken() {
    super("null");
  }

  @Override public Object getValue() {
    return null;
  }
}
