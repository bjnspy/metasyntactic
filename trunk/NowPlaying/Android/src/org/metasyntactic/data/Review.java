package org.metasyntactic.data;

import android.os.Parcel;
import android.os.Parcelable;

import java.io.Serializable;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Review implements Parcelable, Serializable {
  /**
	 * 
	 */
	private static final long serialVersionUID = -7068833926510670525L;
	private final String text;
  private final int score;
  private final String link;
  private final String author;
  private final String source;


  public Review(String text, int score, String link, String author, String source) {
    this.text = text;
    this.score = score;
    this.link = link;
    this.author = author;
    this.source = source;
  }


  public int describeContents() {
    return 0;
  }


  public void writeToParcel(Parcel parcel, int i) {
    parcel.writeString(text);
    parcel.writeInt(score);
    parcel.writeString(link);
    parcel.writeString(author);
    parcel.writeString(source);
  }


  public static final Parcelable.Creator<Review> CREATOR =
      new Parcelable.Creator<Review>() {
        public Review createFromParcel(Parcel parcel) {
          String text = parcel.readString();
          int score = parcel.readInt();
          String link = parcel.readString();
          String author = parcel.readString();
          String source = parcel.readString();

          return new Review(text, score, link, author, source);
        }


        public Review[] newArray(int size) {
          return new Review[size];
        }
      };
}
