// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.parser;

import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;
import org.metasyntactic.automata.compiler.framework.parsers.Token;

import java.util.List;

/**
 * TODO(cyrusn): javadoc
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class JavaGeneratedParser extends AbstractJavaGeneratedParser {
  public JavaGeneratedParser(List<SourceToken<Token>> tokens) {
    super(tokens);
  }

   protected EvaluationResult anyToken(int position) {
    if (position >= tokens.size()) {
      return EvaluationResult.failure;
    } else {
      return new EvaluationResult(true, position + 1, tokens.get(position));
    }
  }
}
