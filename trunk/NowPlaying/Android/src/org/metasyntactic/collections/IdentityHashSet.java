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

import java.util.AbstractSet;
import java.util.IdentityHashMap;
import java.util.Iterator;
import java.util.Map;

public class IdentityHashSet<T> extends AbstractSet<T> {
  private final Map<T, T> map = new IdentityHashMap<T, T>();

  public Iterator<T> iterator() {
    return map.keySet().iterator();
  }

  public int size() {
    return map.size();
  }

  @Override
  public boolean isEmpty() {
    return map.isEmpty();
  }

  @Override
  public boolean contains(Object o) {
    return map.containsKey(o);
  }

  @Override
  public boolean add(T t) {
    int size = size();
    map.put(t, t);
    return size != size();
  }

  @Override
  public boolean remove(Object o) {
    int size = size();
    map.remove(o);
    return size != size();
  }

  @Override
  public void clear() {
    map.clear();
  }
}
