package org.metasyntactic.common.base;

import java.util.Map;

/**
 * Created by IntelliJ IDEA. User: cyrusn Date: Jun 18, 2008 Time: 3:08:06 PM To change this template use File |
 * Settings | File Templates.
 */
public class Functions {
  private static Function<Object, Object> IDENTITY_FUNCTION = new Function<Object, Object>() {
     public Object apply(Object argument) {
      return argument;
    }
  };

  public static Function<Object, Object> identity() {
    return IDENTITY_FUNCTION;
  }

  public static <K, V> Function<K, V> forMap(final Map<K, V> map) {
    return new Function<K, V>() {
       public V apply(K argument) {
        return map.get(argument);
      }
    };
  }
}
