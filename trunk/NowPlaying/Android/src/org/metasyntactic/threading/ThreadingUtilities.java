package org.metasyntactic.threading;

import android.os.Looper;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class ThreadingUtilities {
  public static boolean isMainThread() {
    return Looper.getMainLooper() == Looper.myLooper();
  }
}
