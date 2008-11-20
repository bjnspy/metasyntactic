// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class ReturnKeywordToken extends KeywordToken {
  public static final ReturnKeywordToken instance = new ReturnKeywordToken();

  private ReturnKeywordToken() {
    super("return");
  }
}
