package org.metasyntactic.data;

import android.os.Parcel;
import android.os.Parcelable;

import java.io.Serializable;

public class Performance implements Parcelable, Serializable {
  private static final long serialVersionUID = -3405664393301264858L;

  private final String identifier;
  private final String time;

  public Performance(String identifier, String time) {
    this.identifier = identifier;
    this.time = time;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(Parcel dest, int flags) {
    dest.writeString(identifier);
    dest.writeString(time);
  }

  public static final Parcelable.Creator<Performance> CREATOR =
      new Parcelable.Creator<Performance>() {
        public Performance createFromParcel(Parcel source) {
          String identifier = source.readString();
          String time = source.readString();
          return new Performance(identifier, time);
        }

        public Performance[] newArray(int size) {
          return new Performance[size];
        }
      };
}
