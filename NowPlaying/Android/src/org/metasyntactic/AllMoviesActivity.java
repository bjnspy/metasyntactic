package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.*;
import android.widget.BaseAdapter;
import android.widget.TextView;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.ArrayList;
import java.util.List;

/** @author mjoshi@google.com (Megha Joshi) */
public class AllMoviesActivity extends ListActivity {
  private NowPlayingActivity activity;
  private List<Movie> movies = new ArrayList<Movie>();
  private static MoviesAdapter mAdapter;
  private static Context mContext;

  public static final int MENU_SORT = 1;
  public static final int MENU_SETTINGS = 2;


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    // TODO Auto-generated method stub
    super.onCreate(savedInstanceState);
    activity = (NowPlayingActivity) getParent();
    mContext = this;

    // Set up Movies adapter
    mAdapter = new MoviesAdapter(this);
    setListAdapter(mAdapter);
  }


  @Override
  public boolean onCreateOptionsMenu(Menu menu) {

    menu.add(0, MENU_SORT, 0, R.string.menu_movie_sort)
        .setIcon(android.R.drawable.star_on);

    menu.add(0, MENU_SETTINGS, 0, R.string.menu_settings)
        .setIcon(android.R.drawable.ic_menu_preferences)
        .setIntent(new Intent(this, SettingsActivity.class))
        .setAlphabeticShortcut('s');

    return super.onCreateOptionsMenu(menu);
  }


  public NowPlayingActivity getNowPlayingActivityContext() {
    return activity;
  }


  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    if (item.getItemId() == MENU_SORT) {
      NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this.activity)

          .setTitle(R.string.movies_select_sort_title)
          .setKey(NowPlayingPreferenceDialog.Preference_keys.MOVIES_SORT)
          .setEntries(R.array.entries_movies_sort_preference)
          .show();

      return true;
    }
    return false;
  }


  class MoviesAdapter extends BaseAdapter {
    private Context mContext;

    private LayoutInflater mInflater;


    public MoviesAdapter(Context context) {
      mContext = context;
      // Cache the LayoutInflate to avoid asking for a new one each time.
      mInflater = LayoutInflater.from(context);

    }


    public Object getItem(int i) {
      return i;
    }


    public long getItemId(int i) {
      return i;
    }


    public View getView(int position, View convertView, ViewGroup viewGroup) {
      MovieViewHolder holder;
      if (convertView == null) {
        convertView = mInflater.inflate(R.layout.movieview, null);
        // Creates a MovieViewHolder and store references to the
        // children
        // views we want to bind data to.
        holder = new MovieViewHolder();
        holder.score = (TextView) convertView.findViewById(R.id.score);
        holder.title = (TextView) convertView.findViewById(R.id.title);
        holder.rating =
            (TextView) convertView.findViewById(R.id.rating);
        holder.length =
            (TextView) convertView.findViewById(R.id.length);
        convertView.setTag(holder);
      } else {
        // Get the MovieViewHolder back to get fast access to the child
        // views
        holder = (MovieViewHolder) convertView.getTag();
      }
      // Bind the data efficiently with the holder.
      Resources res = mContext.getResources();
      Movie movie = movies.get(position);
      holder.title.setText(movie.getDisplayTitle());
      holder.rating.setText(MovieViewUtilities.formatRatings(movie
          .getRating(), res));
      holder.length.setText(MovieViewUtilities.formatLength(movie
          .getLength(), res));

      // Get and set scores text and background image
      Score score = ((NowPlayingActivity) activity).getController().getScore(movie);
      int scoreValue = -1;
      if (score != null) {
        scoreValue = Integer.parseInt(score.getValue());

      } else {

      }
      ScoreType scoreType = ((NowPlayingActivity) activity).getController().getScoreType();

      holder.score.setBackgroundDrawable(MovieViewUtilities
          .formatScoreDrawable(scoreValue, scoreType, res));
      holder.score.setText(String.valueOf(scoreValue));
      return convertView;
    }


    class MovieViewHolder {
      TextView score;
      TextView title;
      TextView rating;
      TextView length;
    }


    public int getCount() {
      return movies.size();
    }


    public void refreshMovies(List<Movie> new_movies) {
      movies = new_movies;
      notifyDataSetChanged();
    }
  }


  public static void refresh(List<Movie> movies) {

    mAdapter.refreshMovies(movies);
  }
}
