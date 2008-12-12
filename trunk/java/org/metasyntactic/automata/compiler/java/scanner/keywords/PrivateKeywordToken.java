// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class PrivateKeywordToken extends KeywordToken {
  public static final PrivateKeywordToken instance = new PrivateKeywordToken();

  private PrivateKeywordToken() {
    super("private");
  }

  protected Type getTokenType() {
    return Type.PrivateKeyword;
  }
}
