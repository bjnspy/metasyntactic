// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.java.scanner;

import org.metasyntactic.automata.compiler.framework.parsers.SourceToken;

import java.util.ArrayList;
import java.util.List;

/**
 * TODO(cyrusn): javadoc
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class JavaLexicalAnalyzer {
  public List<SourceToken<JavaToken>> analyze(List<SourceToken<JavaToken>> tokens) {
    List<SourceToken<JavaToken>> result = new ArrayList<SourceToken<JavaToken>>();

    for (SourceToken<JavaToken> sourceToken : tokens) {
      JavaToken token = sourceToken.getToken();

      if (!(token instanceof CommentToken ||
          token instanceof WhitespaceToken ||
          token instanceof ErrorToken)) {
        result.add(sourceToken);
      }
    }

    return result;
  }
}