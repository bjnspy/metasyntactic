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


  public static <T> int size(Collection<T> collection) {
    return collection == null ? 0 : collection.size();
  }


  public static <K, V> int size(Map<K, V> map) {
    return map == null ? 0 : map.size();
  }


  public static <K, V> boolean isEmpty(Map<K, V> map) {
    return size(map) == 0;
  }


  public static <T> Collection<T> nonNullCollection(Collection<T> collection) {
    return collection == null ? Collections.EMPTY_SET : collection;
  }


  public static <T> List<T> nonNullList(List<T> list) {
    return list == null ? Collections.EMPTY_LIST : list;
  }


  public static <K, V> Map<K, V> nonNullMap(Map<K, V> map) {
    return map == null ? Collections.EMPTY_MAP : map;
  }
}
