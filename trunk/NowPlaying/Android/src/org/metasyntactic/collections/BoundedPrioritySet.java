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
import java.util.HashSet;

public class BoundedPrioritySet<T> {
  private final Object lock = new Object();
  private final HashSet<T> set = new LinkedHashSet<T>();
  private final int maxSize;

  public BoundedPrioritySet(final int maxSize) {
    this.maxSize = maxSize;
  }

  public void add(final T value) {
    synchronized (this.lock) {
      this.set.remove(value);
      this.set.add(value);

      if (this.set.size() > this.maxSize) {
        removeAny();
      }
    }
  }

  public T removeAny() {
    synchronized (this.lock) {
      if (this.set.isEmpty()) {
        return null;
      }

      final Iterator<T> iterator = this.set.iterator();
      final T value = iterator.next();
      iterator.remove();

      return value;
    }
  }

  public T removeAny(final Set<T> lowPriorityValues) {
    synchronized (this.lock) {
      T value = removeAny();
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
}
