// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class SynchronizedKeywordToken extends KeywordToken {
  public static final SynchronizedKeywordToken instance = new SynchronizedKeywordToken();

  private SynchronizedKeywordToken() {
    super("synchronized");
  }

  protected Type getTokenType() {
    return Type.SynchronizedKeyword;
  }
}
