// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.util;

import org.metasyntactic.common.base.Pair;

/**
 * TODO(cyrusn): javadoc
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class Tuple3<A, B, C> extends Pair<A, B> {
  private final C third;

  public Tuple3(A first, B second, C third) {
    super(first, second);
    this.third = third;
  }

  public C getThird() {
    return third;
  }

   public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof Tuple3)) {
      return false;
    }
    if (!super.equals(o)) {
      return false;
    }

    Tuple3 tuple3 = (Tuple3) o;

    if (third != null ? !third.equals(tuple3.third) : tuple3.third != null) {
      return false;
    }

    return true;
  }

   public int hashCode() {
    int result = super.hashCode();
    result = 31 * result + (third != null ? third.hashCode() : 0);
    return result;
  }
}
