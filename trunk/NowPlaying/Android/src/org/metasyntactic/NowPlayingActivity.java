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
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.View.OnClickListener;

import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.animation.Animation.AnimationListener;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;

import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.ui.GlobalActivityIndicator;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

public class NowPlayingActivity extends Activity implements INowPlaying {
    private static final int MENU_SORT = 1;
    private static final int MENU_THEATER = 2;
    private static final int MENU_UPCOMING = 3;
    private static final int MENU_SETTINGS = 4;
    private GridView grid;
    private Intent intent;
    private Animation animation;
    private int selection;
    private PostersAdapter postersAdapter;
    private boolean gridAnimationEnded;
    private boolean isPrioritized;
    private boolean isGridSetup;
    private List<Movie> movies;
    private BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            refresh();
        }
    };

    /** Updates display of the list of movies. */
    public void refresh() {
        // TODO Auto-generated method stub
        List<Movie> tmpMovies;
        tmpMovies = NowPlayingControllerWrapper.getMovies();
        // sort movies according to the default sort preference.
        Comparator comparator = MOVIE_ORDER.get(NowPlayingControllerWrapper
                .getAllMoviesSelectedSortIndex());
        Collections.sort(tmpMovies, comparator);
        movies = new ArrayList<Movie>();
        movies.addAll(tmpMovies);
        if (!isPrioritized) {
            for (int i = 0; i < Math.min(6, movies.size()); i++) {
                NowPlayingControllerWrapper.prioritizeMovie(movies.get(i));
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

    public List<Movie> getMovies() {
        return movies;
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        // TODO Auto-generated method stub
        return super.onTouchEvent(event);
    }

    public Context getContext() {
        return this;
    }

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Request the progress bar to be shown in the title
        requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
        GlobalActivityIndicator.addActivity(NowPlayingActivity.this);
        setContentView(R.layout.progressbar_1);
        NowPlayingControllerWrapper.addActivity(this);
    }

    @Override
    protected void onDestroy() {
        if (broadcastReceiver != null) {
            unregisterReceiver(broadcastReceiver);
            broadcastReceiver = null;
        }
        NowPlayingControllerWrapper.removeActivity(this);
        super.onDestroy();
    }

    @Override
    protected void onResume() {
        super.onResume();
        registerReceiver(broadcastReceiver, new IntentFilter(
                Application.NOW_PLAYING_CHANGED_INTENT));
        if (movies != null && movies.size() > 0) {
            setup();
            isGridSetup = true;
        }
        if (postersAdapter != null) {
            postersAdapter.refreshMovies();
        }
    }

    private void setup() {
        setContentView(R.layout.moviegrid_anim);
        grid = (GridView) findViewById(R.id.grid);
        int maxpagecount = (movies.size() - 1) / 9;
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
        postersAdapter = new PostersAdapter(NowPlayingActivity.this);
        grid.setAdapter(postersAdapter);
        intent = new Intent();
        intent.setClass(NowPlayingActivity.this, AllMoviesActivity.class);
        animation = AnimationUtils.loadAnimation(NowPlayingActivity.this,
                R.anim.fade_reverse);
        animation.setAnimationListener(new AnimationListener() {
            public void onAnimationEnd(Animation animation) {
                // TODO Auto-generated method stub
                grid.setVisibility(View.GONE);
                intent.putExtra("selection", selection);
                startActivity(intent);
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
        if (broadcastReceiver != null) {
            unregisterReceiver(broadcastReceiver);
            broadcastReceiver = null;
        }
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
            if (m1.getReleaseDate() != null) d1 = m1.getReleaseDate();
            if (m2.getReleaseDate() != null) d2 = m2.getReleaseDate();
            return d2.compareTo(d1);
        }
    };
    final static Comparator<Movie> SCORE_ORDER = new Comparator<Movie>() {
        public int compare(Movie m1, Movie m2) {
            Integer value1 = 0;
            Integer value2 = 0;
            Score s1 = NowPlayingControllerWrapper.getScore(m1);
            Score s2 = NowPlayingControllerWrapper.getScore(m2);
            if (s1 != null) {
                value1 = Integer.valueOf(s1.getValue());
            }
            if (s2 != null) {
                value2 = Integer.valueOf(s2.getValue());
            }
            if (value1 == value2)
                return m1.getDisplayTitle().compareTo(m2.getDisplayTitle());
            else
                return value2 - value1;
        }
    };
    final static List<Comparator<Movie>> MOVIE_ORDER = Arrays.asList(
            TITLE_ORDER, RELEASE_ORDER, SCORE_ORDER);

    private class PostersAdapter extends BaseAdapter {
        private LayoutInflater mInflater;

        public PostersAdapter(Context context) {
            // Cache the LayoutInflate to avoid asking for a new one each time.
            mInflater = LayoutInflater.from(context);
        }

        public View getView(final int position, View convertView,
                ViewGroup parent) {
            // to findViewById() on each row.
            final ViewHolder holder;
            int pagecount = position / 9;
            Log.i("getView", String.valueOf(pagecount));
            // When convertView is not null, we can reuse it directly, there is
            // no need
            // to reinflate it. We only inflate a new View when the convertView
            // supplied
            // by ListView is null.
            if (convertView == null) {
                convertView = mInflater.inflate(R.layout.moviegrid_item, null);
                // Creates a ViewHolder and store references to the two children
                // views
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
            final byte[] bytes = NowPlayingControllerWrapper.getPoster(movie);
            if (bytes.length > 0) {
                Bitmap bitmap = BitmapFactory.decodeByteArray(bytes, 0,
                        bytes.length);
                holder.poster.setImageBitmap(bitmap);
            } else {
                holder.poster.setImageDrawable(NowPlayingActivity.this
                        .getResources().getDrawable(R.drawable.movies));
            }
            convertView.setOnClickListener(new OnClickListener() {
                public void onClick(View v) {
                    // TODO Auto-generated method stub
                    selection = position;
                    int i = 0;
                    View child = grid.getChildAt(i);
                    while (child != null
                            && child.getVisibility() == View.VISIBLE) {
                        child.startAnimation(animation);
                        i++;
                        child = grid.getChildAt(i);
                    }
                }
            });
            holder.title.setBackgroundDrawable(NowPlayingActivity.this.getResources().getDrawable(R.drawable.gallery_background_1));
            return convertView;
        }

        class ViewHolder {
            TextView title;
            ImageView poster;
        }

        public final int getCount() {
            if (movies != null) {
                return Math.min(100, movies.size());
            } else
                return 0;
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
        menu.add(0, MENU_SORT, 0, R.string.menu_movie_sort).setIcon(
                android.R.drawable.star_on);
        menu.add(0, MENU_THEATER, 0, R.string.menu_theater).setIcon(
                R.drawable.theatres);
        menu.add(0, MENU_UPCOMING, 0, R.string.menu_upcoming).setIcon(
                R.drawable.upcoming);
        menu.add(0, MENU_SETTINGS, 0, R.string.menu_settings).setIcon(
                android.R.drawable.ic_menu_preferences).setIntent(
                new Intent(this, SettingsActivity.class))
                .setAlphabeticShortcut('s');
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == MENU_SORT) {
            NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(
                    (NowPlayingActivity) NowPlayingActivity.this).setTitle(
                    R.string.movies_select_sort_title).setKey(
                    NowPlayingPreferenceDialog.Preference_keys.MOVIES_SORT)
                    .setEntries(R.array.entries_movies_sort_preference).show();
            return true;
        }
        if (item.getItemId() == MENU_THEATER) {
            Intent intent = new Intent();
            intent.setClass(NowPlayingActivity.this, AllTheatersActivity.class);
            startActivity(intent);
            return true;
        }
        return false;
    }
}
