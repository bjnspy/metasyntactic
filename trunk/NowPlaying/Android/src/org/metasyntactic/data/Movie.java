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
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

public class Movie implements Parcelable, Persistable {
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


  public void persistTo(PersistableOutputStream out) throws IOException {
    out.writeString(identifier);
    out.writeString(canonicalTitle);
    out.writeString(displayTitle);
    out.writeString(rating);
    out.writeInt(length);
    out.writeString(imdbAddress);
    out.writeDate(releaseDate);
    out.writeString(poster);
    out.writeString(synopsis);
    out.writeString(studio);
    out.writeStringCollection(directors);
    out.writeStringCollection(cast);
    out.writeStringCollection(genres);
  }


  public static final Reader<Movie> reader = new AbstractPersistable.AbstractReader<Movie>() {
    public Movie read(PersistableInputStream in) throws IOException {
      String identifier = in.readString();
      String canonicalTitle = in.readString();
      String displayTitle = in.readString();
      String rating = in.readString();
      int length = in.readInt();
      String imdbAddress = in.readString();
      Date releaseDate = in.readDate();
      String poster = in.readString();
      String synopsis = in.readString();
      String studio = in.readString();
      List<String> directors = in.readStringList();
      List<String> cast = in.readStringList();
      List<String> genres = in.readStringList();

      return new Movie(identifier, canonicalTitle, displayTitle, rating, length, imdbAddress, releaseDate, poster,
          synopsis, studio, directors, cast, genres);
    }
  };


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


  public String getImdbAddress() {
    return imdbAddress;
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


  private static String[] prefixArticles;
  private static String[] suffixArticles;


  static {
    String[] articles = new String[]{
        "Der", "Das", "Ein", "Eine", "The",
        "A", "An", "La", "Las", "Le",
        "Les", "Los", "El", "Un", "Une",
        "Una", "Il", "O", "Het", "De",
        "Os", "Az", "Den", "Al", "En",
        "L'"
    };

    prefixArticles = new String[articles.length];
    suffixArticles = new String[articles.length];

    for (int i = 0; i < articles.length; i++) {
      prefixArticles[i] = articles[i] + " ";
      suffixArticles[i] = ", " + articles[i];
    }
  }


  public static String makeCanonical(String title) {
    for (int i = 0; i < prefixArticles.length; i++) {
      String prefixArticle = prefixArticles[i];
      String suffixArticle = suffixArticles[i];

      if (title.endsWith(suffixArticle)) {
        return prefixArticle + title.substring(0, title.length() - suffixArticle.length());
      }
    }

    return title;
  }


  public static String makeDisplay(String title) {
    for (int i = 0; i < prefixArticles.length; i++) {
      String prefixArticle = prefixArticles[i];
      String suffixArticle = suffixArticles[i];

      if (title.startsWith(prefixArticle)) {
        return title.substring(prefixArticle.length()) + suffixArticle;
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
