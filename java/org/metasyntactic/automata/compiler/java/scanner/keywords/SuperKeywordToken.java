// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class SuperKeywordToken extends KeywordToken {
  public static final SuperKeywordToken instance = new SuperKeywordToken();

  private SuperKeywordToken() {
    super("super");
  }
}
