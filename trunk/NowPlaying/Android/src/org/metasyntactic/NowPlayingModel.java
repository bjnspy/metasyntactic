package org.metasyntactic;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class NowPlayingModel {
  public void update() {
    new Thread(new Runnable() {
      public void run() {
        updateBackgroundEntryPoint();
      }
    });
  }

  private void updateBackgroundEntryPoint() {
    
  }
}
