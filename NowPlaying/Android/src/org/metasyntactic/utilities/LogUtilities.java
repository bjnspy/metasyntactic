package org.metasyntactic.utilities;

import android.util.Log;

public class LogUtilities {
  public static void logTime(Class<?> clazz, String message, long start) {
    Log.i(clazz.getName(), message + ": " + (((double) (System.currentTimeMillis() - start)) / 1000.0) + "s");
  }
}
