package org.metasyntactic.threading;

import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import org.metasyntactic.ui.GlobalActivityIndicator;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class ThreadingUtilities {
  public static boolean isMainThread() {
    return Looper.getMainLooper() == Looper.myLooper();
  }


  public static boolean isBackgroundThread() {
    return !isMainThread();
  }


  public static void performOnMainThread(Runnable runnable) {
    if (isMainThread()) {
      runnable.run();
    } else {
      new Handler(Looper.getMainLooper()).post(runnable);
    }
  }


  public static void performOnBackgroundThread(final Runnable runnable, final Object lock, final boolean visible) {
    final Object lock2 = lock == null ? new Object() : lock;

    Thread t = new HandlerThread("") {
      public void run() {
        synchronized (lock2) {
          try {
            GlobalActivityIndicator.addBackgroundTask(visible);
            runnable.run();
          } finally {
            GlobalActivityIndicator.removeBackgroundTask(visible);
          }
        }
      }
    };

    if (!visible) {
      t.setPriority(Thread.MIN_PRIORITY);
    }

    t.start();
  }
}
