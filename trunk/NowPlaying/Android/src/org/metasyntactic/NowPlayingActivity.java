// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package org.metasyntactic;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.*;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.widget.*;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.*;

public class NowPlayingActivity extends Activity implements INowPlaying {
  public static NowPlayingActivity instance;
  public static final int MENU_SORT = 1;
  public static final int MENU_SETTINGS = 2;
  private GridView grid;
  private Intent intent;
  private Animation animation;
  private int selection;
  private PostersAdapter postersAdapter;
  private boolean gridAnimationEnded;
  private boolean isPrioritized;
  private boolean isGridSetup;
  Bitmap bitmap;
  private int pagecount;
  private int maxpagecount;
  private boolean isDestroyed;
  private List<Movie> movies;

  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(Context context, Intent intent) {
      refresh();
    }
  };

  /** Updates display of the list of movies. */
  public void refresh() {
    Runnable runnable = new Runnable() {
      public void run() {
        if (!isDestroyed) {
          List<Movie> tmpMovies = NowPlayingControllerWrapper1.getMovies();
          // sort movies according to the default sort preference.
          Comparator<Movie> comparator = MOVIE_ORDER.get(NowPlayingControllerWrapper1
              .getAllMoviesSelectedSortIndex());
          Collections.sort(tmpMovies, comparator);
          movies = new ArrayList<Movie>();
          movies.addAll(tmpMovies);
          if (!isPrioritized) {
            for (int i = 0; i < Math.min(6, movies.size()); i++) {
              NowPlayingControllerWrapper1.prioritizeMovie(movies.get(i));
            }
            isPrioritized = true;
          }
          if (movies.size() > 0 && !isGridSetup) {
            setup();
            isGridSetup = true;
          }
          if (postersAdapter != null && gridAnimationEnded) {
            postersAdapter.refreshMovies();
          }
        }
      }
    };
    Thread t1 = new Thread(runnable);
    t1.start();
  }

  public List<Movie> getMovies() {
    return movies;
  }

  public NowPlayingActivity() {
    instance = this;
  }

  public Context getContext() {
    return this;
  }

  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper1.addActivity(this);

    // Request the progress bar to be shown in the title
    requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
    setContentView(R.layout.progressbar_1);
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper1.removeActivity(this);
    isDestroyed = true;
    super.onDestroy();
  }

  @Override
  protected void onResume() {
    super.onResume();

    registerReceiver(broadcastReceiver, new IntentFilter(Application.NOW_PLAYING_CHANGED_INTENT));
    if (movies != null && movies.size() > 0) {
      setup();
      isGridSetup = true;
    }
    if (postersAdapter != null) {
      postersAdapter.refreshMovies();
    }
  }

  private void setup() {
    if (ThreadingUtilities.isBackgroundThread()) {
      Runnable runnable = new Runnable() {
        public void run() {
          setup();
        }
      };
      ThreadingUtilities.performOnMainThread(runnable);
      return;
    }
    setContentView(R.layout.moviegrid_anim);
    grid = (GridView) findViewById(R.id.grid);
    Button up = (Button) findViewById(R.id.up_1);
    Button down = (Button) findViewById(R.id.down_1);
    up.setFocusableInTouchMode(true);
    down.setFocusableInTouchMode(true);
    up.setClickable(true);
    maxpagecount = movies.size() / 9;
    up.setOnClickListener(new OnClickListener() {
      public void onClick(View arg0) {
        if (pagecount + 1 >= 0) {
          pagecount--;
        }
        grid.setSelection(pagecount * 10);
      }
    });
    down.setOnClickListener(new OnClickListener() {
      public void onClick(View arg0) {
        if (pagecount + 1 <= maxpagecount) {
          pagecount++;
        }
        grid.setSelection(pagecount * 10);
      }
    });
    grid.setLayoutAnimationListener(new AnimationListener() {
      public void onAnimationEnd(Animation animation) {
        gridAnimationEnded = true;
      }

      public void onAnimationRepeat(Animation animation) {
      }

      public void onAnimationStart(Animation arg0) {
      }
    });
    postersAdapter = new PostersAdapter(this);
    grid.setAdapter(postersAdapter);
    intent = new Intent();
    intent.setClass(this, AllMoviesActivity.class);
    animation = AnimationUtils.loadAnimation(this, R.anim.fade_reverse);
    animation.setAnimationListener(new AnimationListener() {
      public void onAnimationEnd(Animation animation) {
        intent.putExtra("selection", selection);
        startActivity(intent);
        setContentView(R.layout.main);
      }

      public void onAnimationRepeat(Animation animation) {
      }

      public void onAnimationStart(Animation animation) {
      }
    });
  }

  @Override
  protected void onPause() {
    unregisterReceiver(broadcastReceiver);
    super.onPause();
  }

  final static Comparator<Movie> TITLE_ORDER = new Comparator<Movie>() {
    public int compare(Movie m1, Movie m2) {
      return m1.getDisplayTitle().compareTo(m2.getDisplayTitle());
    }
  };
  final static Comparator<Movie> RELEASE_ORDER = new Comparator<Movie>() {
    public int compare(Movie m1, Movie m2) {
      Calendar c1 = Calendar.getInstance();
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
  final static Comparator<Movie> SCORE_ORDER = new Comparator<Movie>() {
    public int compare(Movie m1, Movie m2) {
      int value1 = 0;
      int value2 = 0;
      Score score1 = NowPlayingControllerWrapper1.getScore(m1);
      Score score2 = NowPlayingControllerWrapper1.getScore(m1);
      if (score1 != null) {
        value1 = score1.getScoreValue();
      }
      if (score2 != null) {
        value2 = score2.getScoreValue();
      }
      if (value1 == value2) {
        return m1.getDisplayTitle().compareTo(m2.getDisplayTitle());
      } else {
        return value2 - value1;
      }
    }
  };
  final static List<Comparator<Movie>> MOVIE_ORDER = Arrays.asList(TITLE_ORDER, RELEASE_ORDER, SCORE_ORDER);

  public class PostersAdapter extends BaseAdapter {
    private LayoutInflater inflater;

    public PostersAdapter(Context context) {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(context);
    }

    public View getView(final int position, View convertView, ViewGroup parent) {
      // to findViewById() on each row.
      final ViewHolder holder;
      // When convertView is not null, we can reuse it directly, there is no need
      // to reinflate it. We only inflate a new View when the convertView supplied
      // by ListView is null.
      if (convertView == null) {
        convertView = inflater.inflate(R.layout.moviegrid_item, null);
        // Creates a ViewHolder and store references to the two children views
        // we want to bind data to.
        holder = new ViewHolder();
        holder.title = (TextView) convertView.findViewById(R.id.title);
        holder.poster = (ImageView) convertView
            .findViewById(R.id.poster);
        convertView.setTag(holder);
      } else {
        // Get the ViewHolder back to get fast access to the TextView
        // and the ImageView.
        holder = (ViewHolder) convertView.getTag();
      }
      final Movie movie = movies.get(position % movies.size());
      holder.title.setText(movie.getDisplayTitle());
      holder.title.setEllipsize(TextUtils.TruncateAt.END);
      final byte[] bytes = NowPlayingControllerWrapper1.getPoster(movie).getBytes();
      if (bytes.length > 0) {
        bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
        holder.poster.setImageBitmap(bitmap);
      } else {
        holder.poster.setImageDrawable(NowPlayingActivity.this.getResources()
            .getDrawable(R.drawable.movies));
      }
      convertView.setOnClickListener(new OnClickListener() {
        public void onClick(View v) {
          selection = position;
          int i = 0;
          View child = grid.getChildAt(i);
          while (child != null && child.getVisibility() == View.VISIBLE) {
            child.startAnimation(animation);
            i++;
            child = grid.getChildAt(i);
          }
        }
      });
      return convertView;
    }

    class ViewHolder {
      TextView title;
      ImageView poster;
    }

    public final int getCount() {
      if (movies != null) {
        return Math.min(100, movies.size());
      } else {
        return 0;
      }
    }

    public final Object getItem(int position) {
      return movies.get(position % movies.size());
    }

    public final long getItemId(int position) {
      return position;
    }

    public void refreshMovies() {
      // if(gridAnimationEnded)
      if (ThreadingUtilities.isBackgroundThread()) {
        Runnable runnable = new Runnable() {
          public void run() {
            refreshMovies();
          }
        };
        ThreadingUtilities.performOnMainThread(runnable);
        return;
      }
      notifyDataSetChanged();
    }
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    menu.add(0, MENU_SORT, 0, R.string.menu_movie_sort).setIcon(android.R.drawable.star_on);
    menu.add(0, MENU_SETTINGS, 0, R.string.menu_settings)
        .setIcon(android.R.drawable.ic_menu_preferences)
        .setIntent(new Intent(this, SettingsActivity.class))
        .setAlphabeticShortcut('s');
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    if (item.getItemId() == MENU_SORT) {
      NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this).setTitle(
          R.string.movies_select_sort_title).setKey(NowPlayingPreferenceDialog.Preference_keys.MOVIES_SORT)
          .setEntries(R.array.entries_movies_sort_preference);
      builder.show();
      return true;
    }
    return false;
  }
}
