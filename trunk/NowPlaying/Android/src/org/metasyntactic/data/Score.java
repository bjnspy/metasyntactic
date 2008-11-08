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

public class Score implements Parcelable, Persistable {
  private String canonicalTitle;
  private String synopsis;
  private String value;
  private String provider;
  private String identifier;

  public void persistTo(PersistableOutputStream out) throws IOException {
    out.writeString(canonicalTitle);
    out.writeString(synopsis);
    out.writeString(value);
    out.writeString(provider);
    out.writeString(identifier);
  }

  public static final Reader<Score> reader = new AbstractPersistable.AbstractReader<Score>() {
    public Score read(PersistableInputStream in) throws IOException {
      String canonicalTitle = in.readString();
      String synopsis = in.readString();
      String value = in.readString();
      String provider = in.readString();
      String identifier = in.readString();

      return new Score(canonicalTitle, synopsis, value, provider, identifier);
    }
  };

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

  public static final Parcelable.Creator<Score> CREATOR = new Parcelable.Creator<Score>() {
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

  public int compareTo(Score score) {
    // TODO Auto-generated method stub
    return this.value.compareTo(score.value);
  }
}
