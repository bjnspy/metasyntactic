package org.metasyntactic.automata.compiler.java.parser;

import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.framework.parsers.packrat.PackratParser;
import org.metasyntactic.automata.compiler.java.scanner.JavaToken;

import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class JavaParser extends PackratParser<JavaToken> {
  public JavaParser(List<SourceToken<JavaToken>> tokens) {
    super(JavaGrammar.instance, tokens);
  }
}
