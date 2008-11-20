package org.metasyntactic.automata.compiler.framework.parsers;

import org.metasyntactic.common.base.Preconditions;

/**
 * Created by IntelliJ IDEA.
 * User: cyrusn
 * Date: Jun 22, 2008
 * Time: 3:59:48 PM
 * To change this template use File | Settings | File Templates.
 */
public class SourceToken<T extends Token> {
  private final T token;
  private final Span span;

  public SourceToken(T token, Span span) {
    Preconditions.checkNotNull(token);
    Preconditions.checkNotNull(span);
    this.token = token;
    this.span = span;
  }

  public T getToken() {
    return token;
  }

  public Span getSpan() {
    return span;
  }

  @Override public boolean equals(Object o) {
    if (this == o) return true;
    if (!(o instanceof SourceToken)) return false;

    SourceToken that = (SourceToken) o;

    if (!span.equals(that.span)) return false;
    if (!token.equals(that.token)) return false;

    return true;
  }

  @Override public int hashCode() {
    int result;
    result = token.hashCode();
    result = 31 * result + span.hashCode();
    return result;
  }

  @Override public String toString() {
    return "(SourceToken " + getToken() + ")";
  }
}

