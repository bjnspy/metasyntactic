package org.metasyntactic.data;

import android.os.Parcel;
import android.os.Parcelable;

import java.io.Serializable;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Score implements Parcelable, Serializable {
  private final String canonicalTitle;
  private final String synopsis;
  private final String value;
  private final String provider;
  private final String identifier;


  private Score(String canonicalTitle, String synopsis, String value, String provider, String identifier,
                boolean dummy) {
    this.canonicalTitle = canonicalTitle;
    this.synopsis = synopsis;
    this.value = value;
    this.provider = provider;
    this.identifier = identifier;
  }


  public Score(String title, String synopsis, String value, String provider, String identifier) {
    this(Movie.makeCanonical(title), synopsis, value, provider, identifier, true);
  }


  public String getCanonicalTitle() {
    return canonicalTitle;
  }


  public String getSynopsis() {
    return synopsis;
  }


  public String getValue() {
    return value;
  }


  public String getProvider() {
    return provider;
  }


  public String getIdentifier() {
    return identifier;
  }


  public int describeContents() {
    return 0;
  }


  public void writeToParcel(Parcel parcel, int i) {
    parcel.writeString(canonicalTitle);
    parcel.writeString(synopsis);
    parcel.writeString(value);
    parcel.writeString(provider);
    parcel.writeString(identifier);
  }

    public static final Parcelable.Creator<Score> CREATOR =
      new Parcelable.Creator<Score>() {
        public Score createFromParcel(Parcel source) {
          String canonicalTitle = source.readString();
          String synopsis = source.readString();
          String score = source.readString();
          String provider = source.readString();
          String identifier = source.readString();

          return new Score(canonicalTitle, synopsis, score, provider, identifier);
        }


        public Score[] newArray(int size) {
          return new Score[size];
        }
      };
}
