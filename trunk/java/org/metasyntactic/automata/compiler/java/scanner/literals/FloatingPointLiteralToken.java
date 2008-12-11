package org.metasyntactic.automata.compiler.java.scanner.literals;

import org.metasyntactic.automata.compiler.util.UnimplementedException;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:35:14 PM To change this template use File |
 * Settings | File Templates.
 */
public class FloatingPointLiteralToken extends LiteralToken<Double> {
  public FloatingPointLiteralToken(String text) {
    super(text);
  }

   public Double getValue() {
    throw new UnimplementedException();
  }
}
