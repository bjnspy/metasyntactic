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

import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Set;

public class BoundedPrioritySet<T> {
  private final Object lock = new Object();
  private final LinkedHashSet<T> set = new LinkedHashSet<T>();
  private final int maxSize;

  public BoundedPrioritySet(int maxSize) {
    this.maxSize = maxSize;
  }

  public void add(T value) {
    synchronized (lock) {
      set.remove(value);
      set.add(value);

      if (set.size() > maxSize) {
        removeAny();
      }
    }
  }

  public T removeAny() {
    synchronized (lock) {
      if (set.isEmpty()) {
        return null;
      }

      Iterator<T> i = set.iterator();
      T value = i.next();
      i.remove();

      return value;
    }
  }


  public T removeAny(Set<T> lowPriorityValues) {
    synchronized (lock) {
      T value = removeAny();
      if (value != null) {
        return value;
      }

      if (!lowPriorityValues.isEmpty()) {
        Iterator<T> i = lowPriorityValues.iterator();
        value = i.next();
        i.remove();
      }

      return value;
    }
  }
}
