package org.metasyntactic.automata.compiler.python.scanner;

public class DedentToken extends PythonToken {
  public static final DedentToken instance = new DedentToken();

  private DedentToken() {
    super("");
  }

   public Type getTokenType() {
    return Type.Dedent;
  }

   public String toString() {
    return "Dedent";
  }
}
