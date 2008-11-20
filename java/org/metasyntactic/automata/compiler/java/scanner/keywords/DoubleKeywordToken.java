// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class DoubleKeywordToken extends KeywordToken {
  public static final DoubleKeywordToken instance = new DoubleKeywordToken();

  private DoubleKeywordToken() {
    super("double");
  }
}
