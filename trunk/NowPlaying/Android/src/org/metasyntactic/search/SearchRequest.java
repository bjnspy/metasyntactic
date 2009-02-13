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

import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;
import static org.metasyntactic.utilities.StringUtilities.toASCII;

import java.util.Collections;
import java.util.List;

public class SearchRequest {
  private final int requestId;
  private final String value;
  private final String lowercaseValue;
  private final List<Movie> movies;
  private final List<Theater> theaters;
  private final List<Movie> upcomingMovies;

  public SearchRequest(final int requestId, final String value, final NowPlayingModel model) {
    this.requestId = requestId;
    this.value = value;
    this.lowercaseValue = toASCII(value).toLowerCase();

    this.movies = model.getMovies();
    this.theaters = model.getTheaters();
    this.upcomingMovies = model.getUpcomingMovies();
  }

  public int getRequestId() {
    return requestId;
  }

  public String getValue() {
    return value;
  }

  public String getLowercaseValue() {
    return lowercaseValue;
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