package org.metasyntactic.automata.compiler.java.scanner.literals;

import org.metasyntactic.automata.compiler.framework.parsers.Token;
import org.metasyntactic.automata.compiler.java.scanner.JavaToken;

import java.util.LinkedHashSet;
import java.util.Set;

public abstract class LiteralToken<T> extends JavaToken {
  private static final Set<Class<? extends Token>> tokenClasses = new LinkedHashSet<Class<? extends Token>>();

  static {
    tokenClasses.add(CharacterLiteralToken.class);
    tokenClasses.add(FalseBooleanLiteralToken.class);
    tokenClasses.add(FloatingPointLiteralToken.class);
    tokenClasses.add(IntegerLiteralToken.class);
    tokenClasses.add(NullLiteralToken.class);
    tokenClasses.add(StringLiteralToken.class);
    tokenClasses.add(TrueBooleanLiteralToken.class);
  }

  public static Set<Class<? extends Token>> getTokenClasses() {
    return tokenClasses;
  }

  protected LiteralToken(String text) {
    super(text);
  }

  public abstract T getValue();
}
