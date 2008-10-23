package org.metasyntactic.caches;

import org.metasyntactic.Application;
import org.metasyntactic.Constants;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.NetworkUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.metasyntactic.utilities.XmlUtilities;
import static org.metasyntactic.utilities.XmlUtilities.children;
import org.w3c.dom.Element;

import java.io.File;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.*;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class UpcomingCache {
	private final Object lock = new Object();
	private static int identifier;

	private final SimpleDateFormat formatter = new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z");

	private String hash;
	private List<Movie> movies;
	private Map<String, String> studioKeys;
	private Map<String, String> titleKeys;


	private File hashFile() {
		return new File(Application.upcomingDirectory, "Hash");
	}


	private File moviesFile() {
		return new File(Application.upcomingDirectory, "Movies");
	}


	private File studiosFile() {
		return new File(Application.upcomingDirectory, "Studios");
	}


	private File titlesFile() {
		return new File(Application.upcomingDirectory, "Titles");
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


	private List<Movie> getMovies() {
		if (movies == null) {
			movies = FileUtilities.readPersistableList(Movie.reader, moviesFile());
      if (movies == null) {
        movies = Collections.emptyList();
      }
    }

		return movies;
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
		updateDetails();
		updateIndex();
	}


	private void updateDetails() {
		final List<Movie> movies = getMovies();
		final Map<String, String> studioKeys = getStudioKeys();
		final Map<String, String> titleKeys = getTitleKeys();

		Runnable runnable = new Runnable() {
			public void run() {
				updateDetailsBackgroundEntryPoint(movies, studioKeys, titleKeys);
			}
		};
		ThreadingUtilities.performOnBackgroundThread(runnable, lock, true);
	}


	private void updateIndex() {
		Runnable runnable = new Runnable() {
			public void run() {
				updateIndexBackgroundEntryPoint();
			}
		};
		ThreadingUtilities.performOnBackgroundThread(runnable, lock, true);
	}


	private void updateIndexBackgroundEntryPoint() {
		final Map<String, String> studioKeys = new HashMap<String, String>();
		final Map<String, String> titleKeys = new HashMap<String, String>();
		final List<Movie> movies = new ArrayList<Movie>();

		File indexFile = hashFile();
		if (indexFile.exists()) {
			long lastModifiedTime = indexFile.lastModified();

			if (Math.abs(lastModifiedTime - new Date().getTime()) < (3 * Constants.ONE_DAY)) {
				return;
			}
		}

		String localHash = getHash();
		String serverHash_ = NetworkUtilities.downloadString(
				"http://metaboxoffice2.appspot.com/LookupUpcomingListings?q=index&hash=true", false/* important */
		);
		final String serverHash = serverHash_ == null ? "0" : serverHash_;

		if (localHash.equals(serverHash)) {
			return;
		}

		Element resultElement = NetworkUtilities.downloadXml(
				"http://metaboxoffice2.appspot.com/LookupUpcomingListings?q=index", false/* important */
		);

		processResultElement(resultElement, movies, studioKeys, titleKeys);
		if (movies.isEmpty()) {
			return;
		}

		reportResults(serverHash, movies, studioKeys, titleKeys);
		saveResults(serverHash, movies, studioKeys, titleKeys);
	}


	private void reportResults(final String serverHash, final List<Movie> movies, final Map<String, String> studioKeys,
			final Map<String, String> titleKeys) {
		Runnable runnable = new Runnable() {
			public void run() {
				reportResultsOnMainThread(serverHash, movies, studioKeys, titleKeys);
			}
		};
		ThreadingUtilities.performOnMainThread(runnable);
	}


	private void reportResultsOnMainThread(String serverHash, List<Movie> movies, Map<String, String> studioKeys,
			Map<String, String> titleKeys) {
		this.hash = serverHash;
		this.movies = movies;
		this.studioKeys = studioKeys;
		this.titleKeys = titleKeys;

		updateDetails();
	}


	private void saveResults(String serverHash, List<Movie> movies, Map<String, String> studios,
			Map<String, String> titles) {
		FileUtilities.writeString(serverHash, hashFile());
		FileUtilities.writePersistableCollection(movies, moviesFile());
		FileUtilities.writeStringToStringMap(studios, studiosFile());
		FileUtilities.writeStringToStringMap(titles, titlesFile());
	}


	private void processResultElement(Element resultElement, List<Movie> movies, Map<String, String> studioKeys,
			Map<String, String> titleKeys) {
		for (Element movieElement : children(resultElement)) {
			processMovieElement(movieElement, movies, studioKeys, titleKeys);
		}
	}


	private void processMovieElement(Element movieElement, List<Movie> movies, Map<String, String> studioKeys,
			Map<String, String> titleKeys) {
		Date releaseDate = null;
		try {
			releaseDate = formatter.parse(movieElement.getAttribute("date"));
		} catch (ParseException e) {
			throw new RuntimeException(e);
		}
		String poster = movieElement.getAttribute("poster");
		String rating = movieElement.getAttribute("rating");
		String studio = movieElement.getAttribute("studio");
		String title = movieElement.getAttribute("title");
		List<String> directors = processArray(XmlUtilities.element(movieElement, "directors"));
		List<String> cast = processArray(XmlUtilities.element(movieElement, "actors"));
		List<String> genres = processArray(XmlUtilities.element(movieElement, "genres"));
		String studioKey = movieElement.getAttribute("studioKey");
		String titleKey = movieElement.getAttribute("titleKey");

		Movie movie = new Movie("" + identifier++, title, rating, 0, "", releaseDate, poster, "", studio, directors, cast,
				genres);

		movies.add(movie);
		studioKeys.put(movie.getCanonicalTitle(), studioKey);
		titleKeys.put(movie.getCanonicalTitle(), titleKey);
	}


	private List<String> processArray(Element element) {
		List<String> result = new ArrayList<String>();
		for (Element child : children(element)) {
			result.add(child.getAttribute("value"));
		}
		return result;
	}


	private void updateDetailsBackgroundEntryPoint(List<Movie> movies, Map<String, String> studioKeys,
			Map<String, String> titleKeys) {
		if (movies.isEmpty()) {
			return;
		}

		for (Movie movie : movies) {
			updateDetails(movie, studioKeys.get(movie.getCanonicalTitle()), titleKeys.get(movie.getCanonicalTitle()));
		}
	}


	private void updateDetails(Movie movie, String studioKey, String titleKey) {
		updateImdb(movie);
		updatePoster(movie);
		updateSynopsis(movie, studioKey, titleKey);
		updateTrailers(movie, studioKey, titleKey);
		/*
		 * [self updateIMDb:movie]; [self updatePoster:movie]; [self
		 * updateSynopsis:movie studio:studio title:title]; [self
		 * updateTrailers:movie studio:studio title:title]; [NowPlayingAppDelegate
		 * refresh];
		 */
	}


	private File getImdbFile(Movie movie) {
		return new File(Application.upcomingImdbDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
	}


	private File getPosterFile(Movie movie) {
		return new File(Application.upcomingPostersDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
	}


	private File getSynopsisFile(Movie movie) {
		return new File(Application.upcomingSynopsesDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
	}


	private File getTrailersFile(Movie movie) {
		return new File(Application.upcomingTrailersDirectory, FileUtilities.sanitizeFileName(movie.getCanonicalTitle()));
	}


	private void updateTrailers(Movie movie, String studioKey, String titleKey) {
		File file = getTrailersFile(movie);
		if (file.exists()) {
			if (Math.abs(file.lastModified() - new Date().getTime()) < (3 * Constants.ONE_DAY)) {
				return;
			}
		}

		String trailersString = NetworkUtilities.downloadString(
				"http://metaboxoffice2.appspot.com/LookupTrailerListings?studio=" + studioKey + "&name=" + titleKey, false);

		if (StringUtilities.isNullOrEmpty(trailersString)) {
			return;
		}

		String[] trailers = trailersString.split("\n");
		if (trailers.length == 0) {
			return;
		}

		FileUtilities.writeStringCollection(Arrays.asList(trailers), file);

		Application.refresh();
	}


	private void updateSynopsis(Movie movie, String studioKey, String titleKey) {
		File file = getSynopsisFile(movie);
		if (file.exists()) {
			if (Math.abs(file.lastModified() - new Date().getTime()) < Constants.ONE_WEEK) {
				return;
			}
		}

		String synopsis = NetworkUtilities.downloadString(
				"http://metaboxoffice2.appspot.com/LookupUpcomingListings?studio=" + studioKey + "&name=" + titleKey, false);

		if (StringUtilities.isNullOrEmpty(synopsis) || synopsis.startsWith("No synopsis")) {
			return;
		}

		FileUtilities.writeString(synopsis, file);

		Application.refresh();
	}


	private void updatePoster(Movie movie) {
		if (StringUtilities.isNullOrEmpty(movie.getPoster())) {
			return;
		}

		File file = getPosterFile(movie);
		if (file.exists()) {
			return;
		}

		byte[] data = NetworkUtilities.download(movie.getPoster(), false);
		if (data == null) {
			return;
		}

		FileUtilities.writeBytes(data, file);

		Application.refresh();
	}


	private void updateImdb(Movie movie) {
		File file = getImdbFile(movie);
		if (file.exists()) {
			return;
		}

		String imdbAddress = NetworkUtilities.downloadString("http://metaboxoffice2.appspot.com/LookupIMDbListings?q="
				+ StringUtilities.urlEncode(movie.getCanonicalTitle()), false);

		if (StringUtilities.isNullOrEmpty(imdbAddress)) {
			return;
		}

		FileUtilities.writeString(imdbAddress, file);

		Application.refresh();
	}
}
