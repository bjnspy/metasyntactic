package org.metasyntactic.utilities;

import java.util.Collection;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class CollectionUtilities {
  private CollectionUtilities() {

  }

  public static <T> int size(Collection<T> collection) {
    return collection == null ? 0 : collection.size();
  }

  public static <K,V> int size(Map<K,V> map) {
    return map == null ? 0 : map.size();
  }

  public static <K,V> boolean isEmpty(Map<K,V> map) {
    return size(map) == 0;
  }
}
