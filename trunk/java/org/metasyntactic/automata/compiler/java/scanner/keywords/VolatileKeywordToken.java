// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class VolatileKeywordToken extends KeywordToken {
  public static final VolatileKeywordToken instance = new VolatileKeywordToken();

  private VolatileKeywordToken() {
    super("volatile");
  }
}
