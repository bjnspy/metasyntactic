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
import org.metasyntactic.utilities.StringUtilities;

import java.io.IOException;

public class FavoriteTheater implements Parcelable, Persistable {
  private static final long serialVersionUID = 7339380828909301638L;
  private final String name;
  private final Location originatingLocation;

  public void persistTo(final PersistableOutputStream out) throws IOException {
    out.writeString(name);
    out.writePersistable(originatingLocation);
  }

  public static final Reader<FavoriteTheater> reader = new AbstractPersistable.AbstractReader<FavoriteTheater>() {
    public FavoriteTheater read(final PersistableInputStream in) throws IOException {
      final String name = in.readString();
      final Location originatingLocation = in.readPersistable(Location.reader);
      return new FavoriteTheater(name, originatingLocation);
    }
  };

  public FavoriteTheater(final String name, final Location originatingLocation) {
    this.name = StringUtilities.nonNullString(name);
    this.originatingLocation = originatingLocation;
  }

  public String getName() {
    return name;
  }

  public Location getOriginatingLocation() {
    return originatingLocation;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(final Parcel dest, final int flags) {
    dest.writeString(name);
    dest.writeParcelable(originatingLocation, 0);
  }

  public static final Creator<FavoriteTheater> CREATOR = new Creator<FavoriteTheater>() {
    public FavoriteTheater createFromParcel(final Parcel source) {
      final String name = source.readString();
      final Location originatingLocation = source.readParcelable(null);

      return new FavoriteTheater(name, originatingLocation);
    }

    public FavoriteTheater[] newArray(final int size) {
      return new FavoriteTheater[size];
    }
  };
}