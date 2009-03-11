package org.metasyntactic.activities;

import java.io.File;
import java.lang.ref.SoftReference;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.metasyntactic.INowPlaying;
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.FileUtilities;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.metasyntactic.views.CustomGridView;
import org.metasyntactic.views.FastScrollGridView;
import org.metasyntactic.views.Rotate3dAnimation;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.os.Parcelable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

public class MoviesActivity extends Activity implements INowPlaying {
  protected CustomGridView grid;
  protected Intent intent;
  protected Movie selectedMovie;
  protected boolean isGridSetup;
  protected List<Movie> movies;
  protected String search;
  protected final Map<Integer, Integer> movieIndexToSectionIndex = new HashMap<Integer, Integer>();
  protected final Map<Integer, Integer> sectionIndexToMovieIndex = new HashMap<Integer, Integer>();
  protected final List<String> actualSections = new ArrayList<String>();
  protected RelativeLayout bottomBar;
  protected PostersAdapter postersAdapter;
  protected static final Map<String, SoftReference<Bitmap>> postersMap = new HashMap<String, SoftReference<Bitmap>>();
  protected boolean scrolling;
  protected BroadcastReceiver broadcastReceiver;
  protected BroadcastReceiver scrollStatebroadcastReceiver;

  protected static Bitmap getPoster(final Movie movie) {
    final String key = movie.getCanonicalTitle();
    final SoftReference<Bitmap> reference = postersMap.get(key);
    Bitmap bitmap = null;
    if (reference != null) {
      bitmap = reference.get();
    }
    if (bitmap == null) {
      final File file = NowPlayingControllerWrapper.getPosterFile_safeToCallFromBackground(movie);
      if (file != null) {
        final byte[] bytes = FileUtilities.readBytes(file);
        if (bytes != null && bytes.length > 0) {
          bitmap = createBitmap(bytes);
          if (bitmap != null) {
            postersMap.put(movie.getCanonicalTitle(), new SoftReference<Bitmap>(bitmap));
          }
        }
      }
    }
    return bitmap;
  }

  protected static void clearBitmaps() {
    for (final SoftReference<Bitmap> reference : postersMap.values()) {
      reference.clear();
    }
  }

  protected void populateSections() {
    actualSections.clear();
    movieIndexToSectionIndex.clear();
    sectionIndexToMovieIndex.clear();
  }

  private List<Movie> getMatchingMoviesList(final String search2) {
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

  @Override
  protected void onResume() {
    super.onResume();
    LogUtilities.i(getClass().getSimpleName(), "onResume");
    scrolling = false;
    registerReceiver(broadcastReceiver, new IntentFilter(
        NowPlayingApplication.NOW_PLAYING_CHANGED_INTENT));
    registerReceiver(scrollStatebroadcastReceiver, new IntentFilter(
        NowPlayingApplication.SCROLLING_INTENT));
    registerReceiver(scrollStatebroadcastReceiver, new IntentFilter(
        NowPlayingApplication.NOT_SCROLLING_INTENT));
    if (isGridSetup) {
      grid.setVisibility(View.VISIBLE);
      postersAdapter.notifyDataSetChanged();
    }
  }

  @Override
  protected void onPause() {
    LogUtilities.i(getClass().getSimpleName(), "onPause");
    unregisterReceiver(broadcastReceiver);
    unregisterReceiver(scrollStatebroadcastReceiver);
    super.onPause();
  }

  @Override
  protected void onDestroy() {
    super.onDestroy();
  }

  @Override
  public Object onRetainNonConfigurationInstance() {
    LogUtilities.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    final Object result = new Object();
    NowPlayingControllerWrapper.onRetainNonConfigurationInstance(this, result);
    return result;
  }

  @Override
  protected void onNewIntent(final Intent intent) {
    super.onNewIntent(intent);
    search = intent.getStringExtra("movie");
    if (search != null) {
      bottomBar.setVisibility(View.VISIBLE);
    }
    getSearchResults();
  }

  protected void getUserLocation() {
    final String userLocation = NowPlayingControllerWrapper.getUserLocation();
    if (StringUtilities.isNullOrEmpty(userLocation)) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, SettingsActivity.class);
      startActivity(localIntent);
    }
  }

  private void getSearchResults() {
    if (search != null) {
      final List<Movie> matchingMovies = getMatchingMoviesList(search);
      if (matchingMovies.isEmpty()) {
        Toast.makeText(this, getResources().getString(R.string.no_results_found_for) + search,
            Toast.LENGTH_SHORT).show();
      } else {
        movies = matchingMovies;
      }
    }
  }

  @SuppressWarnings("unchecked")
  protected static final List<Comparator<Movie>> MOVIE_ORDER = Arrays.asList(Movie.TITLE_ORDER,
      Movie.RELEASE_ORDER, Movie.SCORE_ORDER);

  protected void populateAlphaMovieSectionsAndPositions() {
    for (int i = 0; i < movies.size(); i++) {
      final Movie movie = movies.get(i);
      final String sectionTitle = movie.getDisplayTitle().substring(0, 1);
      if (!actualSections.contains(sectionTitle)) {
        actualSections.add(sectionTitle);
      }
      final int sectionIndex = actualSections.indexOf(sectionTitle);
      movieIndexToSectionIndex.put(i, sectionIndex);
      if (!sectionIndexToMovieIndex.containsKey(sectionIndex)) {
        sectionIndexToMovieIndex.put(sectionIndex, i);
      }
    }
  }

  protected void populateScoreMovieSectionsAndPositions() {
    for (int i = 0; i < movies.size(); i++) {
      final Movie movie = movies.get(i);
      final Score localScore = NowPlayingControllerWrapper.getScore(movie);
      final int scoreValue = localScore == null ? 0 : localScore.getScoreValue();
      final int scoreLevel = scoreValue / 10 * 10;
      final String sectionTitle = scoreLevel + "%";
      if (!actualSections.contains(sectionTitle)) {
        actualSections.add(sectionTitle);
      }
      final int sectionIndex = actualSections.indexOf(sectionTitle);
      movieIndexToSectionIndex.put(i, sectionIndex);
      if (!sectionIndexToMovieIndex.containsKey(sectionIndex)) {
        sectionIndexToMovieIndex.put(sectionIndex, i);
      }
    }
  }

  protected enum ViewState {
    Blank, Loading, Loaded
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
     * options.inPreferredConfig = Bitmap.Config.ARGB_8888; options.inSampleSize =
     * (int) scale; final Bitmap bitmap = BitmapFactory.decodeByteArray(bytes,
     * 0, bytes.length, options); return bitmap;
     */
  }

  public void refresh() {
    if (postersAdapter != null) {
      populateSections();
      FastScrollGridView.getSections();
      postersAdapter.notifyDataSetChanged();
    }
  }

  protected void setupRotationAnimation(final View view) {
    final float centerX = view.getWidth() / 2.0f;
    final float centerY = view.getHeight() / 2.0f;
    // Create a new 3D rotation with the supplied parameter
    // The animation listener is used to trigger the next animation
    final Animation rotation = new Rotate3dAnimation(80, 0, centerX, centerY, 0.0f, true);
    rotation.setDuration(20);
    rotation.setFillAfter(true);
    rotation.setAnimationListener(new AnimationListener() {
      public void onAnimationEnd(final Animation animation) {
        intent.putExtra("movie", (Parcelable) selectedMovie);
        startActivity(intent);
      }

      public void onAnimationRepeat(final Animation animation) {
      }

      public void onAnimationStart(final Animation animation) {
      }
    });
    view.startAnimation(rotation);
  }

  public MoviesActivity() {
    super();
  }

  protected class PostersAdapter extends BaseAdapter implements FastScrollGridView.SectionIndexer {
    private final LayoutInflater inflater;
    private final Drawable loadingDrawable;
    private final Drawable backgroundDrawable;

    protected PostersAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(MoviesActivity.this);
      loadingDrawable = getResources().getDrawable(R.drawable.loader2);
      backgroundDrawable = getResources().getDrawable(R.drawable.gallery_background_1);
    }

    public View getView(final int position, View convertView, final ViewGroup parent) {
      // to findViewById() on each row.
      final ViewHolder holder;
      // When convertView is not null, we can reuse it directly, there is
      // no need to reinflate it. We only inflate a new View when the
      // convertView
      // supplied by GridView is null.
      final Movie movie = movies.get(position % movies.size());
      if (convertView == null) {
        convertView = inflater.inflate(R.layout.moviegrid_item, null);
        // Creates a ViewHolder and store references to the two children
        // views we want to bind data to.
        holder = new ViewHolder(movie, (TextView) convertView.findViewById(R.id.title),
            (ImageView) convertView.findViewById(R.id.poster));
        convertView.setTag(holder);
        convertView.setBackgroundDrawable(backgroundDrawable);
      } else {
        // Get the ViewHolder back to get fast access to the TextView
        // and the ImageView.
        holder = (ViewHolder) convertView.getTag();
      }
      holder.title.setText(movie.getDisplayTitle());
      holder.title.setEllipsize(TextUtils.TruncateAt.END);
      // decide what image to show if we're scrolling or not.
      if (scrolling) {
        if (movie == holder.movie) {
          // ok, we're scrolling, and we're still on the same movie. Keep the
          // poster if it's been loaded. But if we have no poster yet, just show
          // the 'loading' poster.
          if (holder.viewState == ViewState.Blank) {
            holder.poster.setImageDrawable(loadingDrawable);
            holder.viewState = ViewState.Loading;
          }
        } else {
          // we're scrolling, and we're reusing a view for a different movie.
          // show the 'loading' poster if it's not already up.
          if (holder.viewState != ViewState.Loading) {
            holder.poster.setImageDrawable(loadingDrawable);
            holder.viewState = ViewState.Loading;
          }
        }
      } else {
        NowPlayingControllerWrapper.prioritizeMovie(movie);
        // ok. we've stopped scrolling. either we're reusing this view for a
        // new movie, or we haven't loaded the image for this movie yet. in
        // either case try to load it. if we can, then we're done and don't
        // need to do anything else now.
        if (movie != holder.movie || holder.viewState != ViewState.Loaded) {
          final Bitmap bitmap = getPoster(movie);
          if (bitmap == null) {
            if (holder.viewState != ViewState.Loading) {
              holder.poster.setImageDrawable(loadingDrawable);
              holder.viewState = ViewState.Loading;
            }
          } else {
            holder.poster.setImageBitmap(bitmap);
            holder.viewState = ViewState.Loaded;
          }
        }
      }
      holder.movie = movie;
      return convertView;
    }

    private class ViewHolder {
      private final TextView title;
      private final ImageView poster;
      private Movie movie;
      private ViewState viewState;

      private ViewHolder(final Movie movie, final TextView title, final ImageView poster) {
        this.movie = movie;
        this.title = title;
        this.poster = poster;
        viewState = ViewState.Blank;
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

    public int getPositionForSection(final int section) {
      final Integer position = sectionIndexToMovieIndex.get(section);
      if (position == null) {
        return 0;
      }
      return position;
    }

    public int getSectionForPosition(final int position) {
      final Integer section = movieIndexToSectionIndex.get(position);
      if (section == null) {
        return 0;
      }
      return section;
    }

    public Object[] getSections() {
      return null;
    }
  }
}