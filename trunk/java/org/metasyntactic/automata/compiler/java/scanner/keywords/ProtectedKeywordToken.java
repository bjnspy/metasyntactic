// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class ProtectedKeywordToken extends KeywordToken {
  public static final ProtectedKeywordToken instance = new ProtectedKeywordToken();

  private ProtectedKeywordToken() {
    super("protected");
  }
}
