package org.metasyntactic.automata.compiler.python.scanner;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 22, 2008 Time: 6:33:40 PM To change this template use File |
 * Settings | File Templates.
 */
public class CommentToken extends PythonToken {
  public CommentToken(String text) {
    super(text);
  }

   public Type getTokenType() {
    return Type.Comment;
  }
}