package org.metasyntactic.data;

import android.os.Parcel;
import android.os.Parcelable;
import org.metasyntactic.io.AbstractPersistable;
import org.metasyntactic.io.PersistableInputStream;
import org.metasyntactic.io.PersistableOutputStream;

import java.io.IOException;

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
    return hour;
  }

  public int getMinute() {
    return minute;
  }

  public boolean isAM() {
    return am;
  }

  public int compareTo(final Time time) {
    if (am != time.am) {
      return am ? -1 : 1;
    }

    if (hour != time.hour) {
      return hour - time.hour;
    }

    return minute - time.minute;
  }

  public void persistTo(final PersistableOutputStream out) throws IOException {
    out.writeInt(hour);
    out.writeInt(minute);
    out.writeInt(am ? 1 : 0);
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
    parcel.writeInt(hour);
    parcel.writeInt(minute);
    parcel.writeInt(am ? 1 : 0);
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