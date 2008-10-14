package org.metasyntactic.utilities;

import org.joda.time.DateTime;

import java.util.Date;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class DateUtilities {
  private static Date today;

  static {
    DateTime dt = new DateTime(new Date());
    today = new DateTime(dt.getYear(), dt.getMonthOfYear(), dt.getDayOfMonth(), 12, 0, 0, 0).toDate();
  }


  public static Date getToday() {
    return today;
  }


  public static boolean use24HourTime() {
    return false;
  }
}
