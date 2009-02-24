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
import org.metasyntactic.io.PersistableInputStream;
import org.metasyntactic.io.PersistableOutputStream;

import java.io.IOException;

public class Score extends AbstractPersistable implements Parcelable, Comparable<Score> {
  private static final long serialVersionUID = -22337839093764822L;
  private final String canonicalTitle;
  private final String synopsis;
  private final String value;
  private final String provider;
  private final String identifier;

  public void persistTo(final PersistableOutputStream out) throws IOException {
    out.writeString(canonicalTitle);
    out.writeString(synopsis);
    out.writeString(value);
    out.writeString(provider);
    out.writeString(identifier);
  }

  public static final Reader<Score> reader = new AbstractReader<Score>() {
    public Score read(final PersistableInputStream in) throws IOException {
      final String canonicalTitle = in.readString();
      final String synopsis = in.readString();
      final String value = in.readString();
      final String provider = in.readString();
      final String identifier = in.readString();

      return new Score(canonicalTitle, synopsis, value, provider, identifier);
    }
  };

  private Score(final String canonicalTitle, final String synopsis, final String value, final String provider,
    final String identifier, @SuppressWarnings("unused") final boolean ignored) {
    this.canonicalTitle = canonicalTitle;
    this.synopsis = synopsis;
    this.value = value;
    this.provider = provider;
    this.identifier = identifier;
  }

  public Score(final String title, final String synopsis, final String value, final String provider,
    final String identifier) {
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

  public int getScoreValue() {
    try {
      return Integer.parseInt(getValue());
    } catch (NumberFormatException ignored) {
      return -1;
    }
  }

  public String getIdentifier() {
    return identifier;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(final Parcel parcel, final int i) {
    parcel.writeString(canonicalTitle);
    parcel.writeString(synopsis);
    parcel.writeString(value);
    parcel.writeString(provider);
    parcel.writeString(identifier);
  }

  public static final Creator<Score> CREATOR = new Creator<Score>() {
    public Score createFromParcel(final Parcel source) {
      final String canonicalTitle = source.readString();
      final String synopsis = source.readString();
      final String score = source.readString();
      final String provider = source.readString();
      final String identifier = source.readString();

      return new Score(canonicalTitle, synopsis, score, provider, identifier);
    }

    public Score[] newArray(final int size) {
      return new Score[size];
    }
  };

  public int compareTo(final Score score) {
    return getCanonicalTitle().compareTo(score.getCanonicalTitle());
  }

  @Override
  public boolean equals(final Object object) {
    if (object == null) {
      return false;
    }

    if (!(object instanceof Score)) {
      return false;
    }

    return compareTo((Score) object) == 0;
  }

  @Override
  public int hashCode() {
    return getCanonicalTitle().hashCode();
  }
}
