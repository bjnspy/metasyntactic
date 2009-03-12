package org.metasyntactic.services;

import org.metasyntactic.data.DVD;
import org.metasyntactic.data.FavoriteTheater;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Review;
import org.metasyntactic.data.Score;
import org.metasyntactic.data.Theater;
import org.metasyntactic.data.Time;

interface INowPlayingService {
  String getUserAddress();
  void setUserAddress(String address);
  org.metasyntactic.data.Location getLocationForAddress(String address);
  
  int getSearchDistance();
  void setSearchDistance(int distance);

  int getSelectedTabIndex();
  void setSelectedTabIndex(int index);

  int getAllMoviesSelectedSortIndex();
  void setAllMoviesSelectedSortIndex(int index);

  int getAllTheatersSelectedSortIndex();
  void setAllTheatersSelectedSortIndex(int index);

  int getUpcomingMoviesSelectedSortIndex();
  void setUpcomingMoviesSelectedSortIndex(int index);

  List<Movie> getMovies();
  List<Theater> getTheaters();

  String getTrailer(in Movie movie);
  List<Review> getReviews(in Movie movie);

  String getAmazonAddress(in Movie movie);
  String getIMDbAddress(in Movie movie);
  String getWikipediaAddress(in Movie movie);

  List<Theater> getTheatersShowingMovie(in Movie movie);
  List<Movie> getMoviesAtTheater(in Theater theater);
  List<Performance> getPerformancesForMovieAtTheater(in Movie movie, in Theater theater);

  String getScoreType();
  void setScoreType(String scoreType);

  Score getScore(in Movie movie);

  byte[] getPoster(in Movie movie);

  String getPosterFile_safeToCallFromBackground(in Movie movie);

  String getSynopsis(in Movie movie);

  void prioritizeMovie(in Movie movie);

  boolean isAutoUpdateEnabled();
  void setAutoUpdateEnabled(boolean enabled);

  long getSearchDate();
  void setSearchDate(long date);

  List<Movie> getUpcomingMovies();

  String getDataProviderState();

  boolean isStale(in Theater theater);

  String getShowtimesRetrievedOnString(in Theater theater);

  void addFavoriteTheater(in Theater theater);
  void removeFavoriteTheater(in Theater theater);
  boolean isFavoriteTheater(in Theater theater);
}