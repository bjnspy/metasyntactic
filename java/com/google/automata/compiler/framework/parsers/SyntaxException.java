// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.framework.parsers;

/**
 * TODO(cyrusn): javadoc
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class SyntaxException extends RuntimeException {
  public SyntaxException() {
  }

  public SyntaxException(String message) {
    super(message);
  }

  public SyntaxException(String message, Throwable cause) {
    super(message, cause);
  }

  public SyntaxException(Throwable cause) {
    super(cause);
  }
}
