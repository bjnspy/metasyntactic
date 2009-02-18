package org.metasyntactic.activities;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.*;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Environment;
import android.os.Parcelable;
import android.text.TextUtils;
import android.util.Log;
import android.view.*;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.widget.*;
import android.widget.AdapterView.OnItemClickListener;
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.INowPlaying;
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
import java.util.*;

public class UpcomingMoviesActivity extends Activity implements INowPlaying {
  private CustomGridView grid;
  private Intent intent;
  private Movie selectedMovie;
  private PostersAdapter postersAdapter;
  private boolean isGridSetup;
  private List<Movie> movies;
  private int lastPosition;
  private String search;
  private final Map<Integer, Integer> alphaMovieSectionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> alphaMoviePositionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> scoreMovieSectionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> scoreMoviePositionsMap = new HashMap<Integer, Integer>();
  private static final Map<String, SoftReference<Bitmap>> postersMap = new HashMap<String, SoftReference<Bitmap>>();
  private String[] alphabet;
  private String[] score;
  private RelativeLayout bottomBar;
  /* This task is controlled by the TaskManager based on the scrolling state */
  private UserTask<?, ?, ?> mTask;
  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(final Context context, final Intent intent) {
      refresh();
    }
  };
  private final BroadcastReceiver scrollStatebroadcastReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
      if (NowPlayingApplication.NOT_SCROLLING_INTENT.equals(
          intent.getAction()) && UpcomingMoviesActivity.this.mTask.getStatus() != UserTask.Status.RUNNING) {
        UpcomingMoviesActivity.this.mTask = UpcomingMoviesActivity.this.new LoadPostersTask().execute(null);
      }
      if (NowPlayingApplication.SCROLLING_INTENT.equals(
          intent.getAction()) && UpcomingMoviesActivity.this.mTask.getStatus() == UserTask.Status.RUNNING) {
        UpcomingMoviesActivity.this.mTask.cancel(true);
      }
    }
  };

  /**
   * Updates display of the list of movies.
   */
  public void refresh() {
    if (this.search == null) {
      this.movies = NowPlayingControllerWrapper.getUpcomingMovies();
    }
    // sort movies according to the default sort preference.
    final Comparator<Movie> comparator = MOVIE_ORDER.get(
        NowPlayingControllerWrapper.getUpcomingMoviesSelectedSortIndex());
    Collections.sort(this.movies, comparator);
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

  private List<Movie> getMatchingMoviesList(final String search2) {
    final String localSearch = search2.toLowerCase();
    final List<Movie> matchingMovies = new ArrayList<Movie>();
    for (final Movie movie : this.movies) {
      if (movie.getDisplayTitle().toLowerCase().contains(localSearch)) {
        matchingMovies.add(movie);
      }
    }
    return matchingMovies;
  }

  public Context getContext() {
    return this;
  }

  /**
   * Called when the activity is first created.
   */
  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Log.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);

    // check for sdcard mounted properly
    if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
      // Request the progress bar to be shown in the title
      requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
      NowPlayingControllerWrapper.addActivity(this);
      refresh();
    } else {
      new AlertDialog.Builder(this).setTitle(R.string.insert_sdcard).setPositiveButton(android.R.string.ok,
                                                                                       new DialogInterface.OnClickListener() {
                                                                                         public void onClick(
                                                                                             final DialogInterface dialog,
                                                                                             final int whichButton) {
                                                                                           UpcomingMoviesActivity.this.finish();
                                                                                         }
                                                                                       }).show();
    }
  }

  @Override
  protected void onNewIntent(final Intent intent) {
    super.onNewIntent(intent);
    this.search = intent.getStringExtra("movie");
    if (this.search != null) {
      this.bottomBar.setVisibility(View.VISIBLE);
    } else {
      this.bottomBar.setVisibility(View.GONE);
    }
  }

  private void getUserLocation() {
    final String userLocation = NowPlayingControllerWrapper.getUserLocation();
    if (StringUtilities.isNullOrEmpty(userLocation)) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, SettingsActivity.class);
      startActivity(localIntent);
    }
  }

  private void getSearchResuts() {
    if (this.search != null) {
      final List<Movie> matchingMovies = getMatchingMoviesList(this.search);
      if (matchingMovies.isEmpty()) {
        Toast.makeText(this, getResources().getString(R.string.no_results_found_for) + this.search,
                       Toast.LENGTH_SHORT).show();
      } else {
        this.movies = matchingMovies;
        // cancel task so that it doesnt try to load the complete set of movies.
        if (this.mTask != null && this.mTask.getStatus() == UserTask.Status.RUNNING) {
          this.mTask.cancel(true);
        }
      }
    }
  }

  @Override
  protected void onDestroy() {
    Log.i(getClass().getSimpleName(), "onDestroy");

    NowPlayingControllerWrapper.removeActivity(this);
    if (this.mTask != null && this.mTask.getStatus() == UserTask.Status.RUNNING) {
      this.mTask.cancel(true);
    }
    clearBitmaps();
    super.onDestroy();
  }

  @Override
  protected void onPause() {
    Log.i(getClass().getSimpleName(), "onPause");

    unregisterReceiver(this.broadcastReceiver);
    unregisterReceiver(this.scrollStatebroadcastReceiver);
    if (this.mTask != null && this.mTask.getStatus() == UserTask.Status.RUNNING) {
      this.mTask.cancel(true);
    }
    super.onPause();
  }

  private static void clearBitmaps() {
    for (final SoftReference<Bitmap> reference : postersMap.values()) {
      final Bitmap drawable = reference.get();
      if (drawable != null) {
        reference.clear();
      }
    }
  }

  @Override
  protected void onResume() {
    super.onResume();
    Log.i(getClass().getSimpleName(), "onResume");

    registerReceiver(this.broadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_CHANGED_INTENT));
    registerReceiver(this.scrollStatebroadcastReceiver, new IntentFilter(NowPlayingApplication.SCROLLING_INTENT));
    registerReceiver(this.scrollStatebroadcastReceiver, new IntentFilter(NowPlayingApplication.NOT_SCROLLING_INTENT));
    if (this.isGridSetup) {
      this.grid.setVisibility(View.VISIBLE);
    }
    getUserLocation();
    if (this.movies != null && !this.movies.isEmpty()) {
      setup();
      this.isGridSetup = true;
    }
    getSearchResuts();
    refresh();
  }

  private void getAlphabet(final Context context) {
    final String alphabetString = context.getResources().getString(R.string.alphabet);
    this.alphabet = new String[alphabetString.length()];
    for (int i = 0; i < this.alphabet.length; i++) {
      this.alphabet[i] = String.valueOf(alphabetString.charAt(i));
    }
  }

  private void getScores(final Context context) {
    this.score = new String[11];
    for (int index = 0, i = 100; i >= 0; index++, i -= 10) {
      this.score[index] = i + "%";
    }
  }

  private void setup() {
    getAlphabet(this);
    getScores(this);
    setContentView(R.layout.moviegrid_anim);
    this.bottomBar = (RelativeLayout) findViewById(R.id.bottom_bar);
    if (this.search == null) {
      this.bottomBar.setVisibility(View.GONE);
    }
    final Button UpcomingMovies = (Button) findViewById(R.id.all_movies);
    UpcomingMovies.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        final Intent intent = new Intent();
        intent.setClass(UpcomingMoviesActivity.this, UpcomingMoviesActivity.class);
        UpcomingMoviesActivity.this.startActivity(intent);
      }
    });
    this.grid = (CustomGridView) findViewById(R.id.grid);
    this.grid.setOnItemClickListener(new OnItemClickListener() {
      public void onItemClick(final AdapterView parent, final View view, final int position, final long id) {
        UpcomingMoviesActivity.this.selectedMovie = UpcomingMoviesActivity.this.movies.get(position);
        setupRotationAnimation(view);
      }
    });
    this.grid.setLayoutAnimationListener(new AnimationListener() {
      public void onAnimationEnd(final Animation animation) {
      }

      public void onAnimationRepeat(final Animation animation) {
      }

      public void onAnimationStart(final Animation arg) {
      }
    });
    populateAlphaMovieSectionsAndPositions();
    populateScoreMovieSectionsAndPositions();
    this.postersAdapter = new PostersAdapter();
    this.grid.setAdapter(this.postersAdapter);
    this.intent = new Intent();
    this.intent.setClass(this, UpcomingMoviesActivity.class);
  }

  private void populateAlphaMovieSectionsAndPositions() {
    int i = 0;
    String prevLetter = null;
    final List<String> alphabets = Arrays.asList(this.alphabet);
    for (final Movie movie : this.movies) {
      final String firstLetter = movie.getDisplayTitle().substring(0, 1);
      this.alphaMovieSectionsMap.put(i, alphabets.indexOf(firstLetter));
      if (!firstLetter.equals(prevLetter)) {
        this.alphaMoviePositionsMap.put(alphabets.indexOf(firstLetter), i);
      }
      prevLetter = firstLetter;
      i++;
    }
  }

  private void populateScoreMovieSectionsAndPositions() {
    int i = 0;
    int prevLevel = 0;
    final List<String> scores = Arrays.asList(this.score);
    for (final Movie movie : this.movies) {
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
  }

  public final static List<Comparator<Movie>> MOVIE_ORDER = Arrays.asList(Movie.TITLE_ORDER, Movie.RELEASE_ORDER,
                                                                          Movie.SCORE_ORDER);

  private class PostersAdapter extends BaseAdapter implements FastScrollGridView.SectionIndexer {
    private final LayoutInflater inflater;

    private PostersAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(UpcomingMoviesActivity.this);
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
        holder = new ViewHolder((TextView) convertView.findViewById(R.id.title),
                                (ImageView) convertView.findViewById(R.id.poster));
        convertView.setTag(holder);
      } else {
        // Get the ViewHolder back to get fast access to the TextView
        // and the ImageView.
        holder = (ViewHolder) convertView.getTag();
      }
      final Movie movie = UpcomingMoviesActivity.this.movies.get(position % UpcomingMoviesActivity.this.movies.size());
      NowPlayingControllerWrapper.prioritizeMovie(movie);
      holder.title.setText(movie.getDisplayTitle());
      // optimized bitmap cache and bitmap loading
      holder.title.setEllipsize(TextUtils.TruncateAt.END);
      holder.poster.setImageDrawable(getResources().getDrawable(R.drawable.loader2));
      final SoftReference<Bitmap> reference = postersMap.get(UpcomingMoviesActivity.this.movies.get(position).getCanonicalTitle());
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
      if (UpcomingMoviesActivity.this.movies != null) {
        return Math.min(100, UpcomingMoviesActivity.this.movies.size());
      } else {
        return 0;
      }
    }

    public final Object getItem(final int position) {
      return UpcomingMoviesActivity.this.movies.get(position % UpcomingMoviesActivity.this.movies.size());
    }

    public final long getItemId(final int position) {
      return position;
    }

    public void refreshMovies() {
      notifyDataSetChanged();
    }

    public int getPositionForSection(final int section) {
      Integer position = null;
      if (NowPlayingControllerWrapper.getUpcomingMoviesSelectedSortIndex() == 0) {
        position = UpcomingMoviesActivity.this.alphaMoviePositionsMap.get(section);
      }
      if (NowPlayingControllerWrapper.getUpcomingMoviesSelectedSortIndex() == 2) {
        position = UpcomingMoviesActivity.this.scoreMoviePositionsMap.get(section);
      }
      if (position != null) {
        UpcomingMoviesActivity.this.lastPosition = position;
      }
      return UpcomingMoviesActivity.this.lastPosition;
    }

    public int getSectionForPosition(final int position) {
      if (NowPlayingControllerWrapper.getUpcomingMoviesSelectedSortIndex() == 0) {
        return UpcomingMoviesActivity.this.alphaMovieSectionsMap.get(position);
      }
      if (NowPlayingControllerWrapper.getUpcomingMoviesSelectedSortIndex() == 2) {
        return UpcomingMoviesActivity.this.scoreMovieSectionsMap.get(position);
      }
      return position;
    }

    public Object[] getSections() {
      // fast scroll is implemented only for alphabetic & score sort for release
      // 1.
      if (NowPlayingControllerWrapper.getUpcomingMoviesSelectedSortIndex() == 0) {
        return UpcomingMoviesActivity.this.alphabet;
      }
      if (NowPlayingControllerWrapper.getUpcomingMoviesSelectedSortIndex() == 2) {
        return UpcomingMoviesActivity.this.score;
      }
      return null;
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(R.drawable.ic_menu_home).setIntent(
        new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SEARCH, 0, R.string.search).setIcon(android.R.drawable.ic_menu_search);
    menu.add(0, MovieViewUtilities.MENU_SORT, 0, R.string.sort_movies).setIcon(R.drawable.ic_menu_switch);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(
        new Intent(this, SettingsActivity.class)).setAlphabeticShortcut('s');
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {
    if (item.getItemId() == MovieViewUtilities.MENU_SORT) {
      final NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this).setTitle(
          R.string.sort_movies).setKey(NowPlayingPreferenceDialog.PreferenceKeys.UPCOMING_MOVIES_SORT).setEntries(
          R.array.entries_movies_sort_preference).setPositiveButton(android.R.string.ok).setNegativeButton(
          android.R.string.cancel);
      builder.show();
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_SEARCH) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, SearchMovieActivity.class);
      localIntent.putExtra("activity", "UpcomingMoviesActivity");
      startActivity(localIntent);
      return true;
    }
    return false;
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
        UpcomingMoviesActivity.this.intent.putExtra("movie", (Parcelable) UpcomingMoviesActivity.this.selectedMovie);
        startActivity(UpcomingMoviesActivity.this.intent);
      }

      public void onAnimationRepeat(final Animation animation) {
      }

      public void onAnimationStart(final Animation animation) {
      }
    });
    view.startAnimation(rotation);
  }

  private class LoadPostersTask extends UserTask<Void, Void, Void> {
    @Override
    public Void doInBackground(final Void... params) {
      Bitmap bitmap = null;
      for (final Movie movie : UpcomingMoviesActivity.this.movies) {
        final SoftReference<Bitmap> reference = UpcomingMoviesActivity.postersMap.get(movie.getCanonicalTitle());
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
                UpcomingMoviesActivity.postersMap.put(movie.getCanonicalTitle(), new SoftReference<Bitmap>(bitmap));
              }
            }
          }
        }
      }
      return null;
    }

    @Override
    public void onPostExecute(final Void result) {
      super.onPostExecute(result);
      if (UpcomingMoviesActivity.this.postersAdapter != null) {
        UpcomingMoviesActivity.this.postersAdapter.refreshMovies();
      }
    }
  }

  private static Bitmap createBitmap(final byte[] bytes) {
    try {
      return BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
    } catch (final OutOfMemoryError e) {
      return null;
    }
    /*
     * final BitmapFactory.Options options = new BitmapFactory.Options(); final
     * int width = 90; final int height = 125; // Get the dimensions only.
     * options.inJustDecodeBounds = true; BitmapFactory.decodeByteArray(bytes,
     * 0, bytes.length, options); final int bitmapWidth = options.outWidth;
     * final int bitmapHeight = options.outHeight; final float scale =
     * Math.min((float) bitmapWidth / (float) width, (float) bitmapHeight /
     * (float) height) * 2; options.inJustDecodeBounds = false;
     * options.inPreferredConfig = Bitmap.Config.ARGB_8888; options.inSampleSize =
     * (int) scale; final Bitmap bitmap = BitmapFactory.decodeByteArray(bytes,
     * 0, bytes.length, options); return bitmap;
     */
  }
}
