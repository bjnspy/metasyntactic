//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

package org.metasyntactic.utilities;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class CollectionUtilities {
  private CollectionUtilities() {
  }

  public static <T> int size(final Collection<T> collection) {
    return collection == null ? 0 : collection.size();
  }

  public static <T> boolean isEmpty(final Collection<T> collection) {
    return size(collection) == 0;
  }

  public static <K, V> int size(final Map<K, V> map) {
    return map == null ? 0 : map.size();
  }

  public static <K, V> boolean isEmpty(final Map<K, V> map) {
    return size(map) == 0;
  }

  public static <T> Collection<T> nonNullCollection(final Collection<T> collection) {
    if (collection == null) {
      return Collections.emptySet();
    }

    return collection;
  }

  public static <T> List<T> nonNullList(final List<T> list) {
    if (list == null) {
      return Collections.emptyList();
    }

    return list;
  }

  public static <K, V> Map<K, V> nonNullMap(final Map<K, V> map) {
    if (map == null) {
      return Collections.emptyMap();
    }

    return map;
  }
}
