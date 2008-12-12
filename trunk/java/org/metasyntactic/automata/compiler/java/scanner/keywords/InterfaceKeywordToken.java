// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class InterfaceKeywordToken extends KeywordToken {
  public static final InterfaceKeywordToken instance = new InterfaceKeywordToken();

  private InterfaceKeywordToken() {
    super("interface");
  }

  protected Type getTokenType() {
    return Type.InterfaceKeyword;
  }
}
