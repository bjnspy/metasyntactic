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
package org.metasyntactic.utilities;

import java.util.Calendar;
import java.util.Date;

public class DateUtilities {
  private static final Date today;

  static {
    final Date dt = new Date();
    final Calendar c1 = Calendar.getInstance();
    c1.setTime(dt);

    final Calendar c2 = Calendar.getInstance();
    c2.clear();

    c2.set(Calendar.YEAR, c1.get(Calendar.YEAR));
    c2.set(Calendar.MONTH, c1.get(Calendar.MONTH));
    c2.set(Calendar.DAY_OF_MONTH, c1.get(Calendar.DAY_OF_MONTH));
    c2.set(Calendar.HOUR_OF_DAY, 12);

    today = c2.getTime();
  }

  private DateUtilities() {

  }

  public static Date getToday() {
    return today;
  }

  public static boolean use24HourTime() {
    return false;
  }
}
