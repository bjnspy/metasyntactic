// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class TransientKeywordToken extends KeywordToken {
  public static final TransientKeywordToken instance = new TransientKeywordToken();

  private TransientKeywordToken() {
    super("transient");
  }
}
