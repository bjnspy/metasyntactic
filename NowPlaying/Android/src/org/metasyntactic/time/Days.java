// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package org.metasyntactic.time;

import java.util.Calendar;
import java.util.Date;

public class Days {
  private static final long MILLISECS_PER_MINUTE = 60 * 1000;
  private static final long MILLISECS_PER_HOUR = 60 * MILLISECS_PER_MINUTE;
  private static final long MILLISECS_PER_DAY = 24 * MILLISECS_PER_HOUR;

  private Days() {
  }

  private static long getUnixDay(final Calendar c) {
    final long offset = c.get(Calendar.ZONE_OFFSET) + c.get(Calendar.DST_OFFSET);
    final long day = (long) Math.floor((double) (c.getTime().getTime() + offset) / (double) MILLISECS_PER_DAY);
    return day;
  }

  public static int daysBetween(final Date d1, final Date d2) {
    final Calendar c1 = Calendar.getInstance();
    final Calendar c2 = Calendar.getInstance();
    c1.setTime(d1);
    c2.setTime(d2);

    return (int) Math.abs(getUnixDay(c1) - getUnixDay(c2));
  }
}
