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
package org.metasyntactic.caches.scores;

import android.os.Parcel;
import android.os.Parcelable;

import java.lang.reflect.Field;
import java.lang.reflect.Member;

public abstract class ScoreType implements Parcelable {
  private ScoreType() {

  }

  private Member findField() {
    for (final Field field : ScoreType.class.getFields()) {
      try {
        if (equals(field.get(null))) {
          return field;
        }
      } catch (IllegalAccessException e) {
        throw new RuntimeException(e);
      }
    }

    throw new RuntimeException();
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(final Parcel parcel, final int i) {
    parcel.writeInt(getIndex());
  }

  @Override
  public String toString() {
    return findField().getName();
  }

  public static ScoreType valueOf(final Object name) {
    for (final Field field : ScoreType.class.getFields()) {
      if (field.getName().equals(name)) {
        try {
          return (ScoreType) field.get(null);
        } catch (IllegalAccessException e) {
          throw new RuntimeException(e);
        }
      }
    }

    throw new RuntimeException();
  }

  public static final Creator<ScoreType> CREATOR = new Creator<ScoreType>() {
    public ScoreType createFromParcel(final Parcel source) {
      final int index = source.readInt();

      for (final Field field : ScoreType.class.getFields()) {
        try {
          final ScoreType scoreType = (ScoreType) field.get(null);
          if (scoreType.getIndex() == index) {
            return scoreType;
          }
        } catch (IllegalAccessException e) {
          throw new RuntimeException(e);
        }
      }

      throw new RuntimeException();
    }

    public ScoreType[] newArray(final int size) {
      return new ScoreType[size];
    }
  };

  private int getIndex() {
    final Field[] fields = ScoreType.class.getFields();
    for (int i = 0; i < fields.length; i++) {
      try {
        if (equals(fields[i].get(null))) {
          return i;
        }
      } catch (IllegalAccessException e) {
        throw new RuntimeException(e);
      }
    }

    throw new RuntimeException();
  }

  public static final ScoreType RottenTomatoes = new ScoreType() {
  };
  public static final ScoreType Metacritic = new ScoreType() {
  };
  public static final ScoreType Google = new ScoreType() {
  };
  public static final ScoreType None = new ScoreType() {
  };
}