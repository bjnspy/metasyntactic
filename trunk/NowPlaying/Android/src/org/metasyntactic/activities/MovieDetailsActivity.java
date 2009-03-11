package org.metasyntactic.activities;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.utilities.StringUtilities;

import android.app.ListActivity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
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
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class MovieDetailsActivity extends ListActivity {
  /**
   * Called when the activity is first created.
   */
  private List<MovieDetailEntry> movieDetailEntries = new ArrayList<MovieDetailEntry>();
  private Movie movie;
  private MovieAdapter movieAdapter;

  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
      movieAdapter.notifyDataSetChanged();
    }
  };

  @Override public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    LogUtilities.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);
    setContentView(R.layout.moviedetails);
    final Bundle extras = getIntent().getExtras();
    movie = extras.getParcelable("movie");
    NowPlayingControllerWrapper.prioritizeMovie(movie);
    final Resources res = getResources();
    final TextView title = (TextView)findViewById(R.id.title);
    title.setText(movie.getDisplayTitle());
    // Get and set scores text and background image
    final View scoreImg = findViewById(R.id.score);
    final TextView scoreLbl = (TextView)findViewById(R.id.scorelbl);
    final Score score = NowPlayingControllerWrapper.getScore(movie);
    int scoreValue = -1;
    if (score != null && !StringUtilities.isNullOrEmpty(score.getValue())) {
      scoreValue = Integer.parseInt(score.getValue());
    }

    final ScoreType scoreType = NowPlayingControllerWrapper.getScoreType();
    scoreImg.setBackgroundDrawable(MovieViewUtilities.formatScoreDrawable(scoreValue, scoreType, res));
    if (scoreValue != -1) {
      scoreLbl.setText(scoreValue + "%");
    }
    if (scoreType != ScoreType.RottenTomatoes) {
      scoreLbl.setTextColor(Color.BLACK);
    }
    final TextView ratingLengthLabel = (TextView)findViewById(R.id.ratingLength);
    final CharSequence rating = MovieViewUtilities.formatRatings(movie.getRating(), res);
    final CharSequence length = MovieViewUtilities.formatLength(movie.getLength(), res);
    ratingLengthLabel.setText(rating + ". " + length);
    populateMovieDetailEntries();
    movieAdapter = new MovieAdapter();
    setListAdapter(movieAdapter);
    final View showtimes = findViewById(R.id.showtimes);
    showtimes.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        final Intent intent = new Intent();
        intent.setClass(MovieDetailsActivity.this, ShowtimesActivity.class);
        intent.putExtra("movie", (Parcelable)movie);
        startActivity(intent);
      }
    });
  }

  @SuppressWarnings("unchecked") @Override public List<MovieDetailEntry> getLastNonConfigurationInstance() {
    return (List<MovieDetailEntry>)super.getLastNonConfigurationInstance();
  }

  private void populateMovieDetailEntries() {
    movieDetailEntries = getLastNonConfigurationInstance();
    if (movieDetailEntries == null || movieDetailEntries.isEmpty()) {
      movieDetailEntries = new ArrayList<MovieDetailEntry>();
      final Resources res = getResources();
      // Add title and Synopsis
      {
        final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.synopsis), null, MovieDetailItemType.Synopsis, null, false);
        movieDetailEntries.add(entry);
      }
      // Add release Date
      final Date releaseDate = movie.getReleaseDate();
      if (releaseDate != null) {
        final String releaseDateString = DateFormat.getDateInstance(DateFormat.LONG).format(releaseDate);
        final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.release_date_colon), releaseDateString, MovieDetailItemType.Data,
            null, false);
        movieDetailEntries.add(entry);
      }
      {
        // Add cast
        final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.cast_colon),
            MovieViewUtilities.formatListToString(movie.getCast()), MovieDetailItemType.Data, null, false);
        movieDetailEntries.add(entry);
      }
      // Add director
      final List<String> directors = movie.getDirectors();
      if (directors != null && !directors.isEmpty()) {
        final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.director_colon), MovieViewUtilities.formatListToString(directors),
            MovieDetailItemType.Data, null, false);
        movieDetailEntries.add(entry);
      }
      {
        // Add header
        final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.more_options), null, MovieDetailItemType.Header, null, false);
        movieDetailEntries.add(entry);
      }
      // Add trailer
      final String trailer_url = NowPlayingControllerWrapper.getTrailer(movie);
      if (!StringUtilities.isNullOrEmpty(trailer_url) && trailer_url.startsWith("http")) {
        final Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setDataAndType(Uri.parse(trailer_url), "video/*");
        final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.play_trailer), null, MovieDetailItemType.Action, intent, true);
        movieDetailEntries.add(entry);
      }
      // Add reviews
      final List<Review> reviews = NowPlayingControllerWrapper.getReviews(movie);
      final ArrayList<Review> arrayReviews = new ArrayList<Review>(reviews);
      if (!reviews.isEmpty()) {
        final Intent intent = new Intent();
        intent.putParcelableArrayListExtra("reviews", arrayReviews);
        intent.setClass(this, AllReviewsActivity.class);
        final MovieDetailEntry entry = new MovieDetailEntry(res.getString(R.string.read_reviews), null, MovieDetailItemType.Action, intent, true);
        movieDetailEntries.add(entry);
      }
      // Add website links
      final Map<String,String> nameToUrl = new LinkedHashMap<String, String>();
      nameToUrl.put("IMDb", NowPlayingControllerWrapper.getIMDbAddress(movie));
      nameToUrl.put("Wikipedia", NowPlayingControllerWrapper.getWikipediaAddress(movie));
      nameToUrl.put("Amazon", NowPlayingControllerWrapper.getAmazonAddress(movie));

      for (final Map.Entry<String,String> entry : nameToUrl.entrySet()) {
        final String url = entry.getValue();
        final String name = entry.getKey();
        if (!StringUtilities.isNullOrEmpty(url) && url.startsWith("http")) {
          final Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(url));
          final MovieDetailEntry movieDetails = new MovieDetailEntry(name, null, MovieDetailItemType.Action, intent, true);
          movieDetailEntries.add(movieDetails);
        }
      }
    }
  }

  @Override protected void onResume() {
    super.onResume();
    LogUtilities.i(getClass().getSimpleName(), "onResume");

    registerReceiver(broadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_CHANGED_INTENT));
  }

  @Override protected void onPause() {
    LogUtilities.i(getClass().getSimpleName(), "onPause");
    unregisterReceiver(broadcastReceiver);

    super.onPause();
  }

  @Override protected void onDestroy() {
    LogUtilities.i(getClass().getSimpleName(), "onDestroy");
    NowPlayingControllerWrapper.removeActivity(this);
    MovieViewUtilities.cleanUpDrawables();
    super.onDestroy();
  }

  @Override public Object onRetainNonConfigurationInstance() {
    LogUtilities.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    final Object result = movieDetailEntries;
    NowPlayingControllerWrapper.onRetainNonConfigurationInstance(this, result);
    return result;
  }

  private class MovieAdapter extends BaseAdapter {
    @Override public boolean areAllItemsEnabled() {
      return false;
    }

    @Override public boolean isEnabled(final int position) {
      return movieDetailEntries.get(position).isSelectable();
    }

    private final LayoutInflater inflater;

    private MovieAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(MovieDetailsActivity.this);
    }

    public Object getEntry(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      final MovieDetailEntry entry = movieDetailEntries.get(position);
      switch (entry.type) {
      case Synopsis:
        convertView = setupPosterAndSynopsisView();
        break;
      case Data:
        convertView = inflater.inflate(R.layout.moviedetails_item, null);
        // Creates a MovieViewHolder and store references to the
        // children views we want to bind data to.
        final MovieViewHolder holder = new MovieViewHolder((TextView)convertView.findViewById(R.id.name),
            (TextView)convertView.findViewById(R.id.value));
        holder.name.setText(entry.name);
        holder.value.setText(entry.value);
        break;
      case Header:
        convertView = inflater.inflate(R.layout.headerview, null);
        final TextView headerView = (TextView)convertView.findViewById(R.id.name);
        headerView.setText(entry.name);
        break;
      case Action:
        convertView = inflater.inflate(R.layout.dataview, null);
        final TextView actionView = (TextView)convertView.findViewById(R.id.name);
        actionView.setText(entry.name);
        break;
      }
      return convertView;
    }

    private View setupPosterAndSynopsisView() {
      final View convertView = inflater.inflate(R.layout.moviepostersynopsis, null);
      final ImageView posterImage = (ImageView)convertView.findViewById(R.id.poster);
      final TextView text1 = (TextView)convertView.findViewById(R.id.value1);
      final TextView text2 = (TextView)convertView.findViewById(R.id.value2);
      final byte[] bytes = NowPlayingControllerWrapper.getPoster(movie);
      if (bytes.length > 0) {
        posterImage.setImageBitmap(BitmapFactory.decodeByteArray(bytes, 0, bytes.length));
        posterImage.setBackgroundResource(R.drawable.image_frame);
      }

      String synopsis = NowPlayingControllerWrapper.getSynopsis(movie);
      if (StringUtilities.isNullOrEmpty(synopsis)) {
        synopsis = getResources().getString(R.string.no_synopsis_available_dot);
      }

      final TextPaint paint = text1.getPaint();
      final int orientation = getResources().getConfiguration().orientation;
      final int textViewWidth;
      if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
        // textViewWidth = screenWidth - posterWidth - paddingLeft -
        // paddingRight - spaceBetweenPosterAndTextView
        textViewWidth = 480 - 126 - 5 - 5 - 5;
      } else {
        textViewWidth = 320 - 126 - 5 - 5 - 5;
      }
      final Layout layout = new StaticLayout(synopsis, paint, textViewWidth, Layout.Alignment.ALIGN_NORMAL, 1, 0, false);
      // height of poster is 182px
      final int line = layout.getLineForVertical(182);
      final int off = layout.getLineStart(line + 1);
      final String desc1_text = synopsis.substring(0, off);
      final String desc2_text = synopsis.substring(off, synopsis.length());
      text1.setText(desc1_text);
      text2.setText(desc2_text);

      return convertView;
    }

    public int getCount() {
      return movieDetailEntries.size();
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
      return movieDetailEntries.get(position);
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

    private MovieDetailEntry(final String name, final String value, final MovieDetailItemType type, final Intent intent, final boolean selectable) {
      this.name = name;
      this.value = value;
      this.type = type;
      this.intent = intent;
      this.selectable = selectable;
    }

    public boolean isSelectable() {
      return selectable;
    }
  }

  @Override public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(R.drawable.ic_menu_home)
    .setIntent(new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(android.R.drawable.ic_menu_preferences)
    .setIntent(new Intent(this, SettingsActivity.class).putExtra("from_menu", "yes"));
    return super.onCreateOptionsMenu(menu);
  }

  private enum MovieDetailItemType {
    Synopsis, Data, Action, Header
  }

  @Override protected void onListItemClick(final ListView listView, final View view, final int position, final long id) {
    final Intent intent = movieDetailEntries.get(position).intent;
    if (intent != null) {
      startActivity(intent);
    }
    super.onListItemClick(listView, view, position, id);
  }
}
