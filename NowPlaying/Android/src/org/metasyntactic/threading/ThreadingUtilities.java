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


  public static void performOnBackgroundThread(Runnable runnable, Object lock, boolean visible) {
    performOnBackgroundThread(runnable, lock, visible, true);
  }


  public static void performOnBackgroundThread(final Runnable runnable, final Object lock, final boolean visible,
                                               final boolean lowPriority) {
    final Object lock2 = lock == null ? new Object() : lock;

    Thread t = new HandlerThread("") {
      public void run() {
        synchronized (lock2) {
          try {
            GlobalActivityIndicator.addBackgroundTask(lowPriority);
            runnable.run();
          } finally {
            GlobalActivityIndicator.removeBackgroundTask(lowPriority);
          }
        }
      }
    };

    if (lowPriority) {
      t.setPriority(Thread.MIN_PRIORITY);
    }

    t.start();
  }
}
