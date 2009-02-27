package org.metasyntactic.activities;

import android.app.ListActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;

import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Score;
import org.metasyntactic.data.Theater;
import org.metasyntactic.utilities.CollectionUtilities;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;

import java.util.List;

public class ShowtimesActivity extends ListActivity {
  private List<Theater> theaters;
  private Movie movie;

  @Override
  protected void onListItemClick(final ListView listView, final View view, final int position,
      final long id) {
    final Intent intent = new Intent();
    intent.setClass(this, ShowtimesDetailsActivity.class);
    intent.putExtra("movie", (Parcelable) movie);
    intent.putExtra("theater", (Parcelable) theaters.get(position));
    startActivity(intent);
    super.onListItemClick(listView, view, position, id);
  }

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    LogUtilities.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);
    setContentView(R.layout.theaters_movie);
    movie = getIntent().getExtras().getParcelable("movie");
  }

  @Override
  protected void onResume() {
    super.onResume();
    LogUtilities.i(getClass().getSimpleName(), "onResume");
    bindView();
    // populateTheaterDetailItems();
    final ListAdapter theaterAdapter = new TheaterListAdapter();
    setListAdapter(theaterAdapter);
  }

  @Override
  protected void onPause() {
    super.onPause();
    LogUtilities.i(getClass().getSimpleName(), "onPause");
  }

  @Override
  protected void onDestroy() {
    LogUtilities.i(getClass().getSimpleName(), "onDestroy");
    NowPlayingControllerWrapper.removeActivity(this);
    MovieViewUtilities.cleanUpDrawables();
    super.onDestroy();
  }

  @Override
  public Object onRetainNonConfigurationInstance() {
    LogUtilities.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    final Object result = new Object();
    NowPlayingControllerWrapper.onRetainNonConfigurationInstance(this, result);
    return result;
  }

  private void bindView() {
    final TextView title = (TextView) findViewById(R.id.title);
    title.setText(movie.getDisplayTitle());
    // Get and set scores text and background image
    final View scoreImg = (Button) findViewById(R.id.score);
    final TextView scoreLbl = (TextView) findViewById(R.id.scorelbl);
    final Resources res = getResources();
    final Score score = NowPlayingControllerWrapper.getScore(movie);
    int scoreValue = -1;
    if (score != null && score.getValue().length() != 0) {
      scoreValue = Integer.parseInt(score.getValue());
    } else {
    }
    final ScoreType scoreType = NowPlayingControllerWrapper.getScoreType();
    scoreImg.setBackgroundDrawable(MovieViewUtilities.formatScoreDrawable(scoreValue, scoreType,
        res));
    if (scoreValue != -1) {
      scoreLbl.setText(scoreValue + "%");
    }
    final TextView ratingLengthLabel = (TextView) findViewById(R.id.ratingLength);
    final CharSequence rating = MovieViewUtilities.formatRatings(movie.getRating(), res);
    final CharSequence length = MovieViewUtilities.formatLength(movie.getLength(), res);
    ratingLengthLabel.setText(rating + ". " + length);
    theaters = NowPlayingControllerWrapper.getTheatersShowingMovie(movie);
  }

  private class TheaterListAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    private TheaterListAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(ShowtimesActivity.this);
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = inflater.inflate(R.layout.theaterdetails_item, null);
      final TheaterDetailsViewHolder holder = new TheaterDetailsViewHolder((TextView) convertView
          .findViewById(R.id.label), (TextView) convertView.findViewById(R.id.data));
      final Theater theater = theaters.get(position);
      holder.label.setText(theater.getName());
      final List<Performance> list = NowPlayingControllerWrapper.getPerformancesForMovieAtTheater(
          movie, theater);
      if (CollectionUtilities.size(list) > 0) {
        String performance = "";
        for (final Performance per : list) {
          performance += per.getTime() + ", ";
        }
        performance = performance.substring(0, performance.length() - 2);
        if (NowPlayingControllerWrapper.isStale(theater)) {
          LinearLayout l = (LinearLayout) convertView.findViewById(R.id.warning);
          l.setVisibility(View.VISIBLE);
          TextView warningText = (TextView) convertView.findViewById(R.id.warningText);
          warningText.setText(NowPlayingControllerWrapper.getShowtimesRetrievedOnString(theater,
              ShowtimesActivity.this.getResources()));
        }
        holder.data.setText(performance);
      } else {
        holder.data.setText("Unknown.");
      }
      return convertView;
    }

    public int getCount() {
      return theaters.size();
    }

    private class TheaterDetailsViewHolder {
      private final TextView label;
      private final TextView data;

      private TheaterDetailsViewHolder(final TextView label, final TextView data) {
        this.label = label;
        this.data = data;
      }
    }

    public long getEntryId(final int position) {
      return position;
    }

    public Object getItem(final int position) {
      return theaters.get(position);
    }

    public long getItemId(final int position) {
      return position;
    }

    public void refresh() {
      notifyDataSetChanged();
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(
        R.drawable.ic_menu_home).setIntent(new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(
        new Intent(this, SettingsActivity.class).putExtra("from_menu", "yes"));
    return super.onCreateOptionsMenu(menu);
  }
}
