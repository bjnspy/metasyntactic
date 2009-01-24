package org.metasyntactic;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Paint;
import android.os.Bundle;
import android.os.Parcelable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.Animation.AnimationListener;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemClickListener;

import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.metasyntactic.views.FastScrollGridView;
import org.metasyntactic.views.NowPlayingPreferenceDialog;
import org.metasyntactic.views.Rotate3dAnimation;

import java.lang.ref.SoftReference;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NowPlayingActivity extends Activity implements INowPlaying {
  private GridView grid;
  private Intent intent;
  private Movie selectedMovie;
  private PostersAdapter postersAdapter;
  private boolean gridAnimationEnded;
  private boolean isGridSetup;
  private List<Movie> movies;
  private int lastPosition;
  private String search;
  private final Map<Integer, Integer> alphaMovieSectionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> alphaMoviePositionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> scoreMovieSectionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> scoreMoviePositionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, SoftReference<Bitmap>> postersMap = new HashMap<Integer, SoftReference<Bitmap>>();
  private String[] alphabet;
  private String[] score;
  private static final Paint SHADOW_PAINT = new Paint();
  private static final Paint SCALE_PAINT = new Paint(Paint.ANTI_ALIAS_FLAG
      | Paint.FILTER_BITMAP_FLAG);
  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(final Context context, final Intent intent) {
      refresh();
    }
  };
  private final BroadcastReceiver databroadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(final Context context, final Intent intent) {
      if (!NowPlayingActivity.this.isGridSetup) {
        setup();
      }
    }
  };

  /** Updates display of the list of movies. */
  public void refresh() {
    if (this.search == null) {
      this.movies = NowPlayingControllerWrapper.getMovies();
    }
    // sort movies according to the default sort preference.
    final Comparator<Movie> comparator = MOVIE_ORDER.get(NowPlayingControllerWrapper
        .getAllMoviesSelectedSortIndex());
    Collections.sort(this.movies, comparator);
    clearBitmaps();
    if (this.postersAdapter != null) {
      this.postersAdapter.refreshMovies();
    }
  }

  private List<Movie> getMatchingMoviesList(final String search2) {
    final String search = search2.toLowerCase();
    final List<Movie> matchingMovies = new ArrayList<Movie>();
    for (final Movie movie : this.movies) {
      if (movie.getDisplayTitle().toLowerCase().contains(search)) {
        matchingMovies.add(movie);
      }
    }
    return matchingMovies;
  }

  public Context getContext() {
    return this;
  }

  /** Called when the activity is first created. */
  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    // Request the progress bar to be shown in the title
    requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
    setContentView(R.layout.progressbar_1);
    NowPlayingControllerWrapper.addActivity(this);
    getUserLocation();
    refresh();
    if (this.movies != null && !this.movies.isEmpty()) {
      setup();
      this.isGridSetup = true;
    }
    showSearchResuts();
  }

  private void getUserLocation() {
    final String userLocation = NowPlayingControllerWrapper.getUserLocation();
    if (StringUtilities.isNullOrEmpty(userLocation)) {
      final Intent intent = new Intent();
      intent.setClass(this, SettingsActivity.class);
      startActivity(intent);
    }
  }

  private void showSearchResuts() {
    this.search = getIntent().getStringExtra("movie");
    if (this.search != null) {
      final List<Movie> matchingMovies = getMatchingMoviesList(this.search);
      if (!matchingMovies.isEmpty() && !this.isGridSetup) {
        this.movies = matchingMovies;
      } else {
        Toast.makeText(this,
            getResources().getString(R.string.no_results_found_for_string) + this.search,
            Toast.LENGTH_SHORT).show();
      }
    }
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override
  protected void onPause() {
    unregisterReceiver(this.broadcastReceiver);
    unregisterReceiver(this.databroadcastReceiver);
    clearBitmaps();
    super.onPause();
  }

  private void clearBitmaps() {
    for (final SoftReference<Bitmap> reference : this.postersMap.values()) {
      final Bitmap drawable = reference.get();
      if (drawable != null) {
        reference.clear();
      }
    }
  }

  @Override
  protected void onResume() {
    super.onResume();
    registerReceiver(this.broadcastReceiver, new IntentFilter(
        Application.NOW_PLAYING_CHANGED_INTENT));
    registerReceiver(this.databroadcastReceiver, new IntentFilter(
        Application.NOW_PLAYING_LOCAL_DATA_DOWNLOADED));
    if (this.isGridSetup) {
      this.grid.setVisibility(View.VISIBLE);
    }
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
    this.grid = (GridView) findViewById(R.id.grid);
    this.grid.setOnItemClickListener(new OnItemClickListener() {
      public void onItemClick(final AdapterView parent, final View view, final int position,
          final long id) {
        NowPlayingActivity.this.selectedMovie = NowPlayingActivity.this.movies.get(position);
        setupRotationAnimation(view);
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
    populateAlphaMovieSectionsAndPositions();
    populateScoreMovieSectionsAndPositions();
    this.postersAdapter = new PostersAdapter();
    this.grid.setAdapter(this.postersAdapter);
    this.intent = new Intent();
    this.intent.setClass(this, AllMoviesActivity.class);
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
      final Score score = NowPlayingControllerWrapper.getScore(movie);
      final int scoreValue = score == null ? 0 : score.getScoreValue();
      final int scoreLevel = scoreValue / 10 * 10;
      this.scoreMovieSectionsMap.put(i, scores.indexOf(scoreLevel + "%"));
      if (scoreLevel != prevLevel) {
        this.scoreMoviePositionsMap.put(scores.indexOf(scoreLevel + "%"), i);
      }
      prevLevel = scoreLevel;
      i++;
    }
  }

  public final static List<Comparator<Movie>> MOVIE_ORDER = Arrays.asList(Movie.TITLE_ORDER,
      Movie.RELEASE_ORDER, Movie.SCORE_ORDER);

  private class PostersAdapter extends BaseAdapter implements FastScrollGridView.SectionIndexer {
    private final LayoutInflater inflater;

    private PostersAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(NowPlayingActivity.this);
    }

    public View getView(final int position, View convertView, final ViewGroup parent) {
      // to findViewById() on each row.
      final ViewHolder holder;
      Bitmap bitmap = null;
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
      final Movie movie = NowPlayingActivity.this.movies.get(position
          % NowPlayingActivity.this.movies.size());
      NowPlayingControllerWrapper.prioritizeMovie(movie);
      holder.title.setText(movie.getDisplayTitle());
      // optimized bitmap cache and bitmap loading
      holder.title.setEllipsize(TextUtils.TruncateAt.END);
      holder.poster.setImageDrawable(getResources().getDrawable(R.drawable.loader2));
      final SoftReference<Bitmap> reference = NowPlayingActivity.this.postersMap.get(position);
      if (reference != null) {
        bitmap = reference.get();
      }
      if (bitmap != null) {
        holder.poster.setImageBitmap(bitmap);
      } else {
        final byte[] bytes = NowPlayingControllerWrapper.getPoster(movie);
        if (bytes.length > 0) {
          bitmap = createBitmap(bytes);
          if (bitmap != null) {
            holder.poster.setImageBitmap(bitmap);
            NowPlayingActivity.this.postersMap.put(position, new SoftReference<Bitmap>(bitmap));
          }
        }
      }
      convertView
          .setBackgroundDrawable(getResources().getDrawable(R.drawable.gallery_background_1));
      bitmap = null;
      return convertView;
    }

    private Bitmap createBitmap(final byte[] bytes) {
      final BitmapFactory.Options options = new BitmapFactory.Options();
      final int width = 90;
      final int height = 125;
      // Get the dimensions only.
      options.inJustDecodeBounds = true;
      BitmapFactory.decodeByteArray(bytes, 0, bytes.length, options);
      final int bitmapWidth = options.outWidth;
      final int bitmapHeight = options.outHeight;
      final float scale = Math.min((float) bitmapWidth / (float) width, (float) bitmapHeight
          / (float) height) * 2;
      options.inJustDecodeBounds = false;
      options.inPreferredConfig = Bitmap.Config.ARGB_8888;
      options.inSampleSize = (int) scale;
      final Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length, options);
      return bitmap;
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
        return Math.min(1000, NowPlayingActivity.this.movies.size());
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
      notifyDataSetChanged();
      FastScrollGridView.getSections();
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

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_SEARCH, 0, R.string.search).setIcon(
        android.R.drawable.ic_menu_search);
    menu.add(0, MovieViewUtilities.MENU_SORT, 0, R.string.sort_movies).setIcon(
        R.drawable.ic_menu_switch);
    menu.add(0, MovieViewUtilities.MENU_THEATER, 0, R.string.theaters).setIcon(
        R.drawable.ic_menu_allfriends);
    menu.add(0, MovieViewUtilities.MENU_UPCOMING, 0, R.string.upcoming)
        .setIcon(R.drawable.upcoming);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class))
        .setAlphabeticShortcut('s');
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {
    if (item.getItemId() == MovieViewUtilities.MENU_SORT) {
      final NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this).setTitle(
          R.string.sort_movies).setKey(NowPlayingPreferenceDialog.PreferenceKeys.MOVIES_SORT)
          .setEntries(R.array.entries_movies_sort_preference)
          .setPositiveButton(android.R.string.ok).setNegativeButton(android.R.string.cancel);
      builder.show();
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_THEATER) {
      final Intent intent = new Intent();
      intent.setClass(this, AllTheatersActivity.class);
      startActivity(intent);
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_UPCOMING) {
      final Intent intent = new Intent();
      intent.setClass(this, UpcomingMoviesActivity.class);
      startActivity(intent);
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_SEARCH) {
      final Intent intent = new Intent();
      intent.setClass(this, SearchMovieActivity.class);
      startActivity(intent);
      return true;
    }
    return false;
  }

  private void setupRotationAnimation(final View view) {
    final float centerX = view.getWidth() / 2.0f;
    final float centerY = view.getHeight() / 2.0f;
    // Create a new 3D rotation with the supplied parameter
    // The animation listener is used to trigger the next animation
    final Rotate3dAnimation rotation = new Rotate3dAnimation(90, 0, centerX, centerY, 0.0f, true);
    rotation.setDuration(100);
    rotation.setFillAfter(true);
    rotation.setAnimationListener(new AnimationListener() {
      public void onAnimationEnd(final Animation animation) {
        final Animation slide = AnimationUtils.loadAnimation(NowPlayingActivity.this,
            R.anim.slide_left);
        NowPlayingActivity.this.grid.startAnimation(slide);
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
    view.startAnimation(rotation);
  }
}
