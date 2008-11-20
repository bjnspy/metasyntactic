// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class NativeKeywordToken extends KeywordToken {
  public static final NativeKeywordToken instance = new NativeKeywordToken();

  private NativeKeywordToken() {
    super("native");
  }
}
