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
