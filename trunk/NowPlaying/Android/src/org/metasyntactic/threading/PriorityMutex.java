package org.metasyntactic.threading;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
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
