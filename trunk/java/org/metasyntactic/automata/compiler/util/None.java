// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.util;

/**
 * TODO(cyrusn): javadoc
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class None<T> implements Optional<T> {
  private static final Optional instance = new None();

  @SuppressWarnings("unchecked")
  public static <T> Optional<T> instance() {
    return instance;
  }

  private None() {
  }

   public boolean hasValue() {
    return false;
  }

   public T value() {
    throw new UnsupportedOperationException();
  }
}
