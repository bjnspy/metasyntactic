package org.metasyntactic.automata.compiler.java.scanner.literals;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 5:41:52 PM To change this template use File |
 * Settings | File Templates.
 */
public class TrueBooleanLiteralToken extends BooleanLiteralToken {
  public static final TrueBooleanLiteralToken instance = new TrueBooleanLiteralToken();

  private TrueBooleanLiteralToken() {
    super("true");
  }

  public Boolean getValue() {
    return true;
  }

  protected Type getTokenType() {
    return Type.TrueBooleanLiteral;
  }
}
