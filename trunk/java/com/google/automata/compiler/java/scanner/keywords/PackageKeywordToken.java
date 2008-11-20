// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class PackageKeywordToken extends KeywordToken {
  public static final PackageKeywordToken instance = new PackageKeywordToken();

  private PackageKeywordToken() {
    super("package");
  }
}
