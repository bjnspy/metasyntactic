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
package org.metasyntactic.caches;

import static java.lang.String.valueOf;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import static org.metasyntactic.utilities.XmlUtilities.children;

import java.io.File;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.metasyntactic.Constants;
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingModel;
import org.metasyntactic.data.Movie;
import org.metasyntactic.providers.DataProvider;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.XmlUtilities;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

public class UpcomingCache extends AbstractMovieCache {
  private static int identifier;
  private final DateFormat formatter = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z", Locale.US);

  private String hash;
  private List<Movie> movies;
  private Map<String, String> studioKeys;
  private Map<String, String> titleKeys;
  private boolean updated;

  public UpcomingCache(final NowPlayingModel model) {
    super(model);
  }

  private static File hashFile() {
    return new File(NowPlayingApplication.upcomingDirectory, "Hash");
  }

  private static File moviesFile() {
    return new File(NowPlayingApplication.upcomingDirectory, "Movies");
  }

  private static File studiosFile() {
    return new File(NowPlayingApplication.upcomingDirectory, "Studios");
  }

  private static File titlesFile() {
    return new File(NowPlayingApplication.upcomingDirectory, "Titles");
  }

  private String getHash() {
    if (hash == null) {
      hash = FileUtilities.readString(hashFile());
      if (hash == null) {
        hash = "";
      }
    }

    return hash;
  }

  public List<Movie> getMovies() {
    if (movies == null) {
      final Date today = new Date();
      List<Movie> list = FileUtilities.readPersistableList(Movie.reader, moviesFile());
      if (list == null) {
        list = Collections.emptyList();
      }
      for (final Iterator<Movie> iterator = list.iterator(); iterator.hasNext();) {
        final Movie movie = iterator.next();

        if (movie.getReleaseDate() != null && movie.getReleaseDate().compareTo(today) < 0) {
          iterator.remove();
        }
      }

      movies = list;
    }

    return Collections.unmodifiableList(movies);
  }

  private Map<String, String> getStudioKeys() {
    if (studioKeys == null) {
      studioKeys = FileUtilities.readStringToStringMap(studiosFile());
      if (studioKeys == null) {
        studioKeys = Collections.emptyMap();
      }
    }

    return studioKeys;
  }

  private Map<String, String> getTitleKeys() {
    if (titleKeys == null) {
      titleKeys = FileUtilities.readStringToStringMap(titlesFile());
      if (titleKeys == null) {
        titleKeys = Collections.emptyMap();
      }
    }

    return titleKeys;
  }

  public void update() {
    if (isNullOrEmpty(model.getUserAddress())) {
      return;
    }

    if (updated) {
      return;
    }
    updated = true;
    updateIndex();
  }

  private void updateIndex() {
    final Runnable runnable = new Runnable() {
      public void run() {
        updateIndexBackgroundEntryPoint();
      }
    };
    ThreadingUtilities.performOnBackgroundThread("UpcomingCache-UpdateIndex", runnable, null, true);
  }

  private void updateIndexBackgroundEntryPoint() {
    final long start = System.currentTimeMillis();
    updateIndexBackgroundEntryPointWorker();
    LogUtilities.logTime(UpcomingCache.class, "Update Index", start);

    updatedMoviesClear();
    model.getCacheUpdater().addMovies(getMovies());
  }

  private void updateIndexBackgroundEntryPointWorker() {
    final Map<String, String> localStudioKeys = new HashMap<String, String>();
    final Map<String, String> localTitleKeys = new HashMap<String, String>();
    final List<Movie> localMovies = new ArrayList<Movie>();

    final File indexFile = hashFile();
    if (indexFile.exists()) {
      if (FileUtilities.daysSinceNow(indexFile) < 3) {
        return;
      }
    }

    final String localHash = getHash();
    final String serverHash1 = NetworkUtilities.downloadString("http://" + NowPlayingApplication.host + ".appspot.com/LookupUpcomingListings?q=index&hash=true", false/* important */);
    final String serverHash2 = serverHash1 == null ? "0" : serverHash1;
    if (shutdown) { return; }

    if (localHash.equals(serverHash2)) {
      return;
    }

    long start = System.currentTimeMillis();
    final Element resultElement = NetworkUtilities.downloadXml("http://" + NowPlayingApplication.host + ".appspot.com/LookupUpcomingListings?q=index", false/* important */);
    LogUtilities.logTime(DataProvider.class, "Update Index - Download Xml", start);
    if (shutdown) { return; }

    start = System.currentTimeMillis();
    processResultElement(resultElement, localMovies, localStudioKeys, localTitleKeys);
    LogUtilities.logTime(DataProvider.class, "Update Index - Process Xml", start);
    if (shutdown) { return; }
    if (localMovies.isEmpty()) {
      return;
    }

    reportResults(serverHash2, localMovies, localStudioKeys, localTitleKeys);

    start = System.currentTimeMillis();
    saveResults(serverHash2, localMovies, localStudioKeys, localTitleKeys);
    LogUtilities.logTime(DataProvider.class, "Update Index - Save Results", start);
  }

  private void reportResults(final String serverHash, final List<Movie> movies, final Map<String, String> studioKeys,
      final Map<String, String> titleKeys) {
    final Runnable runnable = new Runnable() {
      public void run() {
        reportResultsOnMainThread(serverHash, movies, studioKeys, titleKeys);
      }
    };
    ThreadingUtilities.performOnMainThread(runnable);
  }

  private void reportResultsOnMainThread(final String serverHash, final List<Movie> movies, final Map<String, String> studioKeys,
      final Map<String, String> titleKeys) {
    hash = serverHash;
    this.movies = movies;
    this.studioKeys = studioKeys;
    this.titleKeys = titleKeys;
  }

  private static void saveResults(final String serverHash, final Collection<Movie> movies, final Map<String, String> studios,
      final Map<String, String> titles) {
    FileUtilities.writePersistableCollection(movies, moviesFile());
    FileUtilities.writeStringToStringMap(studios, studiosFile());
    FileUtilities.writeStringToStringMap(titles, titlesFile());

    // this file has to be last. it's what we use to determine if we should
    // update or not.
    FileUtilities.writeString(serverHash, hashFile());
  }

  private void processResultElement(final Node resultElement, final Collection<Movie> movies, final Map<String, String> studioKeys,
      final Map<String, String> titleKeys) {
    for (final Element movieElement : children(resultElement)) {
      if (shutdown) {
        return;
      }
      processMovieElement(movieElement, movies, studioKeys, titleKeys);
    }
  }

  private static String massageTitle(final String title) {
    if (title == null) {
      return null;
    }
    return title.replace("&amp;", "&");
  }

  private void processMovieElement(final Element movieElement, final Collection<Movie> movies, final Map<String, String> studioKeys,
      final Map<String, String> titleKeys) {
    final Date releaseDate;
    try {
      releaseDate = formatter.parse(movieElement.getAttribute("date"));
    } catch (final ParseException e) {
      throw new RuntimeException(e);
    }
    final String poster = movieElement.getAttribute("poster");
    final String rating = movieElement.getAttribute("rating");
    final String studio = movieElement.getAttribute("studio");
    final String title = massageTitle(movieElement.getAttribute("title"));
    final List<String> directors = processArray(XmlUtilities.element(movieElement, "directors"));
    final List<String> cast = processArray(XmlUtilities.element(movieElement, "actors"));
    final List<String> genres = processArray(XmlUtilities.element(movieElement, "genres"));
    final String studioKey = movieElement.getAttribute("studioKey");
    final String titleKey = movieElement.getAttribute("titleKey");

    final Movie movie = new Movie(valueOf(identifier), title, rating, 0, "", releaseDate, poster, "", studio, directors, cast, genres);

    identifier++;
    movies.add(movie);
    studioKeys.put(movie.getCanonicalTitle(), studioKey);
    titleKeys.put(movie.getCanonicalTitle(), titleKey);
  }

  private static List<String> processArray(final Node element) {
    final List<String> result = new ArrayList<String>();
    for (final Element child : children(element)) {
      result.add(child.getAttribute("value"));
    }
    return result;
  }

  @Override protected void updateMovieDetailsWorker(final Movie movie) {
    if (movie == null) {
      return;
    }
    final String studioKey = getStudioKeys().get(movie.getCanonicalTitle());
    final String titleKey = getTitleKeys().get(movie.getCanonicalTitle());

    updateDetails(movie, studioKey, titleKey);
  }

  private void updateDetails(final Movie movie, final String studioKey, final String titleKey) {
    if (!isNullOrEmpty(studioKey) && !isNullOrEmpty(titleKey)) {
      updateSynopsisAndCast(movie, studioKey, titleKey);
      updateTrailers(movie, studioKey, titleKey);
    }
  }

  private static File getCastFile(final Movie movie) {
    return new File(NowPlayingApplication.upcomingCastDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
  }

  private static File getSynopsisFile(final Movie movie) {
    return new File(NowPlayingApplication.upcomingSynopsesDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
  }

  private static File getTrailersFile(final Movie movie) {
    return new File(NowPlayingApplication.upcomingTrailersDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
  }

  private static void updateTrailers(final Movie movie, final String studioKey, final String titleKey) {
    final File file = getTrailersFile(movie);
    if (file.exists()) {
      if (FileUtilities.daysSinceNow(file) < 3) {
        return;
      }
    }

    final String trailersString = NetworkUtilities.downloadString("http://" + NowPlayingApplication.host + ".appspot.com/LookupTrailerListings?studio=" + studioKey + "&name=" + titleKey, false);

    if (isNullOrEmpty(trailersString)) {
      return;
    }

    final String[] trailers = trailersString.split("\n");
    if (trailers.length == 0) {
      return;
    }

    FileUtilities.writeString(trailers[0], file);

    NowPlayingApplication.refresh();
  }

  private static void updateSynopsisAndCast(final Movie movie, final String studioKey, final String titleKey) {
    final File file = getSynopsisFile(movie);
    if (file.exists()) {
      if (Math.abs(file.lastModified() - new Date().getTime()) < Constants.ONE_WEEK) {
        return;
      }
    }

    final String result = NetworkUtilities.downloadString(
        "http://" + NowPlayingApplication.host + ".appspot.com/LookupUpcomingListings?format=2&studio=" + studioKey + "&name=" + titleKey, false);

    if (isNullOrEmpty(result)) {
      return;
    }

    final String[] values = result.split("\n");
    if (values.length == 0) {
      return;
    }

    final String synopsis = values[0];
    final Collection<String> cast = new ArrayList<String>(values.length - 1);
    cast.addAll(Arrays.asList(values).subList(1, values.length));

    boolean refresh = false;
    if (!synopsis.startsWith("No Synopsis")) {
      FileUtilities.writeString(synopsis, file);
      refresh = true;
    }

    if (!cast.isEmpty()) {
      FileUtilities.writeStringCollection(cast, getCastFile(movie));
      refresh = true;
    }

    if (refresh) {
      NowPlayingApplication.refresh();
    }
  }

  public static String getTrailer(final Movie movie) {
    return FileUtilities.readString(getTrailersFile(movie));
  }
  public static String getSynopsis(final Movie movie) {
    return FileUtilities.readString(getSynopsisFile(movie));
  }

  @Override
  protected List<File> getCacheDirectories() {
    return Arrays.asList(NowPlayingApplication.upcomingCastDirectory,
        NowPlayingApplication.upcomingSynopsesDirectory,
        NowPlayingApplication.upcomingTrailersDirectory);
  }

  public static List<String> getCast(final Movie movie) {
    return FileUtilities.readStringList(getCastFile(movie));
  }
}