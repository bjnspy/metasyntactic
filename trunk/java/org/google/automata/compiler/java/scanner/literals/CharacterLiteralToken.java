package com.google.automata.compiler.java.scanner.literals;

import com.google.automata.compiler.util.UnimplementedException;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 22, 2008
 * Time: 6:30:23 PM
 * To change this template use File | Settings | File Templates.
 */
public class CharacterLiteralToken extends LiteralToken<Character> {
  public CharacterLiteralToken(String text) {
    super(text);
  }

  @Override public Character getValue() {
    throw new UnimplementedException();
  }
}
