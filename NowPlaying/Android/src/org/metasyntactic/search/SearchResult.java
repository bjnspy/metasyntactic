// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package org.metasyntactic.search;

import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;

import java.util.List;
import java.util.Collections;

public class SearchResult {
  private final int requestId;
  private final String value;
  private final List<Movie> movies;
  private final List<Theater> theaters;
  private final List<Movie> upcomingMovies;

  public SearchResult(final int requestId, final String value, final List<Movie> movies, final List<Theater> theaters, final List<Movie> upcomingMovies) {
    this.requestId = requestId;
    this.value = value;
    this.movies = movies;
    this.theaters = theaters;
    this.upcomingMovies = upcomingMovies;
  }

  public int getRequestId() {
    return requestId;
  }

  public String getValue() {
    return value;
  }

  public List<Movie> getMovies() {
    return Collections.unmodifiableList(movies);
  }

  public List<Theater> getTheaters() {
    return Collections.unmodifiableList(theaters);
  }

  public List<Movie> getUpcomingMovies() {
    return Collections.unmodifiableList(upcomingMovies);
  }
}