package org.metasyntactic;

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
import android.widget.ListView;
import android.widget.TextView;
import android.util.Log;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Score;
import org.metasyntactic.data.Theater;
import org.metasyntactic.utilities.CollectionUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;

import java.util.List;

public class ShowtimesActivity extends ListActivity {
  private List<Theater> theaters;
  private Movie movie;

  private enum TheaterDetailItemType {
    NAME_SHOWTIMES, ADDRESS, PHONE
  }

  @Override
  protected void onListItemClick(final ListView listView, final View view, final int position, final long id) {
    final Intent intent = new Intent();
    intent.setClass(this, ShowtimesDetailsActivity.class);
    intent.putExtra("movie", (Parcelable) this.movie);
    intent.putExtra("theater", (Parcelable) this.theaters.get(position));
    startActivity(intent);
    super.onListItemClick(listView, view, position, id);
  }

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Log.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);

    setContentView(R.layout.theaters_movie);
    this.movie = getIntent().getExtras().getParcelable("movie");
  }

  @Override
  protected void onDestroy() {
    Log.i(getClass().getSimpleName(), "onDestroy");
   
    NowPlayingControllerWrapper.removeActivity(this);
    MovieViewUtilities.cleanUpDrawables();
    super.onDestroy();
  }

  private void bindView() {
    final TextView title = (TextView) findViewById(R.id.title);
    title.setText(this.movie.getDisplayTitle());
    // Get and set scores text and background image
    final Button scoreImg = (Button) findViewById(R.id.score);
    final TextView scoreLbl = (TextView) findViewById(R.id.scorelbl);
    final Resources res = getResources();
    final Score score = NowPlayingControllerWrapper.getScore(this.movie);
    int scoreValue = -1;
    if (score != null && score.getValue().length() != 0) {
      scoreValue = Integer.parseInt(score.getValue());
    } else {
    }
    final ScoreType scoreType = NowPlayingControllerWrapper.getScoreType();
    scoreImg.setBackgroundDrawable(MovieViewUtilities.formatScoreDrawable(scoreValue, scoreType, res));
    if (scoreValue != -1) {
      scoreLbl.setText(scoreValue + "%");
    }
    final TextView ratingLengthLabel = (TextView) findViewById(R.id.ratingLength);
    final CharSequence rating = MovieViewUtilities.formatRatings(this.movie.getRating(), res);
    final CharSequence length = MovieViewUtilities.formatLength(this.movie.getLength(), res);
    ratingLengthLabel.setText(rating + ". " + length);
    this.theaters = NowPlayingControllerWrapper.getTheatersShowingMovie(this.movie);
  }

  @Override
  protected void onResume() {
    super.onResume();
    Log.i(getClass().getSimpleName(), "onResume");

    bindView();
    // populateTheaterDetailItems();
    final TheaterListAdapter theaterAdapter = new TheaterListAdapter();
    setListAdapter(theaterAdapter);
  }

  @Override protected void onPause() {
    super.onPause();
    Log.i(getClass().getSimpleName(), "onPause");
  }

  private class TheaterListAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    private TheaterListAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(ShowtimesActivity.this);
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = this.inflater.inflate(R.layout.theaterdetails_item, null);
      final TheaterDetailsViewHolder holder = new TheaterDetailsViewHolder(
          (TextView) convertView.findViewById(R.id.label), (TextView) convertView.findViewById(R.id.data));
      final Theater theater = ShowtimesActivity.this.theaters.get(position);
      holder.label.setText(theater.getName());
      final List<Performance> list = NowPlayingControllerWrapper.getPerformancesForMovieAtTheater(
          ShowtimesActivity.this.movie, theater);
      if (CollectionUtilities.size(list) > 0) {
        String performance = "";
        for (final Performance per : list) {
          performance += per.getTime() + ", ";
        }
        performance = performance.substring(0, performance.length() - 2);
        holder.data.setText(performance);
      } else {
        holder.data.setText("Unknown.");
      }
      return convertView;
    }

    public int getCount() {
      return ShowtimesActivity.this.theaters.size();
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
      return ShowtimesActivity.this.theaters.get(position);
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
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(R.drawable.ic_menu_home).setIntent(
        new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class));
    return super.onCreateOptionsMenu(menu);
  }
}
