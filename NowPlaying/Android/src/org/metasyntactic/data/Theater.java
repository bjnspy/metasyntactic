package org.metasyntactic.data;

import android.os.Parcel;
import android.os.Parcelable;

import java.io.Serializable;
import java.util.List;
import java.util.ArrayList;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Theater implements Parcelable, Serializable {
	private static final long serialVersionUID = -9055133693026699102L;
	
	private final String identifier;
  private final String name;
  private final String address;
  private final String phoneNumber;

  private final String sellsTickets;
  private final List<String> movieTitles;

  private final String originatingPostalCode;

  public Theater(String identifier, String name, String address, String phoneNumber, String sellsTickets,
                 List<String> movieTitles, String originatingPostalCode) {
    this.identifier = identifier;
    this.name = name;
    this.address = address;
    this.phoneNumber = phoneNumber;
    this.sellsTickets = sellsTickets;
    this.movieTitles = movieTitles;
    this.originatingPostalCode = originatingPostalCode;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(Parcel dest, int flags) {
    dest.writeString(identifier);
    dest.writeString(name);
    dest.writeString(address);
    dest.writeString(phoneNumber);
    dest.writeString(sellsTickets);
    dest.writeStringList(movieTitles);
    dest.writeString(originatingPostalCode);
  }

  public static final Parcelable.Creator<Theater> CREATOR =
      new Parcelable.Creator<Theater>() {
        public Theater createFromParcel(Parcel source) {
          String identifier = source.readString();
          String name = source.readString();
          String address = source.readString();
          String phoneNumber = source.readString();

          String sellsTickets = source.readString();
          List<String> movieTitles = new ArrayList<String>();
          source.readStringList(movieTitles);

          String originatingPostalCode = source.readString();

          return new Theater(identifier, name, address, phoneNumber, sellsTickets, movieTitles, originatingPostalCode);
        }

        public Theater[] newArray(int size) {
          return new Theater[size];
        }
      };
}
