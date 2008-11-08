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

public class PriorityMutex {
  private final Object lock = new Object();

  private int highTaskRunningCount;


  public void lockHigh() {
    synchronized (lock) {
      highTaskRunningCount++;
    }
  }


  public void unlockHigh() {
    synchronized (lock) {
      highTaskRunningCount--;
      if (highTaskRunningCount == 0) {
        // wake up all the low pri threads that have been waiting
        lock.notifyAll();
      }
    }
  }


  public void lockLow() {
    synchronized (lock) {
      while (highTaskRunningCount > 0) {
        try {
          lock.wait();
        } catch (InterruptedException e) {
          throw new RuntimeException(e);
        }
      }
    }
  }


  public void unlockLow() {
  }


  public void lock(boolean high) {
    if (high) {
      lockHigh();
    } else {
      lockLow();
    }
  }


  public void unlock(boolean high) {
    if (high) {
      unlockHigh();
    } else {
      unlockLow();
    }
  }
}
