// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class ImplementsKeywordToken extends KeywordToken {
  public static final ImplementsKeywordToken instance = new ImplementsKeywordToken();

  private ImplementsKeywordToken() {
    super("implements");
  }

  protected Type getTokenType() {
    return Type.ImplementsKeyword;
  }
}
