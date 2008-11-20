// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class ThisKeywordToken extends KeywordToken {
  public static final ThisKeywordToken instance = new ThisKeywordToken();

  private ThisKeywordToken() {
    super("this");
  }
}
