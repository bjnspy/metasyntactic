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

import java.io.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Movie implements Parcelable, Serializable {
  private String identifier;
  private String canonicalTitle;
  private String displayTitle;
  private String rating;
  private int length; // minutes;
  private String imdbAddress;
  private Date releaseDate;
  private String poster;
  private String synopsis;
  private String studio;
  private List<String> directors;
  private List<String> cast;
  private List<String> genres;


  private void writeObject(ObjectOutputStream objectOutput) throws IOException {
    objectOutput.writeUTF(identifier);
    objectOutput.writeUTF(canonicalTitle);
    objectOutput.writeUTF(displayTitle);
    objectOutput.writeUTF(rating);
    objectOutput.writeInt(length);
    objectOutput.writeUTF(imdbAddress);
    objectOutput.writeObject(releaseDate);
    objectOutput.writeUTF(poster);
    objectOutput.writeUTF(synopsis);
    objectOutput.writeUTF(studio);
    writeList(objectOutput, directors);
    writeList(objectOutput, cast);
    writeList(objectOutput, genres);
  }


  private void readObject(ObjectInputStream objectInput) throws IOException, ClassNotFoundException {
    identifier = objectInput.readUTF();
    canonicalTitle = objectInput.readUTF();
    displayTitle = objectInput.readUTF();
    rating = objectInput.readUTF();
    length = objectInput.readInt();
    imdbAddress = objectInput.readUTF();
    releaseDate = (Date) objectInput.readObject();
    poster = objectInput.readUTF();
    synopsis = objectInput.readUTF();
    studio = objectInput.readUTF();
    directors = readList(objectInput);
    cast = readList(objectInput);
    genres = readList(objectInput);
  }


  private void writeList(ObjectOutput objectOutput, List<String> directors) throws IOException {
    objectOutput.writeInt(directors.size());
    for (String string : directors) {
      objectOutput.writeUTF(string);
    }
  }


  private List<String> readList(ObjectInput objectInput) throws IOException {
    int size = objectInput.readInt();
    List<String> list = new ArrayList<String>(size);
    for (int i = 0; i < size; i++) {
      list.add(objectInput.readUTF());
    }
    return list;
  }


  private Movie(String identifier, String canonicalTitle, String displayTitle, String rating, int length,
                String imdbAddress, Date releaseDate, String poster, String synopsis, String studio,
                List<String> directors, List<String> cast, List<String> genres) {
    this.identifier = identifier;
    this.canonicalTitle = canonicalTitle;
    this.rating = rating;
    this.length = length;
    this.imdbAddress = imdbAddress;
    this.releaseDate = releaseDate;
    this.poster = poster;
    this.synopsis = synopsis;
    this.studio = studio;
    this.directors = directors;
    this.cast = cast;
    this.genres = genres;
    this.displayTitle = displayTitle;
  }


  public Movie(String identifier, String title, String rating, int length, String imdbAddress, Date releaseDate,
               String poster, String synopsis, String studio, List<String> directors, List<String> cast,
               List<String> genres) {
    this(identifier, makeCanonical(title), makeDisplay(title), rating, length, imdbAddress, releaseDate, poster,
        synopsis, studio, directors, cast, genres);
  }


  public String getIdentifier() {
    return identifier;
  }


  public String getCanonicalTitle() {
    return canonicalTitle;
  }


  public String getDisplayTitle() {
    return displayTitle;
  }


  public String getRating() {
    return rating;
  }


  public int getLength() {
    return length;
  }


  public Date getReleaseDate() {
    return releaseDate;
  }


  public String getPoster() {
    return poster;
  }


  public String getSynopsis() {
    return synopsis;
  }


  public String getStudio() {
    return studio;
  }


  public List<String> getDirectors() {
    return Collections.unmodifiableList(directors);
  }


  public List<String> getCast() {
    return Collections.unmodifiableList(cast);
  }


  public List<String> getGenres() {
    return Collections.unmodifiableList(genres);
  }


  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof Movie)) {
      return false;
    }

    Movie movie = (Movie) o;

    if (canonicalTitle != null ? !canonicalTitle.equals(movie.canonicalTitle) : movie.canonicalTitle != null) {
      return false;
    }

    return true;
  }


  public int hashCode() {
    return (canonicalTitle != null ? canonicalTitle.hashCode() : 0);
  }


  private final static String[] articles = new String[]{
      "Der", "Das", "Ein", "Eine", "The",
      "A", "An", "La", "Las", "Le",
      "Les", "Los", "El", "Un", "Une",
      "Una", "Il", "O", "Het", "De",
      "Os", "Az", "Den", "Al", "En",
      "L'"
  };


  public static String makeCanonical(String title) {
    for (String article : articles) {
      if (title.endsWith(", " + article)) {
        return article + title.substring(0, title.length() - article.length() - 2);
      }
    }

    return title;
  }


  public static String makeDisplay(String title) {
    for (String article : articles) {
      if (title.startsWith(article + " ")) {
        return title.substring(article.length() + 1) + ", " + article;
      }
    }

    return title;
  }


  public int describeContents() {
    return 0;
  }


  public void writeToParcel(Parcel dest, int flags) {
    dest.writeString(identifier);
    dest.writeString(canonicalTitle);
    dest.writeString(displayTitle);
    dest.writeString(rating);
    dest.writeInt(length);
    dest.writeString(imdbAddress);
    dest.writeValue(releaseDate);
    dest.writeString(poster);
    dest.writeString(synopsis);
    dest.writeString(studio);
    dest.writeStringList(directors);
    dest.writeStringList(cast);
    dest.writeStringList(genres);
  }


  public static final Parcelable.Creator<Movie> CREATOR =
      new Parcelable.Creator<Movie>() {
        public Movie createFromParcel(Parcel source) {
          String identifier = source.readString();
          String canonicalTitle = source.readString();
          String displayTitle = source.readString();
          String rating = source.readString();
          int length = source.readInt();
          String imdbAddress = source.readString();
          Date releaseDate = (Date) source.readValue(null);
          String poster = source.readString();
          String synopsis = source.readString();
          String studio = source.readString();
          List<String> directors = new ArrayList<String>();
          source.readStringList(directors);
          List<String> cast = new ArrayList<String>();
          source.readStringList(cast);
          List<String> genres = new ArrayList<String>();
          source.readStringList(genres);

          return new Movie(identifier, canonicalTitle, displayTitle, rating, length, imdbAddress, releaseDate, poster,
              synopsis,
              studio, directors, cast, genres);
        }


        public Movie[] newArray(int size) {
          return new Movie[size];
        }
      };
}
