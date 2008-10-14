package org.metasyntactic.ui;

import static org.metasyntactic.threading.ThreadingUtilities.isBackgroundThread;
import static org.metasyntactic.threading.ThreadingUtilities.performOnMainThread;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class GlobalActivityIndicator {
  private static Object lock = new Object();
  private static int totalBackgroundTaskCount;
  private static int visibleBackgroundTaskCount;


  public GlobalActivityIndicator() {
  }


  private static void startIndicator() {
    if (isBackgroundThread()) {
      performOnMainThread(new Runnable() {
        public void run() {
          startIndicator();
        }
      });

      return;
    }

    // Do work here
  }


  private static void stopIndicator() {
    if (isBackgroundThread()) {
      performOnMainThread(new Runnable() {
        public void run() {
          stopIndicator();
        }
      });

      return;
    }

    // Do work here
  }


  private static void startNetworkIndicator() {
    if (isBackgroundThread()) {
      performOnMainThread(new Runnable() {
        public void run() {
          startNetworkIndicator();
        }
      });

      return;
    }

    // Do work here
  }


  private static void stopNetworkIndicator() {
    if (isBackgroundThread()) {
      performOnMainThread(new Runnable() {
        public void run() {
          stopNetworkIndicator();
        }
      });

      return;
    }

    // Do work here
  }


  public static void addBackgroundTask(boolean visible) {
    synchronized (lock) {
      totalBackgroundTaskCount++;

      if (visible) {
        visibleBackgroundTaskCount++;

        if (visibleBackgroundTaskCount == 1) {
          startIndicator();
        }
      }

      if (totalBackgroundTaskCount == 1) {
        startNetworkIndicator();
      }
    }
  }


  public static void removeBackgroundTask(boolean visible) {
    synchronized (lock) {
      totalBackgroundTaskCount--;

      if (visible) {
        visibleBackgroundTaskCount--;

        if (visibleBackgroundTaskCount == 0) {
          stopIndicator();
        }
      }

      if (totalBackgroundTaskCount == 0) {
        stopNetworkIndicator();
      }

      //[NowPlayingAppDelegate refresh];
    }
  }
}