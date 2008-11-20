package org.metasyntactic.automata.compiler.java.scanner.literals;

import org.metasyntactic.automata.compiler.util.UnimplementedException;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 22, 2008
 * Time: 6:46:01 PM
 * To change this template use File | Settings | File Templates.
 */
public class IntegerLiteralToken extends LiteralToken<Long> {
  public IntegerLiteralToken(String text) {
    super(text);
  }

  @Override public Long getValue() {
    throw new UnimplementedException();
  }
}
