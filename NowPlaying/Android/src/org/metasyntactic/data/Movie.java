package org.metasyntactic.data;

import android.os.Parcel;
import android.os.Parcelable;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class Movie implements Parcelable, Serializable {
	private static final long serialVersionUID = -1715042667960786544L;

	private final String identifier;
  private final String canonicalTitle;
  private final String displayTitle;
  private final String rating;
  private final int length; // minutes;
  private final Date releaseDate;
  private final String poster;
  private final String synopsis;
  private final String studio;
  private final List<String> directors;
  private final List<String> cast;
  private final List<String> genres;

  private Movie(String identifier, String canonicalTitle, String displayTitle, String rating, int length,
                Date releaseDate, String poster, String synopsis, String studio, List<String> directors,
                List<String> cast, List<String> genres) {
    this.identifier = identifier;
    this.canonicalTitle = canonicalTitle;
    this.rating = rating;
    this.length = length;
    this.releaseDate = releaseDate;
    this.poster = poster;
    this.synopsis = synopsis;
    this.studio = studio;
    this.directors = directors;
    this.cast = cast;
    this.genres = genres;
    this.displayTitle = displayTitle;
  }

  public Movie(String identifier, String title, String rating, int length, Date releaseDate, String poster,
               String synopsis, String studio, List<String> directors, List<String> cast, List<String> genres) {
    this(identifier, makeCanonical(title), makeDisplay(title), rating, length, releaseDate, poster, synopsis, studio,
        directors, cast, genres);
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
          Date releaseDate = (Date)source.readValue(null);
          String poster = source.readString();
          String synopsis = source.readString();
          String studio = source.readString();
          List<String> directors = new ArrayList<String>();
          source.readStringList(directors);
          List<String> cast = new ArrayList<String>();
          source.readStringList(cast);
          List<String> genres = new ArrayList<String>();
          source.readStringList(genres);

          return new Movie(identifier, canonicalTitle, displayTitle, rating, length, releaseDate, poster, synopsis,
              studio, directors, cast, genres);
        }

        public Movie[] newArray(int size) {
          return new Movie[size];
        }
      };
}
