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
import org.metasyntactic.io.Persistable;
import org.metasyntactic.io.PersistableInputStream;
import org.metasyntactic.io.PersistableOutputStream;

import java.io.IOException;

public class Review implements Parcelable, Persistable {
  private static final long serialVersionUID = -1500254001711613076L;
  private final String text;
  private final int score;
  private final String link;
  private final String author;
  private final String source;

  public void persistTo(final PersistableOutputStream out) throws IOException {
    out.writeString(text);
    out.writeInt(score);
    out.writeString(link);
    out.writeString(author);
    out.writeString(source);
  }

  public static final Reader<Review> reader = new AbstractPersistable.AbstractReader<Review>() {
    public Review read(final PersistableInputStream in) throws IOException {
      final String text = in.readString();
      final int score = in.readInt();
      final String link = in.readString();
      final String author = in.readString();
      final String source = in.readString();

      return new Review(text, score, link, author, source);
    }
  };

  public Review(final String text, final int score, final String link, final String author, final String source) {
    this.text = text;
    this.score = score;
    this.link = link;
    this.author = author;
    this.source = source;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(final Parcel parcel, final int i) {
    parcel.writeString(text);
    parcel.writeInt(score);
    parcel.writeString(link);
    parcel.writeString(author);
    parcel.writeString(source);
  }

  public static final Creator<Review> CREATOR = new Creator<Review>() {
    public Review createFromParcel(final Parcel parcel) {
      final String text = parcel.readString();
      final int score = parcel.readInt();
      final String link = parcel.readString();
      final String author = parcel.readString();
      final String source = parcel.readString();

      return new Review(text, score, link, author, source);
    }

    public Review[] newArray(final int size) {
      return new Review[size];
    }
  };

  public String getText() {
    return text;
  }

  public int getScore() {
    return score;
  }

  public String getLink() {
    return link;
  }

  public String getAuthor() {
    return author;
  }

  public String getSource() {
    return source;
  }
}
