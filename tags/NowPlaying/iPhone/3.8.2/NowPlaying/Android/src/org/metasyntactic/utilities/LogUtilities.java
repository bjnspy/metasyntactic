package org.metasyntactic.utilities;

import android.util.Log;

public class LogUtilities {
  private static final boolean isLogging = true;

  private LogUtilities() {

  }

  public static void logTime(final Class<?> clazz, final String message, final long start) {
    i(clazz.getName(), message + ": " + (System.currentTimeMillis() - start) / 1000.0 + 's');
  }

  public static void i(final String tag, final String msg) {
    if (isLogging) {
      Log.i(tag, msg);
    }
  }
}