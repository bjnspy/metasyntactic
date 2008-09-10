package org.metasyntactic.providers;

import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;

import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class DataProvider {
  private final NowPlayingModel model;
  private List<Movie> movies;
  private List<Theater> theaters;

  public DataProvider(NowPlayingModel model) {
    this.model = model;
  }

  public List<Movie> getMovies() {
    return null;
  }

  public List<Theater> getTheaters() {
    return null;
  }

  public void update() {

  }
}
