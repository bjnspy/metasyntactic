package com.google.automata.compiler.java.parser;

import com.google.automata.compiler.framework.parsers.SourceToken;
import com.google.automata.compiler.framework.parsers.packrat.PackratParser;
import com.google.automata.compiler.java.scanner.JavaToken;

import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class JavaParser extends PackratParser<JavaToken> {
  public JavaParser(List<SourceToken<JavaToken>> tokens) {
    super(JavaGrammar.instance, tokens);
  }
}
