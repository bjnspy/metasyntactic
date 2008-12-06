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

package org.metasyntactic.data;

import android.os.Parcel;
import android.os.Parcelable;
import org.metasyntactic.io.AbstractPersistable;
import org.metasyntactic.io.Persistable;
import org.metasyntactic.io.PersistableInputStream;
import org.metasyntactic.io.PersistableOutputStream;

import java.io.IOException;
import java.text.DateFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Performance implements Parcelable, Persistable {
  private static final long serialVersionUID = -3891926085016033570L;
  private final static SimpleDateFormat format = new SimpleDateFormat("h:mma");

  static {
    DateFormatSymbols symbols = format.getDateFormatSymbols();
    symbols.setAmPmStrings(new String[] {"am", "pm"});
    format.setDateFormatSymbols(symbols);
  }

  private final Date time;
  private final String url;

  public void persistTo(PersistableOutputStream out) throws IOException {
    out.writeDate(time);
    out.writeString(url);
  }

  public static final Reader<Performance> reader = new AbstractPersistable.AbstractReader<Performance>() {
    public Performance read(PersistableInputStream in) throws IOException {
      Date time = in.readDate();
      String url = in.readString();

      return new Performance(time, url);
    }
  };

  public Performance(Date time, String url) {
    this.time = time;
    this.url = url;
  }

  public Date getTime() {
    return time;
  }

  public String getTimeString() {
    return format.format(getTime());
  }

  public String getUrl() {
    return url;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(Parcel dest, int flags) {
    dest.writeValue(time);
    dest.writeString(url);
  }

  public static final Parcelable.Creator<Performance> CREATOR = new Parcelable.Creator<Performance>() {
    public Performance createFromParcel(Parcel source) {
      Date time = (Date) source.readValue(Date.class.getClassLoader());
      String url = source.readString();
      return new Performance(time, url);
    }

    public Performance[] newArray(int size) {
      return new Performance[size];
    }
  };
}
