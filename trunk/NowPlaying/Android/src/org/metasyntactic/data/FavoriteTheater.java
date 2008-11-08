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
  private String name;
  private Location originatingLocation;

  public void persistTo(PersistableOutputStream out) throws IOException {
    out.writeString(name);
    out.writePersistable(originatingLocation);
  }

  public static final Reader<FavoriteTheater> reader = new AbstractPersistable.AbstractReader<FavoriteTheater>() {
    public FavoriteTheater read(PersistableInputStream in) throws IOException {
      String name = in.readString();
      Location originatingLocation = in.readPersistable(Location.reader);
      return new FavoriteTheater(name, originatingLocation);
    }
  };

  public FavoriteTheater(String name, Location originatingLocation) {
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

  public void writeToParcel(Parcel dest, int flags) {
    dest.writeString(name);
    dest.writeParcelable(originatingLocation, 0);
  }

  public static final Parcelable.Creator<FavoriteTheater> CREATOR = new Parcelable.Creator<FavoriteTheater>() {
    public FavoriteTheater createFromParcel(Parcel source) {
      String name = source.readString();
      Location originatingLocation = source.readParcelable(null);

      return new FavoriteTheater(name, originatingLocation);
    }

    public FavoriteTheater[] newArray(int size) {
      return new FavoriteTheater[size];
    }
  };
}