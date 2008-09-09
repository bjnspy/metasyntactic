package org.metasyntactic;

import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;

import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class NowPlayingModel {

  public void update() {
    new Thread(new Runnable() {
      public void run() {
        updateBackgroundEntryPoint();
      }
    });
  }

  private void updateBackgroundEntryPoint() {

  }

  public int getSelectedTabIndex() {
    return 0;
  }

  public void setSelectedTabIndex(int index) {
  }

  public int getAllMoviesSelecetedSortIndex() {
    return 0;
  }

  public void setAllMoviesSelectedSortIndex(int index) {
  }

  public int getAllTheatersSelectedSortIndex() {
    return 0;
  }

  public void setAllTheatersSelectedSortIndex() {
  }

  public int getUpcomingMovieSelectedSortIndex() {
    return 0;
  }

  public void setUpcomingMovieSelectedSortIndex(int index) {
  }

  public List<Movie> getMovies() {
    return null;
  }

  public List<Theater> getTheaters() {
    return null;
  }
}
