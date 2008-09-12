package org.metasyntactic.providers;

import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;

import java.util.ArrayList;
import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class DataProvider {
  private final NowPlayingModel model;

  private List<Movie> movies = new ArrayList<Movie>();
  private List<Theater> theaters = new ArrayList<Theater>();

  public DataProvider(NowPlayingModel model) {
    this.model = model;
  }

  public List<Movie> getMovies() {
    return movies;
  }

  public List<Theater> getTheaters() {
    return theaters;
  }

  public void update() {
    model.broadcastChange();
  }
}
