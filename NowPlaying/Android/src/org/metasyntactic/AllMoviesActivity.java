package org.metasyntactic;

import android.app.ListActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.utilities.StringUtilities;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/** @author mjoshi@google.com (Megha Joshi) */
public class AllMoviesActivity extends ListActivity {
  /** Called when the activity is first created. */
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
    // Get and set scores text and background image
    Button scoreImg = (Button) findViewById(R.id.score);
    TextView scoreLbl = (TextView) findViewById(R.id.scorelbl);
    // TextView scoreLabel = (TextView)findViewById(R.id.scoreLabel);
    final Resources res = getResources();
    final Score score = NowPlayingControllerWrapper.getScore(movie);
    int scoreValue = -1;
    if (score != null && !score.getValue().equals("")) {
      scoreValue = Integer.parseInt(score.getValue());
    } else {
    }
    final ScoreType scoreType = NowPlayingControllerWrapper.getScoreType();
    scoreImg.setBackgroundDrawable(MovieViewUtilities.formatScoreDrawable(scoreValue, scoreType,
        res));
    if (scoreValue != -1) {
      scoreLbl.setText(String.valueOf(scoreValue) + "%");
    }
    TextView ratingLengthLabel = (TextView) findViewById(R.id.ratingLength);
    final CharSequence rating = MovieViewUtilities.formatRatings(movie.getRating(), res);
    final CharSequence length = MovieViewUtilities.formatLength(movie.getLength(), res);
    ratingLengthLabel.setText(rating + ". " + length);
    populateMovieDetailEntries();
    final MovieAdapter movieAdapter = new MovieAdapter();
    setListAdapter(movieAdapter);
    final Button showtimes = (Button) findViewById(R.id.showtimes);
    showtimes.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
       final Intent intent = new Intent();
        intent.setClass(AllMoviesActivity.this, ShowtimesActivity.class);
        intent.putExtra("movie", (Parcelable) movie);
        startActivity(intent);
      }
    });
   
    
  }

  private void populateMovieDetailEntries() {
    final Resources res = AllMoviesActivity.this.getResources();
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
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.synopsis), value,
          MovieDetailItemType.POSTER_SYNOPSIS, null);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add release Date
      final Date releaseDate = this.movie.getReleaseDate();
      final String releaseDateString = releaseDate == null ? res
          .getString(R.string.unknown_release_date) : DateFormat.getDateInstance(DateFormat.LONG)
          .format(releaseDate);
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.release_date),
          releaseDateString, MovieDetailItemType.DATA, null);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add cast
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.cast),
          MovieViewUtilities.formatListToString(this.movie.getCast()), MovieDetailItemType.DATA,
          null);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add director
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.director),
          MovieViewUtilities.formatListToString(this.movie.getDirectors()),
          MovieDetailItemType.DATA, null);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add header
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.options), null,
          MovieDetailItemType.HEADER, null);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add trailer
      final String trailer_url = NowPlayingControllerWrapper
          .getTrailer(AllMoviesActivity.this.movie);
      Intent intent = null;
      if (!StringUtilities.isNullOrEmpty(trailer_url)) {
        intent = new Intent("android.intent.action.VIEW", Uri.parse(trailer_url));
      }
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.menu_trailers),
          null, MovieDetailItemType.ACTION, intent);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add reviews
      // doing this as the getReviews() throws NPE instead null return.
      ArrayList<Review> reviews = new ArrayList<Review>();
      if (NowPlayingControllerWrapper.getScore(AllMoviesActivity.this.movie) != null) {
        reviews = new ArrayList<Review>(NowPlayingControllerWrapper
            .getReviews(AllMoviesActivity.this.movie));
      }
      Intent intent = null;
      if (reviews.size() > 0) {
        intent = new Intent();
        intent.putParcelableArrayListExtra("reviews", reviews);
        intent.setClass(AllMoviesActivity.this, AllReviewsActivity.class);
      }
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.menu_reviews),
          null, MovieDetailItemType.ACTION, intent);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add IMDb link
      String imdb_url = null;
      imdb_url = NowPlayingControllerWrapper.getIMDbAddress(AllMoviesActivity.this.movie);
      Intent intent = null;
      if (imdb_url != null) {
        intent = new Intent("android.intent.action.VIEW", Uri.parse(imdb_url));
      }
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.menu_imdb), null,
          MovieDetailItemType.ACTION, intent);
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
      this.inflater = LayoutInflater.from(AllMoviesActivity.this);
    }

    public Object getEntry(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      final MovieDetailEntry entry = AllMoviesActivity.this.movieDetailEntries.get(position);
      switch (entry.type) {
      case POSTER_SYNOPSIS:
        convertView = this.inflater.inflate(R.layout.moviepostersynopsis, null);
       
        ImageView posterImage = (ImageView) convertView.findViewById(R.id.poster);
         TextView text1 = (TextView) convertView.findViewById(R.id.value1);
        TextView text2 = (TextView) convertView.findViewById(R.id.value2);
        final byte[] bytes = NowPlayingControllerWrapper.getPoster(movie);
        if (bytes.length > 0) {
          posterImage.setImageBitmap(BitmapFactory.decodeByteArray(bytes, 0, bytes.length));
          posterImage.setBackgroundResource(R.drawable.image_frame);
        }
        String synopsis = entry.value;
        if (synopsis.length() > 0) {
          // hack to display text on left and bottom or poster
          if (synopsis.length() > 300) {
            String desc1_text = synopsis.substring(0, synopsis.lastIndexOf(" ", 300));
            String desc2_text = synopsis.substring(synopsis.lastIndexOf(" ", 300));
            text1.setText(desc1_text);
            text2.setText(desc2_text);
          } else {
            text1.setText(synopsis);
          }
        }
        break;
      case DATA:
        convertView = this.inflater.inflate(R.layout.moviedetails_item, null);
        // Creates a MovieViewHolder and store references to the
        // children views we want to bind data to.
        final MovieViewHolder holder = new MovieViewHolder((TextView) convertView
            .findViewById(R.id.name), (TextView) convertView.findViewById(R.id.value),
            (ImageView) convertView.findViewById(R.id.divider));
        holder.name.setText(entry.name);
        holder.value.setText(entry.value);
        break;
      case HEADER:
        convertView = this.inflater.inflate(R.layout.headerview, null);
        final TextView headerView = (TextView) convertView.findViewById(R.id.name);
        headerView.setText(entry.name);
        break;
      case ACTION:
        convertView = this.inflater.inflate(R.layout.dataview, null);
        final TextView actionView = (TextView) convertView.findViewById(R.id.name);
        actionView.setText(entry.name);
        break;
      }
      return convertView;
    }

    public int getCount() {
      return AllMoviesActivity.this.movieDetailEntries.size();
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
      return AllMoviesActivity.this.movieDetailEntries.get(position);
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
    private final MovieDetailItemType type;
    private final Intent intent;

    private MovieDetailEntry(final String name, final String value, final MovieDetailItemType type,
        final Intent intent) {
      this.name = name;
      this.value = value;
      this.type = type;
      this.intent = intent;
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(
        R.drawable.ic_menu_home).setIntent(new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.menu_settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class));
    return super.onCreateOptionsMenu(menu);
  }

  enum MovieDetailItemType {
    POSTER_SYNOPSIS, DATA, ACTION, HEADER
  }

  @Override
  protected void onListItemClick(ListView l, View v, int position, long id) {
    Intent intent = movieDetailEntries.get(position).intent;
    if (intent != null) {
      startActivity(intent);
    }
    super.onListItemClick(l, v, position, id);
  }
}
