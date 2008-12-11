package org.metasyntactic.automata.compiler.java.scanner.literals;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 5:41:52 PM To change this template use File |
 * Settings | File Templates.
 */
public class FalseBooleanLiteralToken extends BooleanLiteralToken {
  public static final FalseBooleanLiteralToken instance = new FalseBooleanLiteralToken();

  private FalseBooleanLiteralToken() {
    super("false");
  }

   public Boolean getValue() {
    return false;
  }

  protected Type getTokenType() {
    return Type.FalseBooleanLiteral;
  }
}