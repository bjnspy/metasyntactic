package org.metasyntactic.data;

import android.os.Parcel;
import android.os.Parcelable;
import org.metasyntactic.utilities.StringUtilities;

import java.io.Serializable;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class FavoriteTheater implements Parcelable, Serializable {
  private final String name;
  private final Location originatingLocation;


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


  public static final Parcelable.Creator<FavoriteTheater> CREATOR =
      new Parcelable.Creator<FavoriteTheater>() {
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