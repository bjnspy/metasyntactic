package org.metasyntactic.providers;

import org.metasyntactic.data.FavoriteTheater;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Theater;

import java.util.Date;
import java.util.List;
import java.util.Map;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class LookupResult {
  public List<Movie> movies;
  public List<Theater> theaters;

  // theater name -> movie name -> [ { showtime, showid } ]
  public Map<String, Map<String, List<Performance>>> performances;

  // theater name -> date
  public Map<String, Date> synchronizationData;


  public LookupResult(List<Movie> movies, List<Theater> theaters,
                      Map<String, Map<String, List<Performance>>> performances,
                      Map<String, Date> synchronizationData) {
    this.movies = movies;
    this.theaters = theaters;
    this.performances = performances;
    this.synchronizationData = synchronizationData;
  }


  public boolean containsFavorite(FavoriteTheater favorite) {
    for (Theater theater : theaters) {
      if (theater.getName().equals(favorite.getName())) {
        return true;
      }
    }
    return false;
  }
}