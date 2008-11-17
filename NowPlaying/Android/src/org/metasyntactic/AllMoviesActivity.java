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
  private static List<Movie> movies = new ArrayList<Movie>();
  //private static Context mContext;
  public static final int MENU_SORT = 1;
  public static final int MENU_SETTINGS = 2;
  private int selection;

  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    public void onReceive(Context context, Intent intent) {
      refresh();
    }
  };

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.removeActivity(this);
    setContentView(R.layout.movieview);
    detailAdapter = new DetailAdapter();
    thumbnailAdapter = new ThumbnailAdapter();
  }

  private void setupView() {
    final CustomGallery detail = (CustomGallery) findViewById(R.id.detail);
    detail.setAdapter(detailAdapter);

    // detail.setSelection(0);
    final CustomGallery thumbnail = (CustomGallery) findViewById(R.id.thumbnails);
    thumbnail.setAdapter(thumbnailAdapter);
    thumbnail.setSoundEffectsEnabled(true);
    // thumbnail.setSelection((detail.getSelectedItemPosition() + 1));
    OnItemSelectedListener listener = new OnItemSelectedListener() {
      public void onItemSelected(AdapterView<?> arg0, View arg1, int position, long id) {
        if (thumbnail.getSelectedItemPosition() != position) {
          thumbnail.setSelection(position);
        }
        selection = position;
        Animation animation = AnimationUtils.loadAnimation(AllMoviesActivity.this, R.anim.slide_left);
        arg1.setAnimation(animation);
      }

      public void onNothingSelected(AdapterView<?> arg0) {
      }
    };
    detail.setOnItemSelectedListener(listener);
    OnItemClickListener thumblistener = new OnItemClickListener() {
      public void onItemClick(AdapterView<?> arg0, View arg1, int position, long id) {
        if (detail.getSelectedItemPosition() != position) {
          detail.setSelection(position);
        }
        Animation animation = AnimationUtils.loadAnimation(AllMoviesActivity.this, R.anim.fade_gallery_item);
        arg1.setAnimation(animation);
      }

      public void onNothingSelected(AdapterView<?> arg0) {
      }
    };
    thumbnail.setOnItemClickListener(thumblistener);
    selection = getIntent().getExtras().getInt("selection");
    detail.setSelection(selection, true);
    thumbnail.setSelection(selection, true);
    Button details = (Button) findViewById(R.id.details);
    details.setOnClickListener(new OnClickListener() {
      public void onClick(View arg0) {
        final Movie movie = movies.get(selection);

        Intent intent = new Intent();
        intent.setClass(AllMoviesActivity.this, MovieDetailsActivity.class);
        intent.putExtra("movie", (Parcelable) movie);
        startActivity(intent);
      }
    });
    Button showtimes = (Button) findViewById(R.id.showtimes);
    showtimes.setOnClickListener(new OnClickListener() {
      public void onClick(View arg0) {
        final Movie movie = movies.get(selection);

        Intent intent = new Intent();
        intent.setClass(AllMoviesActivity.this, ShowtimesActivity.class);
        intent.putExtra("movie", (Parcelable) movie);
        startActivity(intent);
      }
    });
  }

  @Override
  protected void onResume() {
    super.onResume();

    registerReceiver(broadcastReceiver, new IntentFilter(Application.NOW_PLAYING_CHANGED_INTENT));
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override
  protected void onPause() {
    unregisterReceiver(broadcastReceiver);
    super.onPause();
  }

  private static DetailAdapter detailAdapter;
  private static ThumbnailAdapter thumbnailAdapter;

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
      NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(AllMoviesActivity.this).setTitle(
          R.string.movies_select_sort_title)
          .setKey(NowPlayingPreferenceDialog.Preference_keys.MOVIES_SORT)
          .setEntries(R.array.entries_movies_sort_preference);
      builder.show();
      return true;
    }
    return false;
  }

  class DetailAdapter extends BaseAdapter {
    private LayoutInflater inflater;

    public DetailAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(getContext());
      TypedArray a = obtainStyledAttributes(android.R.styleable.Theme);
      a.getResourceId(android.R.styleable.Theme_galleryItemBackground, 0);
      a.recycle();
    }

    public Object getItem(int i) {
      return i;
    }

    public long getItemId(int i) {
      return i;
    }

    public View getView(int position, View convertView, ViewGroup viewGroup) {
      MovieViewHolder holder;
      convertView = inflater.inflate(R.layout.moviesummary, null);
      holder = new MovieViewHolder();
      holder.score = (Button) convertView.findViewById(R.id.score);
      holder.title = (TextView) convertView.findViewById(R.id.title);
      holder.poster = (ImageView) convertView.findViewById(R.id.poster);
      holder.rating = (TextView) convertView.findViewById(R.id.rating);
      holder.length = (TextView) convertView.findViewById(R.id.length);
      holder.genre = (TextView) convertView.findViewById(R.id.genre);
      holder.cast = (TextView) convertView.findViewById(R.id.cast);
      holder.scoreLbl = (TextView) convertView.findViewById(R.id.scorelbl);
      holder.title.setEllipsize(TextUtils.TruncateAt.END);
      convertView.setTag(holder);
      Resources res = getContext().getResources();
      final Movie movie = movies.get(position);
      final byte[] bytes = NowPlayingControllerWrapper.getPoster(movie).getBytes();
      if (bytes.length > 0) {
        holder.poster.setImageBitmap(BitmapFactory.decodeByteArray(bytes, 0, bytes.length));
        holder.poster.setBackgroundResource(R.drawable.image_frame);
      }
      holder.title.setText(movie.getDisplayTitle());
      CharSequence rating = MovieViewUtilities.formatRatings(movie.getRating(), getContext().getResources());
      CharSequence length = MovieViewUtilities.formatLength(movie.getLength(), getContext().getResources());
      holder.rating.setText(rating.toString());
      holder.length.setText(length.toString());
      if (movie.getGenres() != null && movie.getGenres().size() > 0) {
        String genres = movie.getGenres().toString();
        holder.genre.setText(genres.substring(1, genres.length() - 1));
      } else {
        holder.genre.setText("Unknown");
      }
      holder.cast.setEllipsize(TextUtils.TruncateAt.END);
      if (movie.getCast() != null && movie.getCast().size() > 0) {
        String cast = movie.getCast().toString();
        holder.cast.setText(cast.substring(1, cast.length() - 1));
      } else {
        holder.cast.setText("Unknown");
      }
      // Get and set scores text and background image
      Score score = NowPlayingControllerWrapper.getScore(movie);
      int scoreValue = -1;
      if (score != null && !score.getValue().equals("")) {
        scoreValue = Integer.parseInt(score.getValue());
      } else {
      }
      ScoreType scoreType = NowPlayingControllerWrapper.getScoreType();
      holder.score.setBackgroundDrawable(MovieViewUtilities.formatScoreDrawable(scoreValue, scoreType, res));
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
      return movies.size();
    }

    public void refreshMovies() {
      notifyDataSetChanged();
    }
  }

  class ThumbnailAdapter extends BaseAdapter {
    public ThumbnailAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      TypedArray a = obtainStyledAttributes(android.R.styleable.Theme);
      a.getResourceId(android.R.styleable.Theme_galleryItemBackground, 0);
      a.recycle();
    }

    public Object getItem(int i) {
      return i;
    }

    public long getItemId(int i) {
      return i;
    }

    public View getView(int position, View convertView, ViewGroup viewGroup) {
      LinearLayout layout = new LinearLayout(getContext());
      layout.setOrientation(LinearLayout.VERTICAL);
      ImageView i = new ImageView(getContext());
      TypedArray a = obtainStyledAttributes(android.R.styleable.Theme);
      int galleryItemBackground = a.getResourceId(android.R.styleable.Theme_galleryItemBackground, 0);
      a.recycle();
      i.setBackgroundResource(galleryItemBackground);
      final Movie movie = movies.get(position % movies.size());
      TextView title = new TextView(getContext());
      title.setText(movie.getDisplayTitle());
      title.setTextSize(12);
      title.setWidth(100);
      title.setSingleLine(false);
      title.setTextAppearance(getContext(), android.R.attr.textColorSecondary);
      title.setGravity(0x01);
      title.setEllipsize(TextUtils.TruncateAt.END);

      byte[] bytes = NowPlayingControllerWrapper.getPoster(movie).getBytes();
      if (bytes.length > 0) {
        i.setImageBitmap(BitmapFactory.decodeByteArray(bytes, 0, bytes.length));
      } else {
        i.setImageDrawable(getContext().getResources().getDrawable(R.drawable.movies));
      }
      i.setScaleType(ImageView.ScaleType.FIT_XY);
      layout.addView(i, new LinearLayout.LayoutParams(100, 120));
      LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.FILL_PARENT,
                                                                       LinearLayout.LayoutParams.WRAP_CONTENT);
      layout.addView(title, params);
      //   layout.setLayoutParams(new GridView.LayoutParams(100, 160));
      //   linearLayout
      //       .setBackgroundResource(android.R.drawable.gallery_thumb);
      return layout;
    }

    public int getCount() {
      return movies.size();
    }

    public void refreshMovies() {
      notifyDataSetChanged();
    }
  }

  public void refresh() {
    movies = NowPlayingControllerWrapper.getMovies();
    Comparator<Movie> comparator = NowPlayingActivity.MOVIE_ORDER
        .get(NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex());
    Collections.sort(movies, comparator);
    if (detailAdapter != null && thumbnailAdapter != null) {
      detailAdapter.refreshMovies();
      thumbnailAdapter.refreshMovies();
    }
  }

  public Context getContext() {
    return this;
  }
}
