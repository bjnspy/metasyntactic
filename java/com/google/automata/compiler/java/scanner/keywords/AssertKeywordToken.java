// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class AssertKeywordToken extends KeywordToken {
  public static final AssertKeywordToken instance = new AssertKeywordToken();

  private AssertKeywordToken() {
    super("assert");
  }
}
