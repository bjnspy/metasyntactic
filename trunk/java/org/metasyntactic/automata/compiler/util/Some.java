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

   public boolean equals(Object o) {
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

   public int hashCode() {
    return (value != null ? value.hashCode() : 0);
  }

   public boolean hasValue() {
    return true;
  }

   public T value() {
    return value;
  }

   public String toString() {
    return "(Some " + value + ")";
  }
}