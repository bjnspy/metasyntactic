package com.google.automata.compiler.java.scanner.literals;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 22, 2008
 * Time: 5:35:50 PM
 * To change this template use File | Settings | File Templates.
 */
public abstract class BooleanLiteralToken extends LiteralToken<Boolean> {
  protected BooleanLiteralToken(String text) {
    super(text);
  }
}
