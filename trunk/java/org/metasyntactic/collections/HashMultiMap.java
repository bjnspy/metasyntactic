// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package org.metasyntactic.collections;

import java.util.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class HashMultiMap<K, V> implements MultiMap<K, V> {
  private final Map<K, Collection<V>> map = new HashMap<K, Collection<V>>();

  public Collection<V> get(K key) {
    Collection<V> result = map.get(key);
    if (result == null) {
      return Collections.emptySet();
    }

    return result;
  }

  public boolean putAll(K key, Collection<? extends V> values) {
    Collection<V> collection = map.get(key);
    if (collection == null) {
      collection = new HashSet<V>();
      map.put(key, collection);
    }

    return collection.addAll(values);
  }
}
