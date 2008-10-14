package org.metasyntactic.threading;

import java.awt.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class ThreadingUtilities {
  private static Thread mainThread;

  public static void setMainThread(Thread mainThread) {
    ThreadingUtilities.mainThread = mainThread;
  }

  public static boolean isMainThread() {
    return EventQueue.isDispatchThread();
//    return mainThread != null && Thread.currentThread() == mainThread;
  }
}
