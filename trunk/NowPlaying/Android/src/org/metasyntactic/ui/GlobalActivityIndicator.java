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

package org.metasyntactic.ui;

import static org.metasyntactic.threading.ThreadingUtilities.isBackgroundThread;
import static org.metasyntactic.threading.ThreadingUtilities.performOnMainThread;
import android.app.Activity;
import android.content.Context;

import org.metasyntactic.Application;

public class GlobalActivityIndicator {
  private static Object lock = new Object();
  private static int totalBackgroundTaskCount;
  private static int visibleBackgroundTaskCount;
  private static Context mContext;
  public GlobalActivityIndicator(Context context) {
      this.mContext = context;
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
    ((Activity)mContext).setProgressBarIndeterminateVisibility(true);      

    
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
    ((Activity)mContext).setProgressBarIndeterminateVisibility(false);  
    
   
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

      Application.refresh();
    }
  }
}