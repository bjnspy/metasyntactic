// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.scanner.keywords;

public class ImportKeywordToken extends KeywordToken {
  public static final ImportKeywordToken instance = new ImportKeywordToken();

  private ImportKeywordToken() {
    super("import");
  }
}
