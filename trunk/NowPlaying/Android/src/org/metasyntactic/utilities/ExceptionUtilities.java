package org.metasyntactic.utilities;

import android.util.Log;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class ExceptionUtilities {
  private ExceptionUtilities() {

  }

  public static void log(Class<?> clazz, String method, Exception e) {
    Log.e(clazz.getName(), method, e);
  }
}
