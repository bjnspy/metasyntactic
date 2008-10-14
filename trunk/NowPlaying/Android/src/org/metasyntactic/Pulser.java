package org.metasyntactic;

import android.os.Handler;

import java.util.Date;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Pulser {
  private final Runnable runnable;
  private Date lastPulseTime;
  private long pulseInterval;


  public Pulser(Runnable runnable, long pulseInterval) {
    this.lastPulseTime = new Date(0);
    this.runnable = runnable;
    this.pulseInterval = pulseInterval;
  }


  public void tryPulse(final Date date) {
    if (date.before(lastPulseTime)) {
      // we sent out a pulse after this one.  just disregard this pulse
      //NSLog(@"Pulse at '%@' < last pulse at '%@'.  Disregarding.", date, lastPulseTime);
      return;
    }

    Date now = new Date();
    Date nextViablePulseTime = new Date(lastPulseTime.getTime() + pulseInterval);
    if (now.before(nextViablePulseTime)) {
      // too soon since the last pulse.  wait until later.
      //NSLog(@"Pulse at '%@' too soon since last pulse at '%@'.  Will perform later.", date, lastPulseTime);
      Runnable tryPulseLater = new Runnable() {
        public void run() {
          tryPulse(date);
        }
      };

      new Handler().postAtTime(tryPulseLater, nextViablePulseTime.getTime());
      return;
    }

    // ok, actually pulse.
    this.lastPulseTime = now;
    //NSLog(@"Pulse at '%@' being performed at '%@'.", date, lastPulseTime);
    runnable.run();
  }


  public void forcePulse() {
    //NSAssert([NSThread isMainThread], @"");
    this.lastPulseTime = new Date();
    //NSLog(@"Forced pulse at '%@'.", lastPulseTime);
    //[target performSelector:action];
    runnable.run();
  }


  public void tryPulse() {
    //NSAssert([NSThread isMainThread], @"");
    tryPulse(new Date());
  }
}
