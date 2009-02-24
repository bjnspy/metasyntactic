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
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.io.AbstractPersistable;
import org.metasyntactic.io.PersistableInputStream;
import org.metasyntactic.io.PersistableOutputStream;
import static org.metasyntactic.utilities.StringUtilities.nonNullString;

import java.io.IOException;
import static java.lang.Math.PI;
import static java.lang.Math.acos;
import static java.lang.Math.cos;
import static java.lang.Math.sin;

public class Location extends AbstractPersistable implements Parcelable {
  private static final long serialVersionUID = 5329395050075385028L;
  private final double latitude;
  private final double longitude;
  private final String address;
  private final String city;
  private final String state;
  private final String postalCode;
  private final String country;

  public void persistTo(final PersistableOutputStream out) throws IOException {
    out.writeDouble(latitude);
    out.writeDouble(longitude);
    out.writeString(address);
    out.writeString(city);
    out.writeString(state);
    out.writeString(postalCode);
    out.writeString(country);
  }

  public static final Reader<Location> reader = new AbstractReader<Location>() {
    public Location read(final PersistableInputStream in) throws IOException {
      final double latitude = in.readDouble();
      final double longitude = in.readDouble();
      final String address = in.readString();
      final String city = in.readString();
      final String state = in.readString();
      final String postalCode = in.readString();
      final String country = in.readString();
      return new Location(latitude, longitude, address, city, state, postalCode, country);
    }
  };

  public Location(final double latitude, final double longitude, final String address, final String city,
    final String state, final String postalCode, final String country) {
    this.latitude = latitude;
    this.longitude = longitude;
    this.address = nonNullString(address);
    this.city = nonNullString(city);
    this.state = nonNullString(state);
    this.postalCode = nonNullString(postalCode);
    this.country = nonNullString(country);
  }

  public double getLatitude() {
    return latitude;
  }

  public double getLongitude() {
    return longitude;
  }

  public String getAddress() {
    return address;
  }

  public String getCity() {
    return city;
  }

  public String getState() {
    return state;
  }

  public String getPostalCode() {
    return postalCode;
  }

  public String getCountry() {
    return country;
  }

  public String toDisplayString() {
    return toDisplayStringWorker().trim();
  }

  private String toDisplayStringWorker() {
    if (city.length() > 0 || state.length() > 0 || postalCode.length() > 0) {
      if (city.length() > 0) {
        if (state.length() > 0 || postalCode.length() > 0) {
          return city + ", " + state + ' ' + postalCode;
        } else {
          return city;
        }
      } else {
        return state + ' ' + postalCode;
      }
    }

    return "";
  }

  public static String country(final Location location) {
    if (location == null) {
      return null;
    }

    return location.getCountry();
  }

  public static final double UNKNOWN_DISTANCE = Float.MAX_VALUE;
  private final static double GREAT_CIRCLE_RADIUS_KILOMETERS = 6371.797;
  private final static double GREAT_CIRCLE_RADIUS_MILES = 3438.461;

  public double distanceTo(final Location to) {

    if (to == null) {
      return UNKNOWN_DISTANCE;
    }

    final double lat1 = (this.latitude / 180) * PI;
    final double lng1 = (this.longitude / 180) * PI;
    final double lat2 = (to.latitude / 180) * PI;
    final double lng2 = (to.longitude / 180) * PI;

    double diff = lng1 - lng2;

    if (diff < 0) {
      diff = -diff;
    }
    if (diff > PI) {
      diff = 2 * PI;
    }

    double distance = acos(sin(lat2) * sin(lat1) + cos(lat2) * cos(lat1) * cos(diff));

    if (NowPlayingApplication.useKilometers()) {
      distance *= GREAT_CIRCLE_RADIUS_KILOMETERS;
    } else {
      distance *= GREAT_CIRCLE_RADIUS_MILES;
    }

//    if (distance > 200) {
//        return UNKNOWN_DISTANCE;
//    }

    return distance;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(final Parcel dest, final int flags) {
    dest.writeDouble(latitude);
    dest.writeDouble(longitude);
    dest.writeString(address);
    dest.writeString(city);
    dest.writeString(state);
    dest.writeString(postalCode);
    dest.writeString(country);
  }

  public static final Creator<Location> CREATOR = new Creator<Location>() {
    public Location createFromParcel(final Parcel source) {
      final double latitude = source.readDouble();
      final double longitude = source.readDouble();
      final String address = source.readString();
      final String city = source.readString();
      final String state = source.readString();
      final String postalCode = source.readString();
      final String country = source.readString();
      return new Location(latitude, longitude, address, city, state, postalCode, country);
    }

    public Location[] newArray(final int size) {
      return new Location[size];
    }
  };
}
