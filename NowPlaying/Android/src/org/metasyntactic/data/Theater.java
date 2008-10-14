package org.metasyntactic.data;

import android.os.Parcel;
import android.os.Parcelable;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Theater implements Parcelable, Serializable {
  private static final long serialVersionUID = -9055133693026699102L;

  private final String identifier;
  private final String name;
  private final String address;
  private final String phoneNumber;

  private final Location location;
  private final Location originatingLocation;
  private final List<String> movieTitles;


  public Theater(String identifier, String name, String address, String phoneNumber, Location location,
                 Location originatingLocation, List<String> movieTitles) {
    this.identifier = identifier;
    this.name = name;
    this.address = address;
    this.phoneNumber = phoneNumber;
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


  public List<String> getMovieTitles() {
    return Collections.unmodifiableList(movieTitles);
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
    dest.writeStringList(movieTitles);
  }


  public static final Parcelable.Creator<Theater> CREATOR =
      new Parcelable.Creator<Theater>() {
        public Theater createFromParcel(Parcel source) {
          String identifier = source.readString();
          String name = source.readString();
          String address = source.readString();
          String phoneNumber = source.readString();

          Location location = source.readParcelable(null);
          Location originatingLocation = source.readParcelable(null);
          List<String> movieTitles = new ArrayList<String>();
          source.readStringList(movieTitles);

          return new Theater(identifier, name, address, phoneNumber, location, originatingLocation, movieTitles);
        }


        public Theater[] newArray(int size) {
          return new Theater[size];
        }
      };
}
