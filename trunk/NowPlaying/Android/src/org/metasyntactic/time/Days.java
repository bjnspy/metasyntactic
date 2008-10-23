package org.metasyntactic.time;

import java.util.Calendar;
import java.util.Date;


/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Days {
  private static final long MILLISECS_PER_MINUTE = 60 * 1000;
  private static final long MILLISECS_PER_HOUR = 60 * MILLISECS_PER_MINUTE;
  private static final long MILLISECS_PER_DAY = 24 * MILLISECS_PER_HOUR;


  private Days() {

  }


  private static long getUnixDay(Calendar c) {
    long offset = c.get(Calendar.ZONE_OFFSET) + c.get(Calendar.DST_OFFSET);
    long day = (long) Math.floor((double) (c.getTime().getTime() + offset) / ((double) MILLISECS_PER_DAY));
    return day;
  }


  public static int daysBetween(Date d1, Date d2) {
    Calendar c1 = Calendar.getInstance();
    Calendar c2 = Calendar.getInstance();
    c1.setTime(d1);
    c2.setTime(d2);

    return (int) Math.abs(getUnixDay(c1) - getUnixDay(c2));
  }
}
