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
import org.metasyntactic.utilities.DateUtilities;
import static org.metasyntactic.utilities.StringUtilities.nonNullString;

import java.io.IOException;
import java.util.*;

public class Theater implements Parcelable, Persistable {
  private static final long serialVersionUID = 8020194452818140040L;
  private String identifier;
  private String name;
  private String address;
  private String phoneNumber;

  private Location location;
  private Location originatingLocation;
  private Set<String> movieTitles;

  public void persistTo(PersistableOutputStream out) throws IOException {
    out.writeString(identifier);
    out.writeString(name);
    out.writeString(address);
    out.writeString(phoneNumber);
    out.writePersistable(location);
    out.writePersistable(originatingLocation);
    out.writeStringCollection(movieTitles);
  }

  public static final Reader<Theater> reader = new AbstractPersistable.AbstractReader<Theater>() {
    public Theater read(PersistableInputStream in) throws IOException {
      String identifier = in.readString();
      String name = in.readString();
      String address = in.readString();
      String phoneNumber = in.readString();
      Location location = in.readPersistable(Location.reader);
      Location originatingLocation = in.readPersistable(Location.reader);
      Set<String> movieTitles = in.readStringSet();

      return new Theater(identifier, name, address, phoneNumber, location, originatingLocation, movieTitles);
    }
  };

  public Theater(String identifier, String name, String address, String phoneNumber, Location location,
                 Location originatingLocation, Set<String> movieTitles) {
    this.identifier = identifier;
    this.name = nonNullString(name);
    this.address = nonNullString(address);
    this.phoneNumber = nonNullString(phoneNumber);
    this.location = location;
    this.originatingLocation = originatingLocation;
    this.movieTitles = movieTitles;
  }

  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof Theater)) {
      return false;
    }

    Theater theater = (Theater) o;

    if (name != null ? !name.equals(theater.name) : theater.name != null) {
      return false;
    }

    return true;
  }

  public int hashCode() {
    return (identifier != null ? identifier.hashCode() : 0);
  }

  public String getIdentifier() {
    return identifier;
  }

  public String getName() {
    return name;
  }

  public String getAddress() {
    return address;
  }

  public String getPhoneNumber() {
    return phoneNumber;
  }

  public Location getLocation() {
    return location;
  }

  public Location getOriginatingLocation() {
    return originatingLocation;
  }

  public Set<String> getMovieTitles() {
    return Collections.unmodifiableSet(movieTitles);
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(Parcel dest, int flags) {
    dest.writeString(identifier);
    dest.writeString(name);
    dest.writeString(address);
    dest.writeString(phoneNumber);
    dest.writeParcelable(location, 0);
    dest.writeParcelable(originatingLocation, 0);
    dest.writeStringList(new ArrayList<String>(movieTitles));
  }

  public static final Parcelable.Creator<Theater> CREATOR = new Parcelable.Creator<Theater>() {
    public Theater createFromParcel(Parcel source) {
      String identifier = source.readString();
      String name = source.readString();
      String address = source.readString();
      String phoneNumber = source.readString();

      Location location = source.readParcelable(null);
      Location originatingLocation = source.readParcelable(null);
      List<String> movieTitles = new ArrayList<String>();
      source.readStringList(movieTitles);

      return new Theater(identifier, name, address, phoneNumber, location, originatingLocation,
                         new LinkedHashSet<String>(movieTitles));
    }

    public Theater[] newArray(int size) {
      return new Theater[size];
    }
  };

  public static String processShowtime(String showtime) {
    if (DateUtilities.use24HourTime()) {
      return showtime;
    }

    if (showtime.endsWith(" PM")) {
      return showtime.substring(0, showtime.length() - 3) + "pm";
    } else if (showtime.endsWith(" AM")) {
      return showtime.substring(0, showtime.length() - 3) + "am";
    }

    if (!showtime.endsWith("am") && !showtime.endsWith("pm")) {
      return showtime + "pm";
    }

    return showtime;
  }
}
