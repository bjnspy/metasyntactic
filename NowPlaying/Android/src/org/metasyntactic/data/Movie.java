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
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

public class Movie extends AbstractPersistable implements Parcelable, Comparable<Movie> {
  private static final long serialVersionUID = 4570788252867866289L;
  private final String identifier;
  private final String canonicalTitle;
  private final String displayTitle;
  private final String rating;
  private final int length; // minutes;
  private final String imdbAddress;
  private final Date releaseDate;
  private final String poster;
  private final String synopsis;
  private final String studio;
  private final List<String> directors;
  private final List<String> cast;
  private final List<String> genres;

  public void persistTo(final PersistableOutputStream out) throws IOException {
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

  public static final Reader<Movie> reader = new AbstractReader<Movie>() {
    public Movie read(final PersistableInputStream in) throws IOException {
      final String identifier = in.readString();
      final String canonicalTitle = in.readString();
      final String displayTitle = in.readString();
      final String rating = in.readString();
      final int length = in.readInt();
      final String imdbAddress = in.readString();
      final Date releaseDate = in.readDate();
      final String poster = in.readString();
      final String synopsis = in.readString();
      final String studio = in.readString();
      final List<String> directors = in.readStringList();
      final List<String> cast = in.readStringList();
      final List<String> genres = in.readStringList();

      return new Movie(identifier, canonicalTitle, displayTitle, rating, length, imdbAddress, releaseDate, poster, synopsis, studio, directors, cast,
        genres);
    }
  };

  private Movie(final String identifier, final String canonicalTitle, final String displayTitle, final String rating, final int length,
    final String imdbAddress, final Date releaseDate, final String poster, final String synopsis, final String studio, final List<String> directors,
    final List<String> cast, final List<String> genres) {
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

  public Movie(final String identifier, final String title, final String rating, final int length, final String imdbAddress, final Date releaseDate,
    final String poster, final String synopsis, final String studio, final List<String> directors, final List<String> cast,
    final List<String> genres) {
    this(identifier, makeCanonical(title), makeDisplay(title), rating, length, imdbAddress, releaseDate, poster, synopsis, studio, directors, cast,
      genres);
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

  public String getIMDbAddress() {
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

  @Override
  public boolean equals(final Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof Movie)) {
      return false;
    }

    final Movie movie = (Movie)o;

    if (canonicalTitle != null ? !canonicalTitle.equals(movie.canonicalTitle) : movie.canonicalTitle != null) {
      return false;
    }

    return true;
  }

  @Override
  public int hashCode() {
    return canonicalTitle != null ? canonicalTitle.hashCode() : 0;
  }

  @Override
  public String toString() {
    return canonicalTitle;
  }

  private static final String[] prefixArticles;
  private static final String[] suffixArticles;

  static {
    final String[] articles = {"Der", "Das", "Ein", "Eine", "The", "A", "An", "La", "Las", "Le", "Les", "Los", "El", "Un", "Une", "Una", "Il", "O", "Het", "De", "Os", "Az", "Den", "Al", "En", "L'"};

    prefixArticles = new String[articles.length];
    suffixArticles = new String[articles.length];

    for (int i = 0; i < articles.length; i++) {
      prefixArticles[i] = articles[i] + ' ';
      suffixArticles[i] = ", " + articles[i];
    }
  }

  public static String makeCanonical(final String title) {
    for (int i = 0; i < prefixArticles.length; i++) {
      final String prefixArticle = prefixArticles[i];
      final String suffixArticle = suffixArticles[i];

      if (title.endsWith(suffixArticle)) {
        return prefixArticle + title.substring(0, title.length() - suffixArticle.length());
      }
    }

    return title;
  }

  public static String makeDisplay(final String title) {
    for (int i = 0; i < prefixArticles.length; i++) {
      final String prefixArticle = prefixArticles[i];
      final String suffixArticle = suffixArticles[i];

      if (title.startsWith(prefixArticle)) {
        return title.substring(prefixArticle.length()) + suffixArticle;
      }
    }

    return title;
  }

  public int describeContents() {
    return 0;
  }

  public void writeToParcel(final Parcel dest, final int flags) {
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

  public static final Creator<Movie> CREATOR = new Creator<Movie>() {
    public Movie createFromParcel(final Parcel source) {
      final String identifier = source.readString();
      final String canonicalTitle = source.readString();
      final String displayTitle = source.readString();
      final String rating = source.readString();
      final int length = source.readInt();
      final String imdbAddress = source.readString();
      final Date releaseDate = (Date)source.readValue(null);
      final String poster = source.readString();
      final String synopsis = source.readString();
      final String studio = source.readString();
      final List<String> directors = new ArrayList<String>();
      source.readStringList(directors);
      final List<String> cast = new ArrayList<String>();
      source.readStringList(cast);
      final List<String> genres = new ArrayList<String>();
      source.readStringList(genres);

      return new Movie(identifier, canonicalTitle, displayTitle, rating, length, imdbAddress, releaseDate, poster, synopsis, studio, directors, cast,
        genres);
    }

    public Movie[] newArray(final int size) {
      return new Movie[size];
    }
  };

  public int compareTo(final Movie movie) {
    return getCanonicalTitle().compareTo(movie.getCanonicalTitle());
  }

  public static final Comparator<Movie> TITLE_ORDER = new Comparator<Movie>() {
    public int compare(final Movie m1, final Movie m2) {
      return m1.getDisplayTitle().compareTo(m2.getDisplayTitle());
    }
  };
  public static final Comparator<Movie> RELEASE_ORDER = new Comparator<Movie>() {
    public int compare(final Movie m1, final Movie m2) {
      final Calendar c1 = Calendar.getInstance();
      c1.set(1900, 11, 11);
      Date d1 = c1.getTime();
      Date d2 = c1.getTime();
      if (m1.getReleaseDate() != null) {
        d1 = m1.getReleaseDate();
      }
      if (m2.getReleaseDate() != null) {
        d2 = m2.getReleaseDate();
      }
      return d2.compareTo(d1);
    }
  };
}
