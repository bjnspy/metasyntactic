// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.util;

/**
 * TODO(cyrusn): javadoc
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class Some<T> implements Optional<T> {
  private final T value;

  public Some(T value) {
    this.value = value;
  }

  @Override public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof Some)) {
      return false;
    }

    Some some = (Some) o;

    if (value != null ? !value.equals(some.value) : some.value != null) {
      return false;
    }

    return true;
  }

  @Override public int hashCode() {
    return (value != null ? value.hashCode() : 0);
  }

  @Override public boolean hasValue() {
    return true;
  }

  @Override public T value() {
    return value;
  }

  @Override public String toString() {
    return "(Some " + value + ")";
  }
}