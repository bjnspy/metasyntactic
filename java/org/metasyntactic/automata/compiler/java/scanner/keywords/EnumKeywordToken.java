// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner.keywords;

public class EnumKeywordToken extends KeywordToken {
  public static final EnumKeywordToken instance = new EnumKeywordToken();

  private EnumKeywordToken() {
    super("enum");
  }
}
