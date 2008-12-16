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
package org.metasyntactic.providers;

import org.metasyntactic.data.FavoriteTheater;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Theater;

import java.util.Date;
import java.util.List;
import java.util.Map;

public class LookupResult {
  public List<Movie> movies;
  public List<Theater> theaters;
  // theater name -> movie name -> [ { showtime, showid } ]
  public Map<String, Map<String, List<Performance>>> performances;
  // theater name -> date
  public Map<String, Date> synchronizationData;

  public LookupResult(final List<Movie> movies, final List<Theater> theaters, final Map<String, Map<String, List<Performance>>> performances, final Map<String, Date> synchronizationData) {
    this.movies = movies;
    this.theaters = theaters;
    this.performances = performances;
    this.synchronizationData = synchronizationData;
  }

  public boolean containsFavorite(final FavoriteTheater favorite) {
    for (final Theater theater : this.theaters) {
      if (theater.getName().equals(favorite.getName())) {
        return true;
      }
    }
    return false;
  }
}