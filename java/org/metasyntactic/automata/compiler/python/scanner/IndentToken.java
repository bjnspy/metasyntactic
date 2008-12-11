package org.metasyntactic.automata.compiler.python.scanner;

public class IndentToken extends PythonToken {
  public static final IndentToken instance = new IndentToken();

  private IndentToken() {
    super("");
  }

   public Type getTokenType() {
    return Type.Indent;
  }

   public String toString() {
    return "Indent";
  }
}
