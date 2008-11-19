/*
 * Copyright (C) 2007 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package org.metasyntactic;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Parcelable;
import android.text.TextUtils;
import android.view.*;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.*;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemSelectedListener;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.views.CustomGallery;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class AllMoviesActivity extends Activity implements INowPlaying {
  public static final int MENU_SORT = 1;
  public static final int MENU_SETTINGS = 2;
  private int selection;
 
  private List<Movie> movies = new ArrayList<Movie>();
  private DetailAdapter detailAdapter;
  private ThumbnailAdapter thumbnailAdapter;

  private BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(final Context context, final Intent intent) {
      refresh();
    }
  };

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.movieview);
    NowPlayingControllerWrapper.addActivity(this);
    detailAdapter = new DetailAdapter();
    thumbnailAdapter = new ThumbnailAdapter();
    setupView();
  }

  private void setupView() {
    final CustomGallery detail = (CustomGallery) findViewById(R.id.detail);
    detail.setAdapter(detailAdapter);
    // detail.setSelection(0);
    final CustomGallery thumbnail = (CustomGallery) findViewById(R.id.thumbnails);
    thumbnail.setAdapter(thumbnailAdapter);
    thumbnail.setSoundEffectsEnabled(true);
    // thumbnail.setSelection((detail.getSelectedItemPosition() + 1));
    final OnItemSelectedListener listener = new OnItemSelectedListener() {
      public void onItemSelected(final AdapterView<?> arg0, final View arg1, final int position, final long id) {
        // TODO Auto-generated method stub
        if (thumbnail.getSelectedItemPosition() != position) {
          thumbnail.setSelection(position);
        }
        AllMoviesActivity.this.selection = position;
        final Animation animation = AnimationUtils.loadAnimation(AllMoviesActivity.this, R.anim.slide_left);
        arg1.setAnimation(animation);
      }

      public void onNothingSelected(final AdapterView<?> arg0) {
        // TODO Auto-generated method stub
      }
    };
    detail.setOnItemSelectedListener(listener);
    final OnItemClickListener thumblistener = new OnItemClickListener() {
      public void onItemClick(final AdapterView<?> arg0, final View arg1, final int position, final long id) {
        if (detail.getSelectedItemPosition() != position) {
          detail.setSelection(position);
        }
        final Animation animation = AnimationUtils.loadAnimation(AllMoviesActivity.this, R.anim.fade_gallery_item);
        arg1.setAnimation(animation);
      }
    };
    thumbnail.setOnItemClickListener(thumblistener);
    this.selection = getIntent().getExtras().getInt("selection");
    detail.setSelection(this.selection, true);
    thumbnail.setSelection(this.selection, true);
    final Button details = (Button) findViewById(R.id.details);
    details.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        final Movie movie = AllMoviesActivity.this.movies.get(AllMoviesActivity.this.selection);
        final Intent intent = new Intent();
        intent.setClass(AllMoviesActivity.this, MovieDetailsActivity.class);
        intent.putExtra("movie", (Parcelable) movie);
        startActivity(intent);
      }
    });
    final Button showtimes = (Button) findViewById(R.id.showtimes);
    showtimes.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        final Movie movie = AllMoviesActivity.this.movies.get(AllMoviesActivity.this.selection);
        final Intent intent = new Intent();
        intent.setClass(AllMoviesActivity.this, ShowtimesActivity.class);
        intent.putExtra("movie", (Parcelable) movie);
        startActivity(intent);
      }
    });
  }

  @Override
  protected void onResume() {
    super.onResume();
    registerReceiver(this.broadcastReceiver, new IntentFilter(Application.NOW_PLAYING_CHANGED_INTENT));
  }

  @Override
  protected void onDestroy() {
    if (this.broadcastReceiver != null) {
      unregisterReceiver(this.broadcastReceiver);
      this.broadcastReceiver = null;
    }
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override
  protected void onPause() {
    if (this.broadcastReceiver != null) {
      unregisterReceiver(this.broadcastReceiver);
      this.broadcastReceiver = null;
    }
    super.onPause();
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MENU_SORT, 0, R.string.menu_movie_sort).setIcon(android.R.drawable.star_on);
    menu.add(0, MENU_SETTINGS, 0, R.string.menu_settings)
        .setIcon(android.R.drawable.ic_menu_preferences)
        .setIntent(new Intent(this, SettingsActivity.class))
        .setAlphabeticShortcut('s');
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {
    if (item.getItemId() == MENU_SORT) {
      final NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(AllMoviesActivity.this).setTitle(
          R.string.movies_select_sort_title).setKey(NowPlayingPreferenceDialog.Preference_keys.MOVIES_SORT)
          .setEntries(R.array.entries_movies_sort_preference).show();
      return true;
    }
    return false;
  }

  class DetailAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public DetailAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(getContext());
      final TypedArray a = obtainStyledAttributes(android.R.styleable.Theme);
      a.getResourceId(android.R.styleable.Theme_galleryItemBackground, 0);
      a.recycle();
    }

    public Object getItem(final int i) {
      return i;
    }

    public long getItemId(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      MovieViewHolder holder;
      convertView = this.inflater.inflate(R.layout.moviesummary, null);
      holder = new MovieViewHolder();
      holder.score = (Button) convertView.findViewById(R.id.score);
      holder.title = (TextView) convertView.findViewById(R.id.title);
      holder.poster = (ImageView) convertView.findViewById(R.id.poster);
      holder.rating = (TextView) convertView.findViewById(R.id.rating);
      holder.length = (TextView) convertView.findViewById(R.id.length);
      holder.genre = (TextView) convertView.findViewById(R.id.genre);
      holder.cast = (TextView) convertView.findViewById(R.id.cast);
      holder.scoreLbl = (TextView) convertView
          .findViewById(R.id.scorelbl);
      holder.title.setEllipsize(TextUtils.TruncateAt.END);
      convertView.setTag(holder);
      final Resources res = getContext().getResources();
      final Movie movie = AllMoviesActivity.this.movies.get(position);
      final byte[] bytes = NowPlayingControllerWrapper.getPoster(movie)
          .getBytes();
      if (bytes.length > 0) {
        holder.poster.setImageBitmap(BitmapFactory.decodeByteArray(bytes, 0, bytes.length));
        holder.poster.setBackgroundResource(R.drawable.image_frame);
      }
      holder.title.setText(movie.getDisplayTitle());
      final CharSequence rating = MovieViewUtilities.formatRatings(movie
          .getRating(), getContext().getResources());
      final CharSequence length = MovieViewUtilities.formatLength(movie
          .getLength(), getContext().getResources());
      holder.rating.setText(rating.toString());
      holder.length.setText(length.toString());
      holder.genre.setText(MovieViewUtilities.formatListToString(movie
          .getGenres()));
      holder.cast.setEllipsize(TextUtils.TruncateAt.END);
      holder.cast.setText(MovieViewUtilities.formatListToString(movie
          .getCast()));
      // Get and set scores text and background image
      final Score score = NowPlayingControllerWrapper.getScore(movie);
      int scoreValue = -1;
      if (score != null && !score.getValue().equals("")) {
        scoreValue = Integer.parseInt(score.getValue());
      } else {
      }
      final ScoreType scoreType = NowPlayingControllerWrapper
          .getScoreType();
      holder.score.setBackgroundDrawable(MovieViewUtilities
          .formatScoreDrawable(scoreValue, scoreType, res));
      if (scoreValue != -1) {
        holder.scoreLbl.setText(String.valueOf(scoreValue) + "%");
      } else {
        holder.scoreLbl.setText("Unknown");
      }
      return convertView;
    }

    class MovieViewHolder {
      TextView header;
      Button score;
      TextView title;
      TextView rating;
      TextView length;
      TextView genre;
      ImageView poster;
      TextView scoreLbl;
      TextView cast;
    }

    public int getCount() {
      return AllMoviesActivity.this.movies.size();
    }

    public void refreshMovies() {
      notifyDataSetChanged();
    }
  }

  class ThumbnailAdapter extends BaseAdapter {
    public ThumbnailAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      LayoutInflater inflater = LayoutInflater.from(AllMoviesActivity.this);
      final TypedArray a = obtainStyledAttributes(android.R.styleable.Theme);
      a.recycle();
    }

    public Object getItem(final int i) {
      return i;
    }

    public long getItemId(final int i) {
      return i;
    }

    public View getView(final int position, final View convertView, final ViewGroup viewGroup) {
      final LinearLayout layout = new LinearLayout(AllMoviesActivity.this);
      layout.setOrientation(LinearLayout.VERTICAL);
      final ImageView i = new ImageView(AllMoviesActivity.this);
      final TypedArray a = obtainStyledAttributes(android.R.styleable.Theme);
      final int galleryItemBackground = a.getResourceId(android.R.styleable.Theme_galleryItemBackground, 0);
      a.recycle();
      i.setBackgroundResource(galleryItemBackground);
      final Movie movie = AllMoviesActivity.this.movies.get(position % AllMoviesActivity.this.movies.size());
      final byte[] bytes = NowPlayingControllerWrapper.getPoster(movie)
          .getBytes();
      if (bytes.length > 0) {
        i.setImageBitmap(BitmapFactory.decodeByteArray(bytes, 0, bytes.length));
      } else {
        i.setImageDrawable(getContext().getResources().getDrawable(R.drawable.movies));
      }
      i.setScaleType(ImageView.ScaleType.FIT_XY);
      layout.addView(i, new LinearLayout.LayoutParams(95, 130));
      return layout;
    }

    public int getCount() {
      return AllMoviesActivity.this.movies.size();
    }

    public void refreshMovies() {
      notifyDataSetChanged();
    }
  }

  public Context getContext() {
    return this;
  }

  public void refresh() {
    this.movies = NowPlayingControllerWrapper.getMovies();
    final Comparator<Movie> comparator = NowPlayingActivity.MOVIE_ORDER
        .get(NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex());
    Collections.sort(this.movies, comparator);
    if (detailAdapter != null && thumbnailAdapter != null) {
      detailAdapter.refreshMovies();
      thumbnailAdapter.refreshMovies();
    }
  }
}
