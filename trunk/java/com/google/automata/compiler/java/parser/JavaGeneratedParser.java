// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.java.parser;

import com.google.automata.compiler.framework.parsers.Token;
import com.google.automata.compiler.framework.parsers.SourceToken;
import com.google.automata.compiler.util.Tuple3;

import java.util.List;

/**
 * TODO(cyrusn): javadoc
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class JavaGeneratedParser extends AbstractJavaGeneratedParser {
  public JavaGeneratedParser(List<SourceToken<Token>> tokens) {
    super(tokens);
  }

  @Override protected EvaluationResult anyToken(int position) {
    if (position >= tokens.size()) {
      return EvaluationResult.failure;
    } else {
      return new EvaluationResult(true, position + 1, tokens.get(position));
    }
  }
}
