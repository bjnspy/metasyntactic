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

  enum TheaterDetailItemType {
    NAME_SHOWTIMES, ADDRESS, PHONE
  }

  @Override
  protected void onListItemClick(final ListView l, final View v, final int position, final long id) {
    final Intent intent = new Intent();
    intent.setClass(ShowtimesActivity.this, ShowtimesDetailsActivity.class);
    intent.putExtra("movie", (Parcelable) movie);
    intent.putExtra("theater", (Parcelable) theaters.get(position));
    startActivity(intent);
    super.onListItemClick(l, v, position, id);
  }

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.addActivity(this);
    setContentView(R.layout.theaters_movie);
    this.movie = getIntent().getExtras().getParcelable("movie");
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  private void bindView() {
    TextView title = (TextView) findViewById(R.id.title);
    title.setText(movie.getDisplayTitle());
    // Get and set scores text and background image
    Button scoreImg = (Button) findViewById(R.id.score);
    TextView scoreLbl = (TextView) findViewById(R.id.scorelbl);
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
    this.theaters = NowPlayingControllerWrapper.getTheatersShowingMovie(this.movie);
  }

  @Override
  protected void onResume() {
    super.onResume();
    bindView();
    // populateTheaterDetailItems();
    final TheaterListAdapter theaterAdapter = new TheaterListAdapter();
    setListAdapter(theaterAdapter);
  }

  private class TheaterListAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public TheaterListAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(ShowtimesActivity.this);
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = this.inflater.inflate(R.layout.theaterdetails_item, null);
      final TheaterDetailsViewHolder holder = new TheaterDetailsViewHolder((TextView) convertView
          .findViewById(R.id.label), (TextView) convertView.findViewById(R.id.data));
      final Theater theater = ShowtimesActivity.this.theaters.get(position);
      holder.label.setText(theater.getName());
      final List<Performance> list = NowPlayingControllerWrapper.getPerformancesForMovieAtTheater(
          ShowtimesActivity.this.movie, theater);
      String performance = "";
      if (CollectionUtilities.size(list) > 0) {
        for (final Performance per : list) {
          performance += per.getTimeString() + ", ";
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

  private class TheaterDetailItem {
    private TheaterDetailItemType type;
    private Intent intent;

    public Intent getIntent() {
      return this.intent;
    }

    public void setIntent(final Intent intent) {
      this.intent = intent;
    }

    public TheaterDetailItemType getType() {
      return this.type;
    }

    public void setType(final TheaterDetailItemType type) {
      this.type = type;
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
}
