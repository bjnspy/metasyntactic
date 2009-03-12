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
import org.metasyntactic.utilities.DateUtilities;
import static org.metasyntactic.utilities.StringUtilities.nonNullString;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class Theater extends AbstractPersistable implements Parcelable {
  private static final long serialVersionUID = 8020194452818140040L;
  private final String identifier;
  private final String name;
  private final String address;
  private final String phoneNumber;
  private final Location location;
  private final Location originatingLocation;
  private final Set<String> movieTitles;
  private Boolean isStale;

  public void persistTo(final PersistableOutputStream out) throws IOException {
    out.writeString(identifier);
    out.writeString(name);
    out.writeString(address);
    out.writeString(phoneNumber);
    out.writePersistable(location);
    out.writePersistable(originatingLocation);
    out.writeStringCollection(movieTitles);
  }

  public static final Reader<Theater> reader = new AbstractReader<Theater>() {
    public Theater read(final PersistableInputStream in) throws IOException {
      final String identifier = in.readString();
      final String name = in.readString();
      final String address = in.readString();
      final String phoneNumber = in.readString();
      final Location location = in.readPersistable(Location.reader);
      final Location originatingLocation = in.readPersistable(Location.reader);
      final Set<String> movieTitles = in.readStringSet();

      return new Theater(identifier, name, address, phoneNumber, location, originatingLocation, movieTitles);
    }
  };

  public Theater(final String identifier, final String name, final String address, final String phoneNumber, final Location location,
    final Location originatingLocation, final Set<String> movieTitles) {
    this.identifier = identifier;
    this.name = nonNullString(name);
    this.address = nonNullString(address);
    this.phoneNumber = nonNullString(phoneNumber);
    this.location = location;
    this.originatingLocation = originatingLocation;
    this.movieTitles = new HashSet<String>(movieTitles);
  }

  @Override
  public boolean equals(final Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof Theater)) {
      return false;
    }

    final Theater theater = (Theater)o;

    if (name != null ? !name.equals(theater.name) : theater.name != null) {
      return false;
    }

    return true;
  }

  @Override
  public int hashCode() {
    return identifier != null ? identifier.hashCode() : 0;
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

  public Boolean isStale() {
    return isStale;
  }

  public void setStale(final boolean stale) {
    isStale = stale;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(final Parcel dest, final int flags) {
    dest.writeString(identifier);
    dest.writeString(name);
    dest.writeString(address);
    dest.writeString(phoneNumber);
    dest.writeParcelable(location, 0);
    dest.writeParcelable(originatingLocation, 0);
    dest.writeStringList(new ArrayList<String>(movieTitles));
  }

  public static final Creator<Theater> CREATOR = new Creator<Theater>() {
    public Theater createFromParcel(final Parcel source) {
      final String identifier = source.readString();
      final String name = source.readString();
      final String address = source.readString();
      final String phoneNumber = source.readString();

      final Location location = source.readParcelable(null);
      final Location originatingLocation = source.readParcelable(null);
      final List<String> movieTitles = new ArrayList<String>();
      source.readStringList(movieTitles);

      return new Theater(identifier, name, address, phoneNumber, location, originatingLocation, new LinkedHashSet<String>(movieTitles));
    }

    public Theater[] newArray(final int size) {
      return new Theater[size];
    }
  };

  public static String processShowtime(final String showtime) {
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

  public static final Comparator<Theater> TITLE_ORDER = new Comparator<Theater>() {
    public int compare(final Theater m1, final Theater m2) {
      return m1.getName().compareTo(m2.getName());
    }
  };
}
