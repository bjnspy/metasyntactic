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

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.Collection;

public class BoundedPrioritySet<T> {
  private final Object lock = new Object();
  private final ArrayList<T> list = new ArrayList<T>();
  private final Collection<T> set = new HashSet<T>();
  private final int maxSize;

  public BoundedPrioritySet(final int maxSize) {
    this.maxSize = maxSize;
  }

  public BoundedPrioritySet() {
    this(-1);
  }

  public void add(final T value) {
    synchronized (lock) {
      addNoLock(value);
    }
  }

  private void addNoLock(final T value) {
    if (set.add(value)) {
      list.add(value);
      if (maxSize > 0) {
        if (set.size() > maxSize) {
          removeAnyNoLock();
        }
      }
    }
  }

  public void addAll(final List<T> values) {
    synchronized (lock) {
      for (int i = values.size() - 1; i >= 0; i--) {
        addNoLock(values.get(i));
      }
    }
  }

  public T removeAny() {
    synchronized (lock) {
      return removeAnyNoLock();
    }
  }

  private T removeAnyNoLock() {
    if (list.isEmpty()) {
      return null;
    }
    final T value = list.remove(0);
    set.remove(value);
    return value;
  }

  public T removeAny(final Set<T> lowPriorityValues) {
    synchronized (lock) {
      T value = removeAnyNoLock();
      if (value != null) {
        return value;
      }

      if (!lowPriorityValues.isEmpty()) {
        final Iterator<T> iterator = lowPriorityValues.iterator();
        value = iterator.next();
        iterator.remove();
      }

      return value;
    }
  }

  public int size() {
    synchronized (lock) {
      return set.size();
    }
  }
}
