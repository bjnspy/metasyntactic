// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers;

public abstract class AbstractSpan implements Span {
  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof Span)) {
      return false;
    }

    Span that = (Span) o;

    if (!getEndPosition().equals(that.getEndPosition())) {
      return false;
    }
    if (!getStartPosition().equals(that.getStartPosition())) {
      return false;
    }

    return true;
  }

  @Override public int hashCode() {
    int result;
    result = getStartPosition().hashCode();
    result = 31 * result + getEndPosition().hashCode();
    return result;
  }

  @Override public String toString() {
    return "(Span " + getStartPosition() + " " + getEndPosition() + ")";
  }
}
