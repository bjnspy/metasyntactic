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

public class DVD extends AbstractPersistable implements Parcelable {
  private static final long serialVersionUID = 646917504411422447L;

  private final String canonicalTitle;
  private final String price;
  private final String format;
  private final String discs;
  private final String url;

  public void persistTo(final PersistableOutputStream out) throws IOException {
    out.writeString(canonicalTitle);
    out.writeString(price);
    out.writeString(format);
    out.writeString(discs);
    out.writeString(url);
  }

  public static final Reader<DVD> reader = new AbstractReader<DVD>() {
    public DVD read(final PersistableInputStream in) throws IOException {
      final String canonicalTitle = in.readString();
      final String price = in.readString();
      final String format = in.readString();
      final String discs = in.readString();
      final String url = in.readString();
      return new DVD(canonicalTitle, price, format, discs, url, true);
    }
  };

  private DVD(final String canonicalTitle, final String price, final String format, final String discs, final String url, final boolean ignored) {
    this.canonicalTitle = canonicalTitle;
    this.price = price;
    this.format = format;
    this.discs = discs;
    this.url = url;
  }

  public DVD(final String title, final String price, final String format, final String discs, final String url) {
    this(Movie.makeCanonical(title), price, format, discs, url, true);
  }

  public String getCanonicalTitle() {
    return canonicalTitle;
  }

  public String getPrice() {
    return price;
  }

  public String getFormat() {
    return format;
  }

  public String getDiscs() {
    return discs;
  }

  public String getUrl() {
    return url;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(final Parcel out, final int flags) {
    out.writeString(canonicalTitle);
    out.writeString(price);
    out.writeString(format);
    out.writeString(discs);
    out.writeString(url);
  }

  public static final Creator<DVD> CREATOR = new Creator<DVD>() {
    public DVD createFromParcel(final Parcel in) {
      final String canonicalTitle = in.readString();
      final String price = in.readString();
      final String format = in.readString();
      final String discs = in.readString();
      final String url = in.readString();
      return new DVD(canonicalTitle, price, format, discs, url, true);
    }

    public DVD[] newArray(final int size) {
      return new DVD[size];
    }
  };
}