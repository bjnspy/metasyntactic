// Copyright 2008 Google Inc. All rights reserved.

package com.google.automata.compiler.framework.parsers;

import java.util.List;

/**
 * TODO(cyrusn): javadoc
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public interface Grammar {
  <T extends Token> Parser createParser(List<SourceToken<T>> tokens);
  <T extends Token> Parser createParser(List<SourceToken<T>> tokens, ActionMap<T> map);
}
