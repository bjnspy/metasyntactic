package org.metasyntactic.activities;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcelable;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

import org.metasyntactic.INowPlaying;
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.UserTask;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.metasyntactic.views.CustomGridView;
import org.metasyntactic.views.FastScrollGridView;
import org.metasyntactic.views.NowPlayingPreferenceDialog;
import org.metasyntactic.views.Rotate3dAnimation;

import java.io.File;
import java.lang.ref.SoftReference;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NowPlayingActivity extends Activity implements INowPlaying {
  private CustomGridView grid;
  private Intent intent;
  private Movie selectedMovie;
  private PostersAdapter postersAdapter;
  private boolean isGridSetup;
  private static List<Movie> movies;
  private int lastPosition;
  private String search;
  private final Map<Integer, Integer> alphaMovieSectionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> alphaMoviePositionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> scoreMovieSectionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> scoreMoviePositionsMap = new HashMap<Integer, Integer>();
  private static final Map<String, SoftReference<Bitmap>> postersMap = new HashMap<String, SoftReference<Bitmap>>();
  private String[] alphabet;
  private String[] score;
  private TextView progressUpdate;
  private RelativeLayout bottomBar;
  /* This task is controlled by the TaskManager based on the scrolling state */
  private UserTask<?, ?, ?> mTask;
  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
      refresh();
    }
  };
  private final BroadcastReceiver progressbroadcastReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
      NowPlayingActivity.this.progressUpdate.setText(intent.getStringExtra("message"));
    }
  };
  private final BroadcastReceiver databroadcastReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
      if (!NowPlayingActivity.this.isGridSetup) {
        setup();
      }
    }
  };
  private final BroadcastReceiver scrollStatebroadcastReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
      if (NowPlayingApplication.NOT_SCROLLING_INTENT.equals(intent.getAction())
          && NowPlayingActivity.this.mTask.getStatus() != UserTask.Status.RUNNING) {
        NowPlayingActivity.this.mTask = NowPlayingActivity.this.new LoadPostersTask().execute(null);
      }
      if (NowPlayingApplication.SCROLLING_INTENT.equals(intent.getAction()) && NowPlayingActivity.this.mTask.getStatus() == UserTask.Status.RUNNING) {
        NowPlayingActivity.this.mTask.cancel(true);
      }
    }
  };

  @Override protected void onResume() {
    super.onResume();
    Log.i(getClass().getSimpleName(), "onResume");
    if (FileUtilities.isSDCardAccessible()) {
      registerReceiver(this.broadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_CHANGED_INTENT));
      registerReceiver(this.databroadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_LOCAL_DATA_DOWNLOADED));
      registerReceiver(this.scrollStatebroadcastReceiver, new IntentFilter(NowPlayingApplication.SCROLLING_INTENT));
      registerReceiver(this.scrollStatebroadcastReceiver, new IntentFilter(NowPlayingApplication.NOT_SCROLLING_INTENT));
      registerReceiver(this.progressbroadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_LOCAL_DATA_DOWNLOAD_PROGRESS));
      if (this.isGridSetup) {
        this.grid.setVisibility(View.VISIBLE);
        this.postersAdapter.refreshMovies();
      }
    }

  }

  @Override protected void onPause() {
    Log.i(getClass().getSimpleName(), "onPause");
    if (FileUtilities.isSDCardAccessible()) {
      unregisterReceiver(this.broadcastReceiver);
      unregisterReceiver(this.databroadcastReceiver);
      unregisterReceiver(this.scrollStatebroadcastReceiver);
      unregisterReceiver(this.progressbroadcastReceiver);
      if (this.mTask != null && this.mTask.getStatus() == UserTask.Status.RUNNING) {
        this.mTask.cancel(true);
      }
    }
    super.onPause();
  }

  @Override protected void onDestroy() {
    Log.i(getClass().getSimpleName(), "onDestroy");
    if (FileUtilities.isSDCardAccessible()) {
      NowPlayingControllerWrapper.removeActivity(this);
      if (this.mTask != null && this.mTask.getStatus() == UserTask.Status.RUNNING) {
        this.mTask.cancel(true);
      }
      clearBitmaps();
    }
    super.onDestroy();
  }

  @Override public Object onRetainNonConfigurationInstance() {
    Log.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    final Object result = this.search;
    NowPlayingControllerWrapper.onRetainNonConfigurationInstance(this, result);
    return result;
  }

  /**
   * Updates display of the list of movies.
   */
  public void refresh() {
    if (this.search == null) {
    }
    if (this.search == null) {
      movies = new ArrayList<Movie>(NowPlayingControllerWrapper.getMovies());
    }
    // sort movies according to the default sort preference.
    final Comparator<Movie> comparator = MOVIE_ORDER.get(NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex());
    Collections.sort(movies, comparator);
    if (this.postersAdapter != null) {
      populateAlphaMovieSectionsAndPositions();
      populateScoreMovieSectionsAndPositions();
      FastScrollGridView.getSections();
      this.postersAdapter.refreshMovies();
    }
    // cancel task so that it doesnt try to load old set of movies
    if (this.mTask != null && this.mTask.getStatus() == UserTask.Status.RUNNING) {
      this.mTask.cancel(true);
    }
    this.mTask = new LoadPostersTask().execute(null);
  }

  private static List<Movie> getMatchingMoviesList(final String search2) {
    final String localSearch = search2.toLowerCase();
    final List<Movie> matchingMovies = new ArrayList<Movie>();
    for (final Movie movie : movies) {
      if (movie.getDisplayTitle().toLowerCase().contains(localSearch)) {
        matchingMovies.add(movie);
      }
    }
    return matchingMovies;
  }

  public Context getContext() {
    return this;
  }

  @Override public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Log.i(getClass().getSimpleName(), "onCreate");
    this.search = (String) getLastNonConfigurationInstance();
    // check for sdcard mounted properly
    if (FileUtilities.isSDCardAccessible()) {
      // Request the progress bar to be shown in the title
      requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
      setContentView(R.layout.progressbar_1);
      this.progressUpdate = (TextView) findViewById(R.id.progress_update);
      NowPlayingControllerWrapper.addActivity(this);
      getUserLocation();
      refresh();
      if (movies != null && !movies.isEmpty()) {
        setup();
        this.isGridSetup = true;
      }
    } else {
      new AlertDialog.Builder(this).setTitle(R.string.insert_sdcard).setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
        public void onClick(final DialogInterface dialog, final int whichButton) {
          NowPlayingActivity.this.finish();
        }
      }).show();
    }
  }

  @Override protected void onNewIntent(final Intent intent) {
    super.onNewIntent(intent);
    this.search = intent.getStringExtra("movie");
    if (this.search != null) {
      this.bottomBar.setVisibility(View.VISIBLE);
    }
    getSearchResults();
    refresh();
  }

  private void getUserLocation() {
    final String userLocation = NowPlayingControllerWrapper.getUserLocation();
    if (StringUtilities.isNullOrEmpty(userLocation)) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, SettingsActivity.class);
      startActivity(localIntent);
    }
  }

  private void getSearchResults() {
    if (this.search != null) {
      final List<Movie> matchingMovies = getMatchingMoviesList(this.search);
      if (matchingMovies.isEmpty()) {
        Toast.makeText(this, getResources().getString(R.string.no_results_found_for) + this.search, Toast.LENGTH_SHORT).show();
      } else {
        movies = matchingMovies;
        // cancel task so that it doesnt try to load the complete set of movies.
        if (this.mTask != null && this.mTask.getStatus() == UserTask.Status.RUNNING) {
          this.mTask.cancel(true);
        }
      }
    }
  }

  private static void clearBitmaps() {
    for (final SoftReference<Bitmap> reference : postersMap.values()) {
      final Bitmap drawable = reference.get();
      if (drawable != null) {
        reference.clear();
      }
    }
  }

  private void getAlphabet(final Context context) {
    final String alphabetString = context.getResources().getString(R.string.alphabet);
    this.alphabet = new String[alphabetString.length()];
    for (int i = 0; i < this.alphabet.length; i++) {
      this.alphabet[i] = String.valueOf(alphabetString.charAt(i));
    }
  }

  private void getScores() {
    this.score = new String[11];
    for (int index = 0, i = 100; i >= 0; index++, i -= 10) {
      this.score[index] = i + "%";
    }
  }

  private void setup() {
    getAlphabet(this);
    getScores();
    setContentView(R.layout.moviegrid_anim);
    this.bottomBar = (RelativeLayout) findViewById(R.id.bottom_bar);
    if (this.search == null) {
      this.bottomBar.setVisibility(View.GONE);
    }
    final Button allMovies = (Button) findViewById(R.id.all_movies);
    allMovies.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        final Intent intent = new Intent();
        intent.setClass(NowPlayingActivity.this, NowPlayingActivity.class);
        NowPlayingActivity.this.startActivity(intent);
      }
    });
    this.grid = (CustomGridView) findViewById(R.id.grid);
    this.grid.setOnItemClickListener(new OnItemClickListener() {
      public void onItemClick(final AdapterView parent, final View view, final int position, final long id) {
        NowPlayingActivity.this.selectedMovie = movies.get(position);
        setupRotationAnimation(view);
      }
    });
    populateAlphaMovieSectionsAndPositions();
    populateScoreMovieSectionsAndPositions();
    this.postersAdapter = new PostersAdapter();
    this.grid.setAdapter(this.postersAdapter);
    this.intent = new Intent();
    this.intent.setClass(this, MovieDetailsActivity.class);
  }

  private void populateAlphaMovieSectionsAndPositions() {
    int i = 0;
    String prevLetter = null;
    final List<String> alphabets = Arrays.asList(this.alphabet);
    for (final Movie movie : movies) {
      final String firstLetter = movie.getDisplayTitle().substring(0, 1);
      this.alphaMovieSectionsMap.put(i, alphabets.indexOf(firstLetter));
      if (!firstLetter.equals(prevLetter)) {
        this.alphaMoviePositionsMap.put(alphabets.indexOf(firstLetter), i);
      }
      prevLetter = firstLetter;
      i++;
    }
    for (i = 0; i < alphabets.size(); i++) {
      if (this.alphaMoviePositionsMap.get(i) == null) {
        if (i == 0) {
          this.alphaMoviePositionsMap.put(i, 0);
        } else {
          this.alphaMoviePositionsMap.put(i, this.alphaMoviePositionsMap.get(i - 1));
        }
      }
    }
  }

  private void populateScoreMovieSectionsAndPositions() {
    int i = 0;
    int prevLevel = 0;
    final List<String> scores = Arrays.asList(this.score);
    for (final Movie movie : movies) {
      final Score localScore = NowPlayingControllerWrapper.getScore(movie);
      final int scoreValue = localScore == null ? 0 : localScore.getScoreValue();
      final int scoreLevel = scoreValue / 10 * 10;
      this.scoreMovieSectionsMap.put(i, scores.indexOf(scoreLevel + "%"));
      if (scoreLevel != prevLevel) {
        this.scoreMoviePositionsMap.put(scores.indexOf(scoreLevel + "%"), i);
      }
      prevLevel = scoreLevel;
      i++;
    }
    for (i = 0; i < scores.size(); i++) {
      if (this.scoreMoviePositionsMap.get(i) == null) {
        if (i == 0) {
          this.scoreMoviePositionsMap.put(i, 0);
        } else {
          this.scoreMoviePositionsMap.put(i, this.scoreMoviePositionsMap.get(i - 1));
        }
      }
    }
  }

  public final static List<Comparator<Movie>> MOVIE_ORDER = Arrays.asList(Movie.TITLE_ORDER, Movie.RELEASE_ORDER, Movie.SCORE_ORDER);

  private class PostersAdapter extends BaseAdapter implements FastScrollGridView.SectionIndexer {
    private final LayoutInflater inflater;

    private PostersAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(NowPlayingActivity.this);
    }

    public View getView(final int position, View convertView, final ViewGroup parent) {
      // to findViewById() on each row.
      final ViewHolder holder;
      // When convertView is not null, we can reuse it directly, there is
      // no need to reinflate it. We only inflate a new View when the
      // convertView
      // supplied by GridView is null.
      if (convertView == null) {
        convertView = this.inflater.inflate(R.layout.moviegrid_item, null);
        // Creates a ViewHolder and store references to the two children
        // views we want to bind data to.
        holder = new ViewHolder((TextView) convertView.findViewById(R.id.title), (ImageView) convertView.findViewById(R.id.poster));
        convertView.setTag(holder);
      } else {
        // Get the ViewHolder back to get fast access to the TextView
        // and the ImageView.
        holder = (ViewHolder) convertView.getTag();
      }
      final Movie movie = movies.get(position % movies.size());
      NowPlayingControllerWrapper.prioritizeMovie(movie);
      holder.title.setText(movie.getDisplayTitle());
      // optimized bitmap cache and bitmap loading
      holder.title.setEllipsize(TextUtils.TruncateAt.END);
      holder.poster.setImageDrawable(getResources().getDrawable(R.drawable.loader2));
      final SoftReference<Bitmap> reference = postersMap.get(movies.get(position).getCanonicalTitle());
      Bitmap bitmap = null;
      if (reference != null) {
        bitmap = reference.get();
      }
      if (bitmap != null) {
        holder.poster.setImageBitmap(bitmap);
      }
      convertView.setBackgroundDrawable(getResources().getDrawable(R.drawable.gallery_background_1));
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
      if (movies != null) {
        return Math.min(100, movies.size());
      } else {
        return 0;
      }
    }

    public final Object getItem(final int position) {
      return movies.get(position % movies.size());
    }

    public final long getItemId(final int position) {
      return position;
    }

    public void refreshMovies() {
      notifyDataSetChanged();
    }

    public int getPositionForSection(final int section) {
      Integer position = null;
      if (NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex() == 0) {
        position = NowPlayingActivity.this.alphaMoviePositionsMap.get(section);
      }
      if (NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex() == 2) {
        position = NowPlayingActivity.this.scoreMoviePositionsMap.get(section);
      }
      if (position != null) {
        NowPlayingActivity.this.lastPosition = position;
      }
      return NowPlayingActivity.this.lastPosition;
    }

    public int getSectionForPosition(final int position) {
      if (NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex() == 0) {
        return NowPlayingActivity.this.alphaMovieSectionsMap.get(position);
      }
      if (NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex() == 2) {
        return NowPlayingActivity.this.scoreMovieSectionsMap.get(position);
      }
      return position;
    }

    public Object[] getSections() {
      // fast scroll is implemented only for alphabetic & score sort for release
      // 1.
      if (NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex() == 0) {
        return NowPlayingActivity.this.alphabet;
      }
      if (NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex() == 2) {
        return NowPlayingActivity.this.score;
      }
      return null;
    }
  }

  @Override public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_SEARCH, 0, R.string.search).setIcon(android.R.drawable.ic_menu_search);
    menu.add(0, MovieViewUtilities.MENU_SORT, 0, R.string.sort_movies).setIcon(R.drawable.ic_menu_switch);
    menu.add(0, MovieViewUtilities.MENU_THEATER, 0, R.string.theaters).setIcon(R.drawable.ic_menu_allfriends);
    menu.add(0, MovieViewUtilities.MENU_UPCOMING, 0, R.string.upcoming).setIcon(R.drawable.upcoming);
    menu.add(0, MovieViewUtilities.MENU_SEND_FEEDBACK, 0, R.string.send_feedback).setIcon(android.R.drawable.ic_menu_send);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(android.R.drawable.ic_menu_preferences).setIntent(
        new Intent(this, SettingsActivity.class)).setAlphabeticShortcut('s');
    return super.onCreateOptionsMenu(menu);
  }

  @Override public boolean onOptionsItemSelected(final MenuItem item) {
    if (item.getItemId() == MovieViewUtilities.MENU_SORT) {
      final NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this).setKey(NowPlayingPreferenceDialog.PreferenceKeys.MOVIES_SORT)
      .setEntries(R.array.entries_movies_sort_preference).setPositiveButton(android.R.string.ok).setNegativeButton(android.R.string.cancel);
      builder.setTitle(R.string.sort_movies);
      builder.show();
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_THEATER) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, AllTheatersActivity.class);
      startActivity(localIntent);
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_UPCOMING) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, UpcomingMoviesActivity.class);
      startActivity(localIntent);
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_SEARCH) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, SearchMovieActivity.class);
      localIntent.putExtra("activity", "NowPlayingActivity");
      startActivity(localIntent);
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_SEND_FEEDBACK) {
      final Resources res = getResources();
      final String addr = "cyrusn@google.com";
      final Intent localIntent = new Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:" + addr));
      localIntent.putExtra("subject", res.getString(R.string.feedback));
      final String body = getUserSettings(res);
      localIntent.putExtra("body", body);
      startActivity(localIntent);
      return true;
    }
    return false;
  }

  private static String getUserSettings(final Resources res) {
    String body = "\n\n\n\n";
    body += res.getString(R.string.settings);
    body += '\n' + res.getString(R.string.autoupdate_location) + ": " + NowPlayingControllerWrapper.isAutoUpdateEnabled();
    body += '\n' + res.getString(R.string.location) + ": " + NowPlayingControllerWrapper.getUserLocation();
    body += '\n' + res.getString(R.string.search_distance) + ": " + NowPlayingControllerWrapper.getSearchDistance();
    body += '\n' + res.getString(R.string.reviews) + ": " + NowPlayingControllerWrapper.getScoreType();
    return body;
  }

  private void setupRotationAnimation(final View view) {
    final float centerX = view.getWidth() / 2.0f;
    final float centerY = view.getHeight() / 2.0f;
    // Create a new 3D rotation with the supplied parameter
    // The animation listener is used to trigger the next animation
    final Rotate3dAnimation rotation = new Rotate3dAnimation(80, 0, centerX, centerY, 0.0f, true);
    rotation.setDuration(20);
    rotation.setFillAfter(true);
    rotation.setAnimationListener(new AnimationListener() {
      public void onAnimationEnd(final Animation animation) {
        NowPlayingActivity.this.intent.putExtra("movie", (Parcelable) NowPlayingActivity.this.selectedMovie);
        startActivity(NowPlayingActivity.this.intent);
      }

      public void onAnimationRepeat(final Animation animation) {
      }

      public void onAnimationStart(final Animation animation) {
      }
    });
    view.startAnimation(rotation);
  }

  private class LoadPostersTask extends UserTask<Void, Void, Void> {
    @Override public Void doInBackground(final Void... params) {
      Bitmap bitmap = null;
      for (final Movie movie : movies) {
        final SoftReference<Bitmap> reference = NowPlayingActivity.postersMap.get(movie.getCanonicalTitle());
        if (reference != null) {
          bitmap = reference.get();
        }
        if (reference == null || bitmap == null) {
          final File file = NowPlayingControllerWrapper.getPosterFile_safeToCallFromBackground(movie);
          if (file != null) {
            final byte[] bytes = FileUtilities.readBytes(file);
            if (bytes != null && bytes.length > 0) {
              bitmap = createBitmap(bytes);
              if (bitmap != null) {
                NowPlayingActivity.postersMap.put(movie.getCanonicalTitle(), new SoftReference<Bitmap>(bitmap));
              }
            }
          }
        }
      }
      return null;
    }

    @Override public void onPostExecute(final Void result) {
      super.onPostExecute(result);
      if (NowPlayingActivity.this.postersAdapter != null) {
        NowPlayingActivity.this.postersAdapter.refreshMovies();
      }
    }
  }

  private static Bitmap createBitmap(final byte[] bytes) {
    try {
      return BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
    } catch (final OutOfMemoryError ignored) {
      return null;
    }
    /*
     * final BitmapFactory.Options options = new BitmapFactory.Options(); final
     * int width = 90; final int height = 125; // Get the dimensions only.
     * options.inJustDecodeBounds = true; BitmapFactory.decodeByteArray(bytes,
     * 0, bytes.length, options); final int bitmapWidth = options.outWidth;
     * final int bitmapHeight = options.outHeight; final float scale =
     * Math.min((float) bitmapWidth / (float) width, (float) bitmapHeight /
     * (float) height) 2; options.inJustDecodeBounds = false;
     * options.inPreferredConfig = Bitmap.Config.ARGB_8888; options.inSampleSize
     * = (int) scale; final Bitmap bitmap = BitmapFactory.decodeByteArray(bytes,
     * 0, bytes.length, options); return bitmap;
     */
  }
}
