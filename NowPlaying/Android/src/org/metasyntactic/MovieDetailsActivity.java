package org.metasyntactic;

import android.app.ListActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
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
  /** Called when the activity is first created. */
  private final List<MovieDetailEntry> movieDetailEntries = new ArrayList<MovieDetailEntry>();
  private Movie movie;

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.addActivity(this);
    setContentView(R.layout.moviedetails);
    this.movie = getIntent().getExtras().getParcelable("movie");
    populateMovieDetailEntries();
    final MovieAdapter movieAdapter = new MovieAdapter();
    setListAdapter(movieAdapter);
    bindButtonClickListeners();
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
          MovieViewUtilities.formatRatings(this.movie.getRating(), res));
      this.movieDetailEntries.add(entry);
    }
    {
      // Add release Date
      final Date releaseDate = this.movie.getReleaseDate();
      final String releaseDateString = releaseDate == null ? res.getString(R.string.unknown_release_date)
          : releaseDate.toString();
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
          MovieViewUtilities.formatListToString(this.movie.getDirectors()));
      this.movieDetailEntries.add(entry);
    }
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  void bindButtonClickListeners() {
    final Button imdbbtn = (Button) findViewById(R.id.imdbbtn);
    final Button reviewsbtn = (Button) findViewById(R.id.reviewsbtn);
    final Button trailersbtn = (Button) findViewById(R.id.trailerbtn);
    final Button showtimes = (Button) findViewById(R.id.showtimesbtn);
    imdbbtn.setOnClickListener(new OnClickListener() {
      public void onClick(final View v) {
        String imdb_url = null;
        imdb_url = NowPlayingControllerWrapper.getImdbAddress(MovieDetailsActivity.this.movie);
        if (imdb_url != null) {
          final Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(imdb_url));
          startActivity(intent);
        } else {
          Toast.makeText(MovieDetailsActivity.this,
              "This movie's IMDB information is not available.", Toast.LENGTH_SHORT).show();
        }
      }
    });
    trailersbtn.setOnClickListener(new OnClickListener() {
      public void onClick(final View v) {
        final String trailer_url = NowPlayingControllerWrapper
            .getTrailer(MovieDetailsActivity.this.movie);

        if (!StringUtilities.isNullOrEmpty(trailer_url)) {
          final Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(trailer_url));
          startActivity(intent);
        } else {
          Toast.makeText(MovieDetailsActivity.this, "This movie's trailers are not available.",
              Toast.LENGTH_SHORT).show();
        }
      }
    });
    reviewsbtn.setOnClickListener(new OnClickListener() {
      public void onClick(final View v) {
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
      }
    });
    showtimes.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        final Intent intent = new Intent();
        intent.setClass(MovieDetailsActivity.this, ShowtimesActivity.class);
        intent.putExtra("movie", (Parcelable) MovieDetailsActivity.this.movie);
        startActivity(intent);
      }
    });
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
          .findViewById(R.id.name), (TextView) convertView.findViewById(R.id.value));
      final MovieDetailEntry entry = MovieDetailsActivity.this.movieDetailEntries.get(position);
      holder.name.setText(entry.name);
      holder.value.setText(entry.value);
      if (position == 0) {
        holder.name.setTextAppearance(MovieDetailsActivity.this, android.R.attr.textAppearanceLarge);
        //holder.name.setBackgroundResource(R.drawable.opaque_box);
        holder.name.setTextColor(Color.BLACK);

        holder.name.setMinHeight(50);
      }
      return convertView;
    }

    public int getCount() {
      return MovieDetailsActivity.this.movieDetailEntries.size();
    }

    private class MovieViewHolder {
      private final TextView name;
      private final TextView value;

      private MovieViewHolder(final TextView name, final TextView value) {
        this.name = name;
        this.value = value;
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
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(
        R.drawable.movies).setIntent(
            new Intent(this, NowPlayingActivity.class)).setAlphabeticShortcut('m');
    menu.add(0, MovieViewUtilities.MENU_THEATER, 0, R.string.menu_theater).setIcon(
        R.drawable.theatres);
    menu.add(0, MovieViewUtilities.MENU_UPCOMING, 0, R.string.menu_upcoming).setIcon(
        R.drawable.upcoming);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.menu_settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(
        new Intent(this, SettingsActivity.class)).setAlphabeticShortcut('s');
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {

    if (item.getItemId() == MovieViewUtilities.MENU_THEATER) {
      final Intent intent = new Intent();
      intent.setClass(MovieDetailsActivity.this, AllTheatersActivity.class);
      startActivity(intent);
      return true;
    }
    return false;
  }

}
