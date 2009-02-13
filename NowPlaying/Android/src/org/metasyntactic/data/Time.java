package org.metasyntactic.data;

import java.io.IOException;

import org.metasyntactic.io.AbstractPersistable;
import org.metasyntactic.io.PersistableOutputStream;
import org.metasyntactic.io.PersistableInputStream;

import android.os.Parcel;
import android.os.Parcelable;

public class Time extends AbstractPersistable implements Parcelable, Comparable<Time> {
  private static final long serialVersionUID = -1817535617950348044L;
  private final int hour;
  private final int minute;
  private final boolean am;

  public Time(final int hour, final int minute, final boolean am) {
    this.hour = hour;
    this.minute = minute;
    this.am = am;
  }

  public int getHour() {
    return this.hour;
  }

  public int getMinute() {
    return this.minute;
  }

  public boolean getAM() {
    return this.am;
  }

  public int compareTo(final Time time) {
    if (this.am != time.am) {
      return this.am ? -1 : 1;
    }

    if (this.hour != time.hour) {
      return this.hour - time.hour;
    }

    return this.minute - time.minute;
  }

  public void persistTo(final PersistableOutputStream out) throws IOException {
    out.writeInt(this.hour);
    out.writeInt(this.minute);
    out.writeInt(this.am ? 1 : 0);
  }

  public static final Reader<Time> reader = new AbstractReader<Time>() {
    public Time read(final PersistableInputStream in) throws IOException {
      final int hour = in.readInt();
      final int minute = in.readInt();
      final boolean am = in.readInt() != 0;

      return new Time(hour, minute, am);
    }
  };

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(final Parcel parcel, final int i) {
    parcel.writeInt(this.hour);
    parcel.writeInt(this.minute);
    parcel.writeInt(this.am ? 1 : 0);
  }

  public static final Creator<Time> CREATOR = new Creator<Time>() {
    public Time createFromParcel(final Parcel parcel) {
      final int hour = parcel.readInt();
      final int minute = parcel.readInt();
      final boolean am = parcel.readInt() != 0;

      return new Time(hour, minute, am);
    }

    public Time[] newArray(final int size) {
      return new Time[size];
    }
  };

  private String timeString;

  @Override
  public String toString() {
    if (timeString == null) {
      timeString = String.valueOf(hour) + ':' + minute + (am ? "am" : "pm");
    }

    return timeString;
  }

  @Override
  public boolean equals(final Object object) {
    if (object == null) {
      return false;
    }

    return object instanceof Time && compareTo((Time)object) == 0;
  }

  @Override
  public int hashCode() {
    return hour << 16 | minute | (am ? 1 : 0);
  }
}