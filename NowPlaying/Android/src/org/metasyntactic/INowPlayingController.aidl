package org.metasyntactic;

import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;

interface INowPlayingController {
  void setUserLocation(String userLocation);

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
}