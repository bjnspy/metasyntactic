// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class PublicKeywordToken extends KeywordToken {
  public static final PublicKeywordToken instance = new PublicKeywordToken();

  private PublicKeywordToken() {
    super("public");
  }

  protected Type getTokenType() {
    return Type.PublicKeyword;
  }
}
