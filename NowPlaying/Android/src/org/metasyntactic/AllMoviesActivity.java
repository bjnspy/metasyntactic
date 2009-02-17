package org.metasyntactic;

import android.app.ListActivity;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcelable;
import android.text.Layout;
import android.text.StaticLayout;
import android.text.TextPaint;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
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

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class AllMoviesActivity extends ListActivity {
  /**
   * Called when the activity is first created.
   */
  private final List<MovieDetailEntry> movieDetailEntries = new ArrayList<MovieDetailEntry>();
  private Movie movie;

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Log.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);
    setContentView(R.layout.moviedetails);
  }

  private void populateMovieDetailEntries() {
    final Resources res = getResources();
    // Add title and synopsis
    {
      final String synopsis = NowPlayingControllerWrapper.getSynopsis(this.movie);
      final String value;
      if (StringUtilities.isNullOrEmpty(synopsis)) {
        value = res.getString(R.string.no_synopsis_available_dot);
      } else {
        value = synopsis;
      }
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.synopsis), value,
          MovieDetailItemType.POSTER_SYNOPSIS, null, false);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add release Date
      final Date releaseDate = this.movie.getReleaseDate();
      final String releaseDateString = releaseDate == null ? res
          .getString(R.string.unknown_release_date) : DateFormat.getDateInstance(DateFormat.LONG)
          .format(releaseDate);
      final MovieDetailEntry entry = new MovieDetailEntry(res
          .getString(R.string.release_date_colon), releaseDateString, MovieDetailItemType.DATA,
          null, false);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add cast
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.cast_colon),
          MovieViewUtilities.formatListToString(this.movie.getCast()), MovieDetailItemType.DATA,
          null, false);
      this.movieDetailEntries.add(entry);
    }
    // Add director
    final List<String> directors = this.movie.getDirectors();
    if (directors != null && !directors.isEmpty()) {
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.director_colon),
          MovieViewUtilities.formatListToString(directors), MovieDetailItemType.DATA, null, false);
      this.movieDetailEntries.add(entry);
    }
    {
      // Add header
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.more_options),
          null, MovieDetailItemType.HEADER, null, false);
      this.movieDetailEntries.add(entry);
    }
    // Add trailer
    final String trailer_url = NowPlayingControllerWrapper.getTrailer(this.movie);
    if (!StringUtilities.isNullOrEmpty(trailer_url) && trailer_url.startsWith("http")) {
      final Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(trailer_url));
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.play_trailer),
          null, MovieDetailItemType.ACTION, intent, true);
      this.movieDetailEntries.add(entry);
    }
    // Add reviews
    // doing this as the getReviews() throws NPE instead null return.
    ArrayList<Review> reviews = new ArrayList<Review>();
    if (NowPlayingControllerWrapper.getScore(this.movie) != null) {
      reviews = new ArrayList<Review>(NowPlayingControllerWrapper.getReviews(this.movie));
    }
    if (!reviews.isEmpty()) {
      final Intent intent = new Intent();
      intent.putParcelableArrayListExtra("reviews", reviews);
      intent.setClass(this, AllReviewsActivity.class);
      final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.read_reviews),
          null, MovieDetailItemType.ACTION, intent, true);
      this.movieDetailEntries.add(entry);
    }
    // Add IMDb link
    final String imdb_url = NowPlayingControllerWrapper.getIMDbAddress(this.movie);
    if (!StringUtilities.isNullOrEmpty(imdb_url) && imdb_url.startsWith("http")) {
      final Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(imdb_url));
      final MovieDetailEntry entry = new MovieDetailEntry("IMDb", null, MovieDetailItemType.ACTION,
          intent, true);
      this.movieDetailEntries.add(entry);
    }
  }

  @Override
  protected void onDestroy() {
    Log.i(getClass().getSimpleName(), "onDestroy");
    NowPlayingControllerWrapper.removeActivity(this);
    MovieViewUtilities.cleanUpDrawables();
    super.onDestroy();
  }

  private class MovieAdapter extends BaseAdapter {
    @Override
    public boolean areAllItemsEnabled() {
      return false;
    }

    @Override
    public boolean isEnabled(final int position) {
      return AllMoviesActivity.this.movieDetailEntries.get(position).isSelectable();
    }

    private final LayoutInflater inflater;

    private MovieAdapter() {
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
        final ImageView posterImage = (ImageView) convertView.findViewById(R.id.poster);
        final TextView text1 = (TextView) convertView.findViewById(R.id.value1);
        final TextView text2 = (TextView) convertView.findViewById(R.id.value2);
        final byte[] bytes = NowPlayingControllerWrapper.getPoster(AllMoviesActivity.this.movie);
        if (bytes.length > 0) {
          posterImage.setImageBitmap(BitmapFactory.decodeByteArray(bytes, 0, bytes.length));
          posterImage.setBackgroundResource(R.drawable.image_frame);
        }
        final String synopsis = entry.value;
        if (synopsis.length() > 0) {
          TextPaint paint = text1.getPaint();
          int orientation = getResources().getConfiguration().orientation;
          int textViewWidth;
          if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
            // textViewWidth = screenWidth - posterWidth - paddingLeft -
            // paddingRight - spaceBetweenPosterAndTextView
            textViewWidth = 480 - 126 - 5 - 5 - 5;
          } else {
            textViewWidth = 320 - 126 - 5 - 5 - 5;
          }
          android.text.Layout l = new StaticLayout(synopsis, paint, textViewWidth,
              Layout.Alignment.ALIGN_NORMAL, 1, 0, false);
          // height of poster is 182px
          int line = l.getLineForVertical(182);
          int off = l.getLineStart(line + 1);
          final String desc1_text = synopsis.substring(0, off);
          final String desc2_text = synopsis.substring(off, synopsis.length());
          text1.setText(desc1_text);
          text2.setText(desc2_text);
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

      private MovieViewHolder(final TextView name, final TextView value, final ImageView divider) {
        this.name = name;
        this.value = value;
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

  private static class MovieDetailEntry {
    private final String name;
    private final String value;
    private final MovieDetailItemType type;
    private final Intent intent;
    private final boolean selectable;

    private MovieDetailEntry(final String name, final String value, final MovieDetailItemType type,
        final Intent intent, final boolean selectable) {
      this.name = name;
      this.value = value;
      this.type = type;
      this.intent = intent;
      this.selectable = selectable;
    }

    public boolean isSelectable() {
      return this.selectable;
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(
        R.drawable.ic_menu_home).setIntent(new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class));
    return super.onCreateOptionsMenu(menu);
  }

  private enum MovieDetailItemType {
    POSTER_SYNOPSIS, DATA, ACTION, HEADER
  }

  @Override
  protected void onListItemClick(final ListView listView, final View view, final int position,
      final long id) {
    final Intent intent = this.movieDetailEntries.get(position).intent;
    if (intent != null) {
      startActivity(intent);
    }
    super.onListItemClick(listView, view, position, id);
  }

  @Override
  protected void onResume() {
    super.onResume();
    Log.i(getClass().getSimpleName(), "onResume");
    final Bundle extras = getIntent().getExtras();
    this.movie = extras.getParcelable("movie");
    final Resources res = getResources();
    final TextView title = (TextView) findViewById(R.id.title);
    title.setText(this.movie.getDisplayTitle());
    // Get and set scores text and background image
    final Button scoreImg = (Button) findViewById(R.id.score);
    final TextView scoreLbl = (TextView) findViewById(R.id.scorelbl);
    final Score score = NowPlayingControllerWrapper.getScore(this.movie);
    int scoreValue = -1;
    if (score != null && !StringUtilities.isNullOrEmpty(score.getValue())) {
      scoreValue = Integer.parseInt(score.getValue());
    } else {
    }
    final ScoreType scoreType = NowPlayingControllerWrapper.getScoreType();
    scoreImg.setBackgroundDrawable(MovieViewUtilities.formatScoreDrawable(scoreValue, scoreType,
        res));
    if (scoreValue != -1) {
      scoreLbl.setText(scoreValue + "%");
    }
    if (scoreType != ScoreType.RottenTomatoes) {
      scoreLbl.setTextColor(Color.BLACK);
    }
    final TextView ratingLengthLabel = (TextView) findViewById(R.id.ratingLength);
    final CharSequence rating = MovieViewUtilities.formatRatings(this.movie.getRating(), res);
    final CharSequence length = MovieViewUtilities.formatLength(this.movie.getLength(), res);
    ratingLengthLabel.setText(rating + ". " + length);
    populateMovieDetailEntries();
    final MovieAdapter movieAdapter = new MovieAdapter();
    setListAdapter(movieAdapter);
    final Button showtimes = (Button) findViewById(R.id.showtimes);
    showtimes.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        final Intent intent = new Intent();
        intent.setClass(AllMoviesActivity.this, ShowtimesActivity.class);
        intent.putExtra("movie", (Parcelable) AllMoviesActivity.this.movie);
        startActivity(intent);
      }
    });
  }

  @Override
  protected void onPause() {
    super.onPause();
    Log.i(getClass().getSimpleName(), "onPause");
  }
}
