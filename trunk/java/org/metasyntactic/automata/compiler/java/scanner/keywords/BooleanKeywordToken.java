// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class BooleanKeywordToken extends KeywordToken {
  public static final BooleanKeywordToken instance = new BooleanKeywordToken();

  private BooleanKeywordToken() {
    super("boolean");
  }
}
