package org.metasyntactic.data;

import android.os.Parcel;
import android.os.Parcelable;

import java.io.Serializable;

public class Location implements Parcelable, Serializable {
  private static final long serialVersionUID = 8006943518629662020L;

  private final double latitude;
  private final double longitude;
  private final String address;
  private final String city;
  private final String state;
  private final String postalCode;
  private final String country;

  public Location(double latitude, double longitude, String address,
                  String city, String state, String postalCode, String country) {
    this.latitude = latitude;
    this.longitude = longitude;
    this.address = address;
    this.city = city;
    this.state = state;
    this.postalCode = postalCode;
    this.country = country;
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


  public int describeContents() {
    return 0;
  }

  public void writeToParcel(Parcel dest, int flags) {
    dest.writeDouble(latitude);
    dest.writeDouble(longitude);
    dest.writeString(address);
    dest.writeString(city);
    dest.writeString(state);
    dest.writeString(postalCode);
    dest.writeString(country);
  }

  public static final Parcelable.Creator<Location> CREATOR =
      new Parcelable.Creator<Location>() {
        public Location createFromParcel(Parcel source) {
          double latitude = source.readDouble();
          double longitude = source.readDouble();
          String address = source.readString();
          String city = source.readString();
          String state = source.readString();
          String postalCode = source.readString();
          String country = source.readString();
          return new Location(latitude, longitude, address, city, state, postalCode, country);
        }

        public Location[] newArray(int size) {
          return new Location[size];
        }
      };
}
