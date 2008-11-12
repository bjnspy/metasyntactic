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
import android.content.*;
import android.content.res.TypedArray;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.IBinder;
import android.text.TextUtils;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.widget.*;
import org.metasyntactic.data.Movie;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.*;

public class NowPlayingActivity extends Activity implements INowPlaying {
  public static NowPlayingActivity instance;
  private static Context mContext;
  public static final int MENU_SORT = 1;
  public static final int MENU_SETTINGS = 2;
  private GridView grid;
  private Intent intent;
  private Animation animation;
  private int selection;
  private PostersAdapter postersAdapter;
  static NowPlayingControllerWrapper controller;
  private static boolean isPosterReady;
  private boolean gridAnimationEnded;
  private boolean isPrioritized;
  private boolean isGridSetup;
  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(Context context, Intent intent) {
      refresh();
    }
  };

  /** Updates display of the list of movies. */
  public void refresh() {
    movies = controller.getMovies();
    //sort movies according to the default sort preference.
    Comparator comparator = MOVIE_ORDER[controller
        .getAllMoviesSelectedSortIndex()];
    Collections.sort(movies, comparator);
    //show the intial posters view after atleast 6 posters are loaded.
    int posterCount = 0;
    if (!isPrioritized) {
      Log.i("test", "movies prioritized");
      for (int i = 0; i < movies.size(); i++) {
        controller.prioritizeMovie(movies.get(i));
      }
      isPrioritized = true;
    }
    for (int i = 0; i < movies.size(); i++) {
      if (controller.getPoster(movies.get(i)) != null && controller.getPoster(movies.get(i)).getBytes().length > 0) {
        posterCount++;
      }
    }
    if (posterCount > Math.min(6, movies.size() / 8) && !isGridSetup) {
      Log.i("test", "setup called");
      setup();
      isGridSetup = true;
    }
    if (postersAdapter != null) {
      postersAdapter.refreshMovies();
    }
  }

  public List<Movie> getMovies() {
    return movies;
  }

  private final ServiceConnection serviceConnection = new ServiceConnection() {
    public void onServiceConnected(ComponentName className, IBinder service) {
      // This is called when the connection with the service has been
      // established, giving us the service object we can use to
      // interact with the service. We are communicating with our
      // service through an IDL interface, so get a client-side
      // representation of that from the raw service object.
      controller = new NowPlayingControllerWrapper(INowPlayingController.Stub.asInterface(service));
      onControllerConnected();
    }

    public void onServiceDisconnected(ComponentName className) {
      controller = null;
    }
  };

  private void onControllerConnected() {
    refresh();
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
    mContext = this;
    setContentView(R.layout.progressbar_1);
  }

  /**
   * Returns an instance of NowPlayingControllerWrapper associated with this Activity.
   *
   * @return controller instance of NowPlayingControllerWrapper
   */
  public NowPlayingControllerWrapper getController() {
    return controller;
  }

  @Override
  protected void onDestroy() {
    unbindService(serviceConnection);
    super.onDestroy();
  }

  @Override
  protected void onResume() {
    super.onResume();
    boolean bindResult = bindService(new Intent(getBaseContext(), NowPlayingControllerService.class), serviceConnection,
                                     Context.BIND_AUTO_CREATE);
    if (!bindResult) {
      throw new RuntimeException("Failed to bind to service!");
    }
    registerReceiver(broadcastReceiver, new IntentFilter(Application.NOW_PLAYING_CHANGED_INTENT));
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
    //  Animation gridAnimation = AnimationUtils.loadAnimation(mContext, R.anim.layout_grid_fade);
    // grid.setAnimation(gridAnimation);
    //grid.setLayoutAnimation(new LayoutAnimationController(gridAnimation));
    grid.setLayoutAnimationListener(new AnimationListener() {
      @Override
      public void onAnimationEnd(Animation animation) {
        // TODO Auto-generated method stub
        gridAnimationEnded = true;
      }

      @Override
      public void onAnimationRepeat(Animation animation) {
        // TODO Auto-generated method stub
      }

      @Override
      public void onAnimationStart(Animation arg0) {
        // TODO Auto-generated method stub
      }
    });
    postersAdapter = new PostersAdapter();
    grid.setAdapter(postersAdapter);
    intent = new Intent();
    intent.setClass(mContext, AllMoviesActivity.class);
    animation = AnimationUtils.loadAnimation(mContext, R.anim.fade_reverse);
    animation.setAnimationListener(new AnimationListener() {
      public void onAnimationEnd(Animation animation) {
        // TODO Auto-generated method stub
        intent.putExtra("selection", selection);
        startActivity(intent);
        setContentView(R.layout.main);
      }

      public void onAnimationRepeat(Animation animation) {
        // TODO Auto-generated method stub
      }

      public void onAnimationStart(Animation animation) {
        // TODO Auto-generated method stub
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
      Date d1;
      Date d2;
      if (m1.getReleaseDate() == null) {
        Calendar c1 = Calendar.getInstance();
        c1.set(1900, 11, 11);
        d1 = c1.getTime();
      } else {
        d1 = m1.getReleaseDate();
      }
      if (m2.getReleaseDate() == null) {
        Calendar c2 = Calendar.getInstance();
        c2.set(1900, 11, 11);
        d2 = c2.getTime();
      } else {
        d2 = m2.getReleaseDate();
      }
      return d2.compareTo(d1);
    }
  };
  final static Comparator<Movie> SCORE_ORDER = new Comparator<Movie>() {
    public int compare(Movie m1, Movie m2) {
      if (controller.getScore(m1) == null && controller.getScore(m2) == null) {
        return 0;
      }
      if (controller.getScore(m1) != null && controller.getScore(m2) != null) {
        return controller.getScore(m2).compareTo(controller.getScore(m1));
      }
      // if m2 is null then m1 is greater
      if (controller.getScore(m1) != null) {
        return -1;
      }
      return 1;
    }
  };
  final static Comparator[] MOVIE_ORDER = {TITLE_ORDER, RELEASE_ORDER, SCORE_ORDER};
  private List<Movie> movies;

  public class PostersAdapter extends BaseAdapter {
    public View getView(final int position, View convertView, ViewGroup parent) {
      LinearLayout linearLayout = new LinearLayout(mContext);
      linearLayout.setOrientation(LinearLayout.VERTICAL);
      ImageView i = new ImageView(mContext);
      TypedArray a = obtainStyledAttributes(android.R.styleable.Theme);
      int mGalleryItemBackground = a.getResourceId(android.R.styleable.Theme_galleryItemBackground, 0);
      a.recycle();
      i.setBackgroundResource(mGalleryItemBackground);
      final Movie movie = movies.get(position % movies.size());
      controller.prioritizeMovie(movie);
      TextView title = new TextView(mContext);
      title.setText(movie.getDisplayTitle());
      title.setTextSize(12);
      title
          .setTextAppearance(mContext, android.R.attr.textColorSecondary);
      title.setGravity(0x01);
      title.setEllipsize(TextUtils.TruncateAt.END);
      if (movie != null && controller.getPoster(movie).getBytes().length > 0) {
        i.setImageBitmap(BitmapFactory.decodeByteArray(controller
            .getPoster(movie).getBytes(), 0, controller.getPoster(movie).getBytes().length));
      } else {
        i.setImageDrawable(mContext.getResources().getDrawable(R.drawable.movies));
      }
      i.setScaleType(ImageView.ScaleType.FIT_XY);
      linearLayout.addView(i, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT, 135));
      linearLayout.addView(title, new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT,
                                                                LinearLayout.LayoutParams.WRAP_CONTENT));
      i.setOnClickListener(new OnClickListener() {
        public void onClick(View v) {
          // TODO Auto-generated method stub
          selection = position;
          v.setBackgroundResource(R.drawable.image_not_available);
          for (int i = 0; i < grid.getChildCount(); i++) {
            grid.getChildAt(i).setAnimation(animation);
          }
        }
      });
      linearLayout.setLayoutParams(new GridView.LayoutParams(100, 162));
      return linearLayout;
    }

    public final int getCount() {
      if (movies != null) {
        return Math.min(32, movies.size());
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
      notifyDataSetChanged();
    }
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    menu.add(0, MENU_SORT, 0, R.string.menu_movie_sort).setIcon(android.R.drawable.star_on);
    menu.add(0, MENU_SETTINGS, 0, R.string.menu_settings).setIcon(android.R.drawable.ic_menu_preferences).setIntent(
        new Intent(this, SettingsActivity.class))
        .setAlphabeticShortcut('s');
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    if (item.getItemId() == MENU_SORT) {
      NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog((NowPlayingActivity) mContext).setTitle(
          R.string.movies_select_sort_title).setKey(NowPlayingPreferenceDialog.Preference_keys.MOVIES_SORT)
          .setEntries(R.array.entries_movies_sort_preference).show();
      return true;
    }
    return false;
  }
}
