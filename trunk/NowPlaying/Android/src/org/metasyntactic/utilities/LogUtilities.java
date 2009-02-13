package org.metasyntactic.utilities;

import android.util.Log;

public class LogUtilities {
  private LogUtilities() {

  }

  public static void logTime(final Class<?> clazz, final String message, final long start) {
    Log.i(clazz.getName(), message + ": " + (System.currentTimeMillis() - start) / 1000.0 + 's');
  }
}