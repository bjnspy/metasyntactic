package org.metasyntactic;

import android.app.ListActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.*;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.utilities.StringUtilities;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class MovieDetailsActivity extends ListActivity {
  /**
   * Called when the activity is first created.
   */
  private final List<MovieDetailEntry> movieDetailEntries = new ArrayList<MovieDetailEntry>();
  private Movie movie;

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.addActivity(this);
    setContentView(R.layout.moviedetails);
    this.movie = getIntent().getExtras().getParcelable("movie");
    TextView title = (TextView) findViewById(R.id.title);
    title.setText(movie.getDisplayTitle());
    populateMovieDetailEntries();
    final MovieAdapter movieAdapter = new MovieAdapter();
    setListAdapter(movieAdapter);
  }

  private void populateMovieDetailEntries() {
    final Resources res = MovieDetailsActivity.this.getResources();
    // TODO move strings to res/strings.xml
    // Add title and synopsis
    {
      final String synopsis = this.movie.getSynopsis();
      String value;
      if (!StringUtilities.isNullOrEmpty(synopsis)) {
        value = synopsis;
      } else {
        value = res.getString(R.string.no_synopsis_available_dot);
      }
      final MovieDetailEntry entry = new MovieDetailEntry(this.movie.getDisplayTitle(), value);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add Rating
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.rated),
                                                          MovieViewUtilities.formatRatings(this.movie.getRating(),
                                                                                           res));
      this.movieDetailEntries.add(entry);
    }
    {
      // Add release Date
      final Date releaseDate = this.movie.getReleaseDate();
      final String releaseDateString = releaseDate == null ? res
          .getString(R.string.unknown_release_date) : releaseDate.toString();
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.release_date),
                                                          releaseDateString);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add length
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.running_time),
                                                          MovieViewUtilities.formatLength(this.movie.getLength(), res));
      this.movieDetailEntries.add(entry);
    }
    {
      // Add cast
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.cast),
                                                          MovieViewUtilities.formatListToString(this.movie.getCast()));
      this.movieDetailEntries.add(entry);
    }
    {
      // Add cast
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.director),
                                                          MovieViewUtilities.formatListToString(
                                                              this.movie.getDirectors()));
      this.movieDetailEntries.add(entry);
    }
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  private class MovieAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public MovieAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(MovieDetailsActivity.this);
    }

    public Object getEntry(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = this.inflater.inflate(R.layout.moviedetails_item, null);
      // Creates a MovieViewHolder and store references to the
      // children views we want to bind data to.
      final MovieViewHolder holder = new MovieViewHolder((TextView) convertView
          .findViewById(R.id.name), (TextView) convertView.findViewById(R.id.value),
                                                         (ImageView) convertView.findViewById(R.id.divider));
      final MovieDetailEntry entry = MovieDetailsActivity.this.movieDetailEntries.get(position);
      holder.name.setText(entry.name);
      holder.value.setText(entry.value);
      if (position == 0) {
        holder.name.setVisibility(View.GONE);
        holder.divider.setVisibility(View.GONE);
      }
      return convertView;
    }

    public int getCount() {
      return MovieDetailsActivity.this.movieDetailEntries.size();
    }

    private class MovieViewHolder {
      private final TextView name;
      private final TextView value;
      private ImageView divider;

      private MovieViewHolder(final TextView name, final TextView value, final ImageView divider) {
        this.name = name;
        this.value = value;
        this.divider = divider;
      }
    }

    public long getEntryId(final int position) {
      return position;
    }

    public Object getItem(final int position) {
      return MovieDetailsActivity.this.movieDetailEntries.get(position);
    }

    public long getItemId(final int position) {
      return position;
    }

    public void refresh() {
      notifyDataSetChanged();
    }
  }

  private class MovieDetailEntry {
    private final String name;
    private final String value;

    private MovieDetailEntry(final String name, final String value) {
      this.name = name;
      this.value = value;
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_SHOWTIMES, 0, R.string.menu_showtimes).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class))
        .setAlphabeticShortcut('s');
    menu.add(0, MovieViewUtilities.MENU_TRAILERS, 0, R.string.menu_trailers).setIcon(
        R.drawable.movies).setIntent(new Intent(this, NowPlayingActivity.class))
        .setAlphabeticShortcut('t');
    menu.add(0, MovieViewUtilities.MENU_REVIEWS, 0, R.string.menu_reviews).setIcon(
        R.drawable.theatres);
    menu.add(0, MovieViewUtilities.MENU_IMDB, 0, R.string.menu_imdb).setIcon(R.drawable.upcoming);
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(R.drawable.movies)
        .setIntent(new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_THEATER, 0, R.string.menu_theater).setIcon(
        R.drawable.theatres);
    menu.add(0, MovieViewUtilities.MENU_UPCOMING, 0, R.string.menu_upcoming).setIcon(
        R.drawable.upcoming);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.menu_settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class));
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {
    switch (item.getItemId()) {
      case MovieViewUtilities.MENU_IMDB:
        String imdb_url = null;
        imdb_url = NowPlayingControllerWrapper.getIMDbAddress(MovieDetailsActivity.this.movie);
        if (imdb_url != null) {
          final Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(imdb_url));
          startActivity(intent);
        } else {
          Toast.makeText(MovieDetailsActivity.this,
                         "This movie's IMDB information is not available.", Toast.LENGTH_SHORT).show();
        }
        break;
      case MovieViewUtilities.MENU_TRAILERS:
        final String trailer_url = NowPlayingControllerWrapper
            .getTrailer(MovieDetailsActivity.this.movie);
        if (!StringUtilities.isNullOrEmpty(trailer_url)) {
          final Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(trailer_url));
          startActivity(intent);
        } else {
          Toast.makeText(MovieDetailsActivity.this, "This movie's trailers are not available.",
                         Toast.LENGTH_SHORT).show();
        }
        break;
      case MovieViewUtilities.MENU_REVIEWS:
        // doing this as the getReviews() throws NPE instead null return.
        ArrayList<Review> reviews = new ArrayList<Review>();
        if (NowPlayingControllerWrapper.getScore(MovieDetailsActivity.this.movie) != null) {
          reviews = new ArrayList<Review>(NowPlayingControllerWrapper
              .getReviews(MovieDetailsActivity.this.movie));
        }
        if (reviews.size() > 0) {
          final Intent intent = new Intent();
          intent.putParcelableArrayListExtra("reviews", reviews);
          intent.setClass(MovieDetailsActivity.this, AllReviewsActivity.class);
          startActivity(intent);
        } else {
          Toast.makeText(MovieDetailsActivity.this, "This movie's reviews are not yet available.",
                         Toast.LENGTH_SHORT).show();
        }
        break;
      case MovieViewUtilities.MENU_SHOWTIMES:
        final Intent intent_showtimes = new Intent();
        intent_showtimes.setClass(MovieDetailsActivity.this, ShowtimesActivity.class);
        intent_showtimes.putExtra("movie", (Parcelable) MovieDetailsActivity.this.movie);
        startActivity(intent_showtimes);
        break;
      case MovieViewUtilities.MENU_THEATER:
        final Intent intent = new Intent();
        intent.setClass(MovieDetailsActivity.this, AllTheatersActivity.class);
        startActivity(intent);
    }
    return false;
  }
}
