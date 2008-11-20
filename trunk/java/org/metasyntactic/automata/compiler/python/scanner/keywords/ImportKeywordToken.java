package org.metasyntactic.automata.compiler.python.scanner.keywords;

public class ImportKeywordToken extends KeywordToken {
  public static final ImportKeywordToken instance = new ImportKeywordToken();

  private ImportKeywordToken() {
    super("import");
  }
}
