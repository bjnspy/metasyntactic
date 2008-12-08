package org.metasyntactic;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.os.Parcelable;
import android.text.TextUtils;
import android.util.Log;
import android.view.*;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.widget.*;
import android.widget.AdapterView.OnItemClickListener;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.*;

public class NowPlayingActivity extends Activity implements INowPlaying {
  private GridView grid;
  private Intent intent;
  private Animation animation;
  private Movie selectedMovie;
  private PostersAdapter postersAdapter;
  private boolean gridAnimationEnded;
  private boolean isGridSetup;
  private List<Movie> movies;
  private boolean activityAdded;
  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(final Context context, final Intent intent) {
      //  refresh();
    }
  };

  /** Updates display of the list of movies. */
  public void refresh() {
    this.movies = NowPlayingControllerWrapper.getMovies();
    // sort movies according to the default sort preference.
    final Comparator<Movie> comparator = MOVIE_ORDER.get(NowPlayingControllerWrapper
        .getAllMoviesSelectedSortIndex());
    Collections.sort(this.movies, comparator);
    if (this.movies.size() > 0 && !this.isGridSetup) {
      setup();
      // set isGridSetup, so that grid is not recreated on every refresh.
      this.isGridSetup = true;
    }
    if (this.postersAdapter != null && this.gridAnimationEnded) {
      this.postersAdapter.refreshMovies();
    }
  }

  public List<Movie> getMovies() {
    return this.movies;
  }

  public Context getContext() {
    return this;
  }

  /** Called when the activity is first created. */
  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Log.i(getClass().getSimpleName(), "onCreate");
    // Request the progress bar to be shown in the title
    requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
    setContentView(R.layout.progressbar_1);
  }

  @Override
  protected void onDestroy() {
    Log.i(getClass().getSimpleName(), "onDestroy");
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override
  protected void onPause() {
    Log.i(getClass().getSimpleName(), "onPause");
    unregisterReceiver(this.broadcastReceiver);
    super.onPause();
  }

  @Override
  protected void onResume() {
    super.onResume();
    Log.i(getClass().getSimpleName(), "onResume");
    registerReceiver(this.broadcastReceiver, new IntentFilter(Application.NOW_PLAYING_CHANGED_INTENT));
    if (this.isGridSetup) {
      NowPlayingActivity.this.grid.setVisibility(View.VISIBLE);
    }
    // Hack to show the progress dialog with a immediate return from onResume,
    // and then continue the work on main UI thread after the ProgressDialog is
    // visible. Normally, when we are doing work on background thread we wont need this
    // hack to show ProgressDialog.
    final Runnable action = new Runnable() {
      public void run() {
        // For the first Activity, we add activity in onResume (which is
        // different from rest of the Activities in this application).
        // This is to show progress dialog with a quick return from onCreate(),
        // onResume(). If we don't do this we would
        // see a black screen for 1-2 seconds until controller methods complete
        // executing.
        if (!NowPlayingActivity.this.activityAdded) {
          NowPlayingControllerWrapper.addActivity(NowPlayingActivity.this);
          NowPlayingActivity.this.activityAdded = true;
          refresh();
        }
        final String userLocation = NowPlayingControllerWrapper.getUserLocation();
        if (StringUtilities.isNullOrEmpty(userLocation)) {
          final Intent intent = new Intent();
          intent.setClass(NowPlayingActivity.this, SettingsActivity.class);
          startActivity(intent);
        }
      }
    };
    final Handler handler = new Handler();
    if (!this.activityAdded) {
      handler.postDelayed(action, 1000);
    } else {
      handler.post(action);
    }
  }

  private void setup() {
    setContentView(R.layout.moviegrid_anim);
    this.grid = (GridView) findViewById(R.id.grid);
    final int maxpagecount = (this.movies.size() - 1) / 9;
    this.grid.setOnItemClickListener(new OnItemClickListener() {
      public void onItemClick(final AdapterView parent, final View v, final int position, final long id) {
        // TODO Auto-generated method stub
        Log.i("test", "item selected");
        NowPlayingActivity.this.selectedMovie = NowPlayingActivity.this.movies.get(position);
        int i = 0;
        View child = NowPlayingActivity.this.grid.getChildAt(i);
        while (child != null && child.getVisibility() == View.VISIBLE) {
          child.startAnimation(NowPlayingActivity.this.animation);
          i++;
          child = NowPlayingActivity.this.grid.getChildAt(i);
        }
      }
    });
    this.grid.setLayoutAnimationListener(new AnimationListener() {
      public void onAnimationEnd(final Animation animation) {
        NowPlayingActivity.this.gridAnimationEnded = true;
      }

      public void onAnimationRepeat(final Animation animation) {
      }

      public void onAnimationStart(final Animation arg0) {
      }
    });
    this.postersAdapter = new PostersAdapter();
    this.grid.setAdapter(this.postersAdapter);
    this.intent = new Intent();
    this.intent.setClass(NowPlayingActivity.this, AllMoviesActivity.class);
    this.animation = AnimationUtils.loadAnimation(NowPlayingActivity.this, R.anim.fade_reverse);
    this.animation.setAnimationListener(new AnimationListener() {
      public void onAnimationEnd(final Animation animation) {
        NowPlayingActivity.this.grid.setVisibility(View.GONE);
        NowPlayingActivity.this.intent.putExtra("movie",
            (Parcelable) NowPlayingActivity.this.selectedMovie);
        startActivity(NowPlayingActivity.this.intent);
      }

      public void onAnimationRepeat(final Animation animation) {
      }

      public void onAnimationStart(final Animation animation) {
      }
    });
  }

  private final static Comparator<Movie> TITLE_ORDER = new Comparator<Movie>() {
    public int compare(final Movie m1, final Movie m2) {
      return m1.getDisplayTitle().compareTo(m2.getDisplayTitle());
    }
  };
  private final static Comparator<Movie> RELEASE_ORDER = new Comparator<Movie>() {
    public int compare(final Movie m1, final Movie m2) {
      final Calendar c1 = Calendar.getInstance();
      c1.set(1900, 11, 11);
      Date d1 = c1.getTime();
      Date d2 = c1.getTime();
      if (m1.getReleaseDate() != null) {
        d1 = m1.getReleaseDate();
      }
      if (m2.getReleaseDate() != null) {
        d2 = m2.getReleaseDate();
      }
      return d2.compareTo(d1);
    }
  };
  private final static Comparator<Movie> SCORE_ORDER = new Comparator<Movie>() {
    public int compare(final Movie m1, final Movie m2) {
      int value1 = 0;
      int value2 = 0;
      final Score s1 = NowPlayingControllerWrapper.getScore(m1);
      final Score s2 = NowPlayingControllerWrapper.getScore(m2);
      if (s1 != null) {
        value1 = s1.getScoreValue();
      }
      if (s2 != null) {
        value2 = s2.getScoreValue();
      }
      if (value1 == value2) {
        return m1.getDisplayTitle().compareTo(m2.getDisplayTitle());
      } else {
        return value2 - value1;
      }
    }
  };
  public final static List<Comparator<Movie>> MOVIE_ORDER = Arrays.asList(TITLE_ORDER,
      RELEASE_ORDER, SCORE_ORDER);

  private class PostersAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public PostersAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(NowPlayingActivity.this);
    }

    public View getView(final int position, View convertView, final ViewGroup parent) {
      // to findViewById() on each row.
      final ViewHolder holder;
      final int pagecount = position / 9;
      Log.i("getView", String.valueOf(pagecount));
      // When convertView is not null, we can reuse it directly, there is
      // no need to reinflate it. We only inflate a new View when the
      // convertView
      // supplied by ListView is null.
      if (convertView == null) {
        convertView = this.inflater.inflate(R.layout.moviegrid_item, null);
        // Creates a ViewHolder and store references to the two children
        // views we want to bind data to.
        holder = new ViewHolder((TextView) convertView.findViewById(R.id.title),
            (ImageView) convertView.findViewById(R.id.poster));
        convertView.setTag(holder);
      } else {
        // Get the ViewHolder back to get fast access to the TextView
        // and the ImageView.
        holder = (ViewHolder) convertView.getTag();
      }
      final Movie movie = NowPlayingActivity.this.movies.get(position
          % NowPlayingActivity.this.movies.size());
      NowPlayingControllerWrapper.prioritizeMovie(movie);
      holder.title.setText(movie.getDisplayTitle());
      holder.title.setEllipsize(TextUtils.TruncateAt.END);
      Log.i("NowPlayingActivity getview", "trying to show posters");
      final byte[] bytes = NowPlayingControllerWrapper.getPoster(movie);
      if (bytes.length > 0) {
        final Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
        holder.poster.setImageBitmap(bitmap);
      } else {
        holder.poster.setImageDrawable(getResources().getDrawable(R.drawable.loading));
      }
      /* convertView.setOnLongClickListener(new OnLongClickListener() {
         public boolean onLongClick(final View v) {
           NowPlayingActivity.this.selectedMovie = movies.get(position);
           int i = 0;
           View child = NowPlayingActivity.this.grid.getChildAt(i);
           while (child != null && child.getVisibility() == View.VISIBLE) {
             child.startAnimation(NowPlayingActivity.this.animation);
             i++;
             child = NowPlayingActivity.this.grid.getChildAt(i);
           }
           return false;
         }
       });*/
      convertView
          .setBackgroundDrawable(getResources().getDrawable(R.drawable.gallery_background_1));
      return convertView;
    }

    private class ViewHolder {
      private final TextView title;
      private final ImageView poster;

      private ViewHolder(final TextView title, final ImageView poster) {
        this.title = title;
        this.poster = poster;
      }
    }

    public final int getCount() {
      if (NowPlayingActivity.this.movies != null) {
        return Math.min(100, NowPlayingActivity.this.movies.size());
      } else {
        return 0;
      }
    }

    public final Object getItem(final int position) {
      return NowPlayingActivity.this.movies.get(position % NowPlayingActivity.this.movies.size());
    }

    public final long getItemId(final int position) {
      return position;
    }

    public void refreshMovies() {
      // if(gridAnimationEnded)
      notifyDataSetChanged();
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_SORT, 0, R.string.menu_movie_sort).setIcon(
        android.R.drawable.star_on);
    menu.add(0, MovieViewUtilities.MENU_THEATER, 0, R.string.menu_theater).setIcon(
        R.drawable.theatres);
    menu.add(0, MovieViewUtilities.MENU_UPCOMING, 0, R.string.menu_upcoming).setIcon(
        R.drawable.upcoming);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.menu_settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class))
        .setAlphabeticShortcut('s');
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {
    if (item.getItemId() == MovieViewUtilities.MENU_SORT) {
      final NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(
          NowPlayingActivity.this).setTitle(R.string.movies_select_sort_title).setKey(
          NowPlayingPreferenceDialog.PreferenceKeys.MOVIES_SORT).setEntries(
          R.array.entries_movies_sort_preference).setPositiveButton(android.R.string.ok)
          .setNegativeButton(android.R.string.cancel);
      builder.show();
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_THEATER) {
      final Intent intent = new Intent();
      intent.setClass(NowPlayingActivity.this, AllTheatersActivity.class);
      startActivity(intent);
      return true;
    }
    return false;
  }
}
