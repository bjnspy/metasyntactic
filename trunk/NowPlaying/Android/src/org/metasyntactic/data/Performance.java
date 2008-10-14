package org.metasyntactic.data;

import android.os.Parcel;
import android.os.Parcelable;

import java.io.Serializable;

public class Performance implements Parcelable, Serializable {
  private static final long serialVersionUID = -3405664393301264858L;

  private final String time;
  private final String url;


  public Performance(String time, String url) {
    this.time = time;
    this.url = url;
  }


  public String getTime() {
    return time;
  }


  public String getUrl() {
    return url;
  }


  public int describeContents() {
    return 0;
  }


  public void writeToParcel(Parcel dest, int flags) {
    dest.writeString(time);
    dest.writeString(url);
  }


  public static final Parcelable.Creator<Performance> CREATOR =
      new Parcelable.Creator<Performance>() {
        public Performance createFromParcel(Parcel source) {
          String time = source.readString();
          String url = source.readString();
          return new Performance(time, url);
        }


        public Performance[] newArray(int size) {
          return new Performance[size];
        }
      };
}
