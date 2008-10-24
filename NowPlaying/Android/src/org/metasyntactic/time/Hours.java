package org.metasyntactic.time;

import java.util.Calendar;
import java.util.Date;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Hours {
  private Hours() {

  }


  public static int hoursBetween(Date d1, Date d2) {
    Calendar c1 = Calendar.getInstance();
    Calendar c2 = Calendar.getInstance();

    c1.setTime(d1);
    c2.setTime(d2);

    return Math.abs(c1.get(Calendar.HOUR_OF_DAY) - c2.get(Calendar.HOUR_OF_DAY));
  }
}
