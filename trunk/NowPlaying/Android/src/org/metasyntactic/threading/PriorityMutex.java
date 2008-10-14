package org.metasyntactic.threading;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class PriorityMutex {
  private final Object gate = new Object();

  private int highTaskRunningCount;


  public void lockHigh() {
    synchronized (gate) {
      highTaskRunningCount++;
    }
  }


  public void unlockHigh() {
    synchronized (gate) {
      highTaskRunningCount--;
      if (highTaskRunningCount == 0) {
        // wake up all the low pri threads that have been waiting
        gate.notifyAll();
      }
    }
  }


  public void lockLow() {
    synchronized (gate) {
      while (highTaskRunningCount > 0) {
        try {
          gate.wait();
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
