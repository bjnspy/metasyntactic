//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

package org.metasyntactic.threading;

import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.util.Log;
import org.metasyntactic.ui.GlobalActivityIndicator;

import java.util.Date;

public class ThreadingUtilities {
  public static boolean isMainThread() {
    return Looper.getMainLooper() == Looper.myLooper();
  }

  public static boolean isBackgroundThread() {
    return !isMainThread();
  }

  public static void performOnMainThread(final Runnable runnable) {
    if (isMainThread()) {
      runnable.run();
    } else {
      new Handler(Looper.getMainLooper()).post(runnable);
    }
  }

  public static void performOnBackgroundThread(final String name, final Runnable runnable, final Object lock,
                                                      final boolean visible) {
    final Thread t = new HandlerThread(name) {
      @Override
      public void run() {
        Looper.prepare();
        synchronized (lock) {
          try {
            Log.i(getClass().getSimpleName(), "Starting '" + name + "' thread at " + new Date());
            GlobalActivityIndicator.addBackgroundTask(visible);
            runnable.run();
          } finally {
            Log.i(getClass().getSimpleName(), "Stopping '" + name + "' thread at " + new Date());
            GlobalActivityIndicator.removeBackgroundTask(visible);
          }
        }
      }
    };

    t.setPriority(visible ? Thread.MIN_PRIORITY + 1: Thread.MIN_PRIORITY);

    t.start();
  }
}
