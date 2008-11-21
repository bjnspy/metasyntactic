package org.metasyntactic.automata.compiler.java.scanner.literals;

import org.metasyntactic.automata.compiler.java.scanner.JavaToken;

import java.util.LinkedHashSet;
import java.util.Set;

public abstract class LiteralToken<T> extends JavaToken {
  public static final Set<Class> tokenClasses = new LinkedHashSet<Class>();

  static {
    tokenClasses.add(CharacterLiteralToken.class);
    tokenClasses.add(FalseBooleanLiteralToken.class);
    tokenClasses.add(FloatingPointLiteralToken.class);
    tokenClasses.add(IntegerLiteralToken.class);
    tokenClasses.add(NullLiteralToken.class);
    tokenClasses.add(StringLiteralToken.class);
    tokenClasses.add(TrueBooleanLiteralToken.class);
  }

  protected LiteralToken(String text) {
    super(text);
  }

  public abstract T getValue();

  @Override protected Type getTokenType() {
    return type();
  }

  public static int typeValue() {
    return type().ordinal();
  }

  private static Type type() {
    return Type.Literal;
  }

  public static final LiteralToken representative = new IntegerLiteralToken("0");
}
