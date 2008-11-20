// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.util;

/**
 * TODO(cyrusn): javadoc
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public interface Function4<A1,A2,A3,A4,R> {
  R apply(A1 a1, A2 a2, A3 a3, A4 a4);
}

