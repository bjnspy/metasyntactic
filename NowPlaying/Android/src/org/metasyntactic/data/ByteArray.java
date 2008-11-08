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

public class ByteArray implements Parcelable {
  private final byte[] bytes;

  public ByteArray(byte[] bytes) {
    this.bytes = bytes;
  }

  public byte[] getBytes() {
    return bytes;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(Parcel dest, int flags) {
    dest.writeInt(bytes.length);
    dest.writeByteArray(bytes);
  }

  public static final Parcelable.Creator<ByteArray> CREATOR = new Parcelable.Creator<ByteArray>() {
    public ByteArray createFromParcel(Parcel source) {
      int length = source.readInt();
      byte[] bytes = new byte[length];
      source.readByteArray(bytes);

      return new ByteArray(bytes);
    }

    public ByteArray[] newArray(int size) {
      return new ByteArray[size];
    }
  };
}