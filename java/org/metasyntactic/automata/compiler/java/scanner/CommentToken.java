package org.metasyntactic.automata.compiler.java.scanner;

import org.metasyntactic.automata.compiler.framework.parsers.Token;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:33:40 PM To change this template use File |
 * Settings | File Templates.
 */
public class CommentToken extends JavaToken {
  public CommentToken(String text) {
    super(text);
  }

  @Override protected Type getTokenType() {
    return Type.Comment;
  }

  public static final Token representative = new CommentToken("/**/");
}
