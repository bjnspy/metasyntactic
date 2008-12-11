package org.metasyntactic.automata.compiler.java.scanner.literals;

import org.metasyntactic.automata.compiler.util.UnimplementedException;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:30:23 PM To change this template use File |
 * Settings | File Templates.
 */
public class CharacterLiteralToken extends LiteralToken<Character> {
  public CharacterLiteralToken(String text) {
    super(text);
  }

   public Character getValue() {
    throw new UnimplementedException();
  }

  protected Type getTokenType() {
    return Type.CharacterLiteral;
  }
}
