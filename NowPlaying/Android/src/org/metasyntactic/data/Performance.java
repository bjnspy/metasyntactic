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
import org.metasyntactic.io.PersistableInputStream;
import org.metasyntactic.io.PersistableOutputStream;

import java.io.IOException;

public class Performance extends AbstractPersistable implements Parcelable {
  private static final long serialVersionUID = -3891926085016033570L;
  /*
  private final static SimpleDateFormat format = new SimpleDateFormat("h:mma");

  static {
    final DateFormatSymbols symbols = format.getDateFormatSymbols();
    symbols.setAmPmStrings(new String[]{"am", "pm"});
    format.setDateFormatSymbols(symbols);
  }
  */

  private final String time;
  private final String url;

  public void persistTo(final PersistableOutputStream out) throws IOException {
    out.writeString(time);
    out.writeString(url);
  }

  public static final Reader<Performance> reader = new AbstractReader<Performance>() {
    public Performance read(final PersistableInputStream in) throws IOException {
      final String time = in.readString();
      final String url = in.readString();

      return new Performance(time, url);
    }
  };

  public Performance(final String time, final String url) {
    this.time = time;
    this.url = url;
  }

  public String getTime() {
    return time;
  }

  public String getUrl() {
    return url;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(final Parcel dest, final int flags) {
    dest.writeValue(time);
    dest.writeString(url);
  }

  public static final Creator<Performance> CREATOR = new Creator<Performance>() {
    public Performance createFromParcel(final Parcel source) {
      final String time = source.readString();
      final String url = source.readString();
      return new Performance(time, url);
    }

    public Performance[] newArray(final int size) {
      return new Performance[size];
    }
  };
}
