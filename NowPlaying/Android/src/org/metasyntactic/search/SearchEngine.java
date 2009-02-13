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
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.StringUtilities;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class SearchEngine {
  // only accessed from the main thread.  needs no lock.
  private final NowPlayingModel model;
  private final SearchEngineDelegate delegate;
  // accessed from both threads.  needs lock
  private int currentRequestId;
  private SearchRequest nextSearchRequest;
  // only accessed from the background thread.  needs no lock
  private SearchRequest currentlyExecutingRequest;
  private final Object gate = new Object();

  public SearchEngine(final NowPlayingModel model, final SearchEngineDelegate delegate) {
    this.model = model;
    this.delegate = delegate;

    final Runnable runnable = new Runnable() {
      public void run() {
        try {
          searchThreadEntryPoint();
        } catch (InterruptedException e) {
          throw new RuntimeException(e);
        }
      }
    };
    ThreadingUtilities.performOnBackgroundThread("Search Thread", runnable, null, true);
  }

  private boolean abortEarly() {
    synchronized (gate) {
      return currentlyExecutingRequest.getRequestId() != currentRequestId;
    }
  }

  private boolean listMatches(final List<String> list) {
    for (final String text : list) {
      if (abortEarly()) {
        return false;
      }

      final String lowercaseText = StringUtilities.toASCII(text).toLowerCase();
      final int index;
      synchronized (gate) {
        index = lowercaseText.indexOf(currentlyExecutingRequest.getLowercaseValue());
      }

      if (index > 0) {
        // make sure it's matching the start of a word
        final char c = lowercaseText.charAt(index - 1);
        if (Character.isLetter(c)) {
          continue;
        }

        return true;
      }
    }

    return false;
  }

  private boolean movieMatches(final Movie movie) {
    final List<String> strings = new ArrayList<String>();
    strings.add(movie.getCanonicalTitle());
    strings.addAll(movie.getDirectors());
    strings.addAll(NowPlayingModel.getCast(movie));
    strings.addAll(movie.getGenres());
    return listMatches(strings);
  }

  private boolean theaterMatches(final Theater theater) {
    final List<String> strings = new ArrayList<String>();
    strings.add(theater.getName());
    strings.add(theater.getAddress());
    return listMatches(strings);
  }

  private List<Movie> findMovies() {
    final List<Movie> result = new ArrayList<Movie>();
    final List<Movie> movies;
    synchronized (gate) {
      movies = currentlyExecutingRequest.getMovies();
    }
    for (final Movie movie : movies) {
      if (movieMatches(movie)) {
        result.add(movie);
      }
    }
    Collections.sort(result, Movie.TITLE_ORDER);
    return result;
  }

  private List<Theater> findTheaters() {
    final List<Theater> result = new ArrayList<Theater>();
    final List<Theater> theaters;
    synchronized (gate) {
      theaters = currentlyExecutingRequest.getTheaters();
    }
    for (final Theater theater : theaters) {
      if (theaterMatches(theater)) {
        result.add(theater);
      }
    }
    Collections.sort(result, Theater.TITLE_ORDER);
    return result;
  }

  private List<Movie> findUpcomingMovies() {
    final List<Movie> result = new ArrayList<Movie>();
    final List<Movie> movies;
    synchronized (gate) {
      movies = currentlyExecutingRequest.getUpcomingMovies();
    }
    for (final Movie movie : movies) {
      if (movieMatches(movie)) {
        result.add(movie);
      }
    }
    Collections.sort(result, Movie.TITLE_ORDER);
    return result;
  }

  private void search() {
    final List<Movie> movies = findMovies();
    if (abortEarly()) {
      return;
    }

    final List<Theater> theaters = findTheaters();
    if (abortEarly()) {
      return;
    }

    final List<Movie> upcomingMovies = findUpcomingMovies();
    if (abortEarly()) {
      return;
    }

    final int id;
    final String value;
    synchronized (gate) {
      id = currentlyExecutingRequest.getRequestId();
      value = currentlyExecutingRequest.getValue();
    }
    final SearchResult result = new SearchResult(id, value, movies, theaters, upcomingMovies);
    ThreadingUtilities.performOnMainThread(new Runnable() {
      public void run() {
        reportResult(result);
      }
    });
  }

  private void searchThreadEntryPoint() throws InterruptedException {
    while (true) {
      synchronized (gate) {
        while (nextSearchRequest == null) {
          gate.wait();
        }

        this.currentlyExecutingRequest = nextSearchRequest;
        this.nextSearchRequest = null;
      }

      search();
      this.currentlyExecutingRequest = null;
    }
  }

  public void submitRequest(final String string) {
    synchronized (gate) {
      currentRequestId++;
      this.nextSearchRequest = new SearchRequest(currentRequestId, string, model);
      gate.notifyAll();
    }
  }

  private void reportResult(final SearchResult result) {
    synchronized (gate) {
      if (result.getRequestId() != currentRequestId) {
        return;
      }
    }

    delegate.reportResult(result);
  }

  public void invalidateExistingRequests() {
    synchronized (gate) {
      currentRequestId++;
      this.nextSearchRequest = null;
    }
  }
}