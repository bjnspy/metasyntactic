package org.metasyntactic;

import android.app.ListActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.utilities.MovieViewUtilities;

import java.util.ArrayList;
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
    final Resources res = getResources();
    // Add title and synopsis
    MovieDetailEntry entry = new MovieDetailEntry();
    entry.setName(this.movie.getDisplayTitle());
    final String synopsis = this.movie.getSynopsis();
    if (synopsis != null && synopsis.length() > 0) {
      entry.setValue(synopsis);
    } else {
      entry.setValue("Unknown");
    }
    this.movieDetailEntries.add(entry);
    // Add Rating
    entry = new MovieDetailEntry();
    entry.setName("Rating");
    entry.setValue(MovieViewUtilities.formatRatings(this.movie.getRating(), res)
        .toString());
    this.movieDetailEntries.add(entry);
    // Add release Date
    entry = new MovieDetailEntry();
    entry.setName("Release Date");
    entry.setValue(this.movie.getReleaseDate().toLocaleString());
    this.movieDetailEntries.add(entry);
    // Add length
    entry = new MovieDetailEntry();
    entry.setName("Duration");
    entry.setValue(MovieViewUtilities.formatLength(this.movie.getLength(), res)
        .toString());
    this.movieDetailEntries.add(entry);
    // Add cast
    entry = new MovieDetailEntry();
    entry.setName("Cast");
    entry.setValue(MovieViewUtilities.formatListToString(this.movie.getCast()));
    this.movieDetailEntries.add(entry);
    // Add cast
    entry = new MovieDetailEntry();
    entry.setName("Director");
    entry.setValue(MovieViewUtilities.formatListToString(this.movie.getDirectors()));
    this.movieDetailEntries.add(entry);
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  void bindButtonClickListeners() {
    final Button imdbbtn = (Button) findViewById(R.id.imdbbtn);
    final Button reviewsbtn = (Button) findViewById(R.id.reviewsbtn);
    final Button showtimes = (Button) findViewById(R.id.showtimesbtn);
    imdbbtn.setOnClickListener(new OnClickListener() {
      public void onClick(final View v) {
        String imdb_url = null;
        imdb_url = NowPlayingControllerWrapper.getImdbAddress(MovieDetailsActivity.this.movie);
        if (imdb_url != null) {
          final Intent intent = new Intent();
          intent.putExtra("imdb_url", imdb_url);
          intent.setClass(MovieDetailsActivity.this, WebViewActivity.class);
          startActivity(intent);
        } else {
          Toast.makeText(MovieDetailsActivity.this, "This movie's IMDB information is not available.",
                         Toast.LENGTH_SHORT).show();
        }
      }
    });
    reviewsbtn.setOnClickListener(new OnClickListener() {
      public void onClick(final View v) {
        final ArrayList<Review> reviews = new ArrayList<Review>(NowPlayingControllerWrapper
            .getReviews(MovieDetailsActivity.this.movie));
        if (reviews != null && reviews.size() > 0) {
          final Intent intent = new Intent();
          intent.putParcelableArrayListExtra("reviews", reviews);
          intent.setClass(MovieDetailsActivity.this, AllReviewsActivity.class);
          startActivity(intent);
        } else {
          Toast.makeText(MovieDetailsActivity.this, "This movie's reviews are not yet available.", Toast.LENGTH_SHORT)
              .show();
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
      final MovieViewHolder holder = new MovieViewHolder();
      holder.name = (TextView) convertView.findViewById(R.id.name);
      holder.value = (TextView) convertView.findViewById(R.id.value);
      final MovieDetailEntry entry = MovieDetailsActivity.this.movieDetailEntries.get(position);
      holder.name.setText(entry.getName());
      holder.value.setText(entry.getValue());
      if (position == 0) {
        holder.name.setTextAppearance(MovieDetailsActivity.this, android.R.attr.textAppearanceLarge);
        holder.name.setBackgroundResource(R.drawable.shape_1);
        holder.name.setMinHeight(50);
      }
      return convertView;
    }

    public int getCount() {
      return MovieDetailsActivity.this.movieDetailEntries.size();
    }

    private class MovieViewHolder {
      TextView name;
      TextView value;
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
    String name;
    String value;

    public String getName() {
      return this.name;
    }

    public void setName(final String name) {
      this.name = name;
    }

    public String getValue() {
      return this.value;
    }

    public void setValue(final String value) {
      this.value = value;
    }
  }
}
