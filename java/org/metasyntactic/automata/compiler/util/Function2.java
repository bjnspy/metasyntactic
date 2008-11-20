// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.util;

public interface Function2<A1, A2, R> {
  R apply(A1 a1, A2 a2);
}
