// Copyright 2008 Google Inc. All rights reserved.

package org.metasyntactic.automata.compiler.framework.parsers;

import org.metasyntactic.automata.compiler.util.Function4;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * TODO(cyrusn): javadoc
 *
 * @author cyrusn@google.com (Cyrus Najmabadi)
 */
public class ActionMap<T extends Token> {
  public final static ActionMap EMPTY_MAP = new ActionMap(Collections.EMPTY_MAP);

  private final Map<String, Function4<Object, List<SourceToken<T>>, Integer, Integer, Object>> actions = new LinkedHashMap<String, Function4<Object, List<SourceToken<T>>, Integer, Integer, Object>>();

  public ActionMap(Map<String, Function4<Object, List<SourceToken<T>>, Integer, Integer, Object>> map) {
    actions.putAll(map);
  }

  public Function4<Object, List<SourceToken<T>>, Integer, Integer, Object> get(String variable) {
    return actions.get(variable);
  }
}


