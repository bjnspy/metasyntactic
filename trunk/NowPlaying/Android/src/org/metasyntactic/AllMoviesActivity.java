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
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Parcelable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.Gallery;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.AdapterView.OnItemSelectedListener;

import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.views.CustomGallery;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.ArrayList;
import java.util.List;

public class AllMoviesActivity extends Activity {
    private NowPlayingActivity activity;
    private List<Movie> movies = new ArrayList<Movie>();
    

   

    private static Context mContext;
    public static final int MENU_SORT = 1;
    public static final int MENU_SETTINGS = 2;
    NowPlayingControllerWrapper mController;
    

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.movieview);
        activity = NowPlayingActivity.instance;
       mController = activity.getController();
        movies = activity.getMovies();
        mContext = this;
        mDetailAdapter = new DetailAdapter(this);
        mThumbnailAdapter = new ThumbnailAdapter(this);
        final CustomGallery detail = (CustomGallery) findViewById(R.id.detail);
        detail.setAdapter(mDetailAdapter);
     //   detail.setSelection(0);
        final Gallery thumbnail = (Gallery) findViewById(R.id.thumbnails);
        thumbnail.setAdapter(mThumbnailAdapter);
        thumbnail.setSoundEffectsEnabled(true);
      //  thumbnail.setSelection((detail.getSelectedItemPosition() + 1));
        OnItemSelectedListener listener = new OnItemSelectedListener(){

            public void onItemSelected(AdapterView<?> arg0, View arg1,
                    int position, long id) {
                // TODO Auto-generated method stub
                if (position ==0)
                  thumbnail.setSelection(position + 1);
                
            }

            public void onNothingSelected(AdapterView<?> arg0) {
                // TODO Auto-generated method stub
                
            }
            
        };
        detail.setOnItemSelectedListener(listener );
        
        OnItemSelectedListener thumblistener = new OnItemSelectedListener(){

            
            public void onItemSelected(AdapterView<?> arg0, View arg1,
                    int position, long id) {
                // TODO Auto-generated method stub
                if (position !=0)
                detail.setSelection(position-1);
                
            }

          
            public void onNothingSelected(AdapterView<?> arg0) {
                // TODO Auto-generated method stub
                
            }
            
        };
        thumbnail.setOnItemSelectedListener(thumblistener );
    }

    private static DetailAdapter mDetailAdapter;
    private static ThumbnailAdapter mThumbnailAdapter;

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        menu.add(0, MENU_SORT, 0, R.string.menu_movie_sort).setIcon(
                android.R.drawable.star_on);
        menu.add(0, MENU_SETTINGS, 0, R.string.menu_settings).setIcon(
                android.R.drawable.ic_menu_preferences).setIntent(
                new Intent(this, SettingsActivity.class))
                .setAlphabeticShortcut('s');
        return super.onCreateOptionsMenu(menu);
    }

    public INowPlaying getNowPlayingActivityContext() {
        return activity;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == MENU_SORT) {
            NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(
                    this.activity)
                    .setTitle(R.string.movies_select_sort_title)
                    .setKey(
                            NowPlayingPreferenceDialog.Preference_keys.MOVIES_SORT)
                    .setEntries(R.array.entries_movies_sort_preference).show();
            return true;
        }
        return false;
    }

    class DetailAdapter extends BaseAdapter {
        private Context mContext;
        private LayoutInflater mInflater;
        int  mGalleryItemBackground;
        public DetailAdapter(Context context) {
            mContext = context;
            // Cache the LayoutInflate to avoid asking for a new one each time.
            mInflater = LayoutInflater.from(context);
            TypedArray a = obtainStyledAttributes(android.R.styleable.Theme);
            mGalleryItemBackground = a.getResourceId(
                    android.R.styleable.Theme_galleryItemBackground, 0);
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
            convertView = mInflater.inflate(R.layout.moviesummary, null);
            holder = new MovieViewHolder();
            holder.toggleButton = (Button) convertView
                    .findViewById(R.id.togglebtn);
            holder.score = (Button) convertView.findViewById(R.id.score);
            
            holder.title = (TextView) convertView.findViewById(R.id.title);
            holder.poster = (ImageView) convertView.findViewById(R.id.poster);
            holder.rating = (TextView) convertView.findViewById(R.id.rating);
            holder.length = (TextView) convertView.findViewById(R.id.length);
            holder.genre = (TextView) convertView.findViewById(R.id.genre);
            
        //    holder.header = (TextView) convertView.findViewById(R.id.header);
            convertView.setTag(holder);
            Resources res = mContext.getResources();
            final Movie movie = movies.get(position);
            String headerText = MovieViewUtilities.getHeader(movies, position,
                    mController.getAllMoviesSelectedSortIndex());
         /*   if (headerText != null) {
                holder.header.setVisibility(1);
                holder.header.setText(headerText);
            } else {
                holder.header.setVisibility(-1);
                holder.header.setHeight(0);
                holder.divider.setVisibility(-1);
                holder.divider.setMaxHeight(0);
            }*/
            if (mController.getPoster(movie).getBytes().length > 0) {
                holder.poster.setImageBitmap(BitmapFactory.decodeByteArray(mController
                        .getPoster(movie).getBytes(), 0, mController
                        .getPoster(movie).getBytes().length));
            }
            holder.title.setText(movie.getDisplayTitle());
            CharSequence rating = MovieViewUtilities.formatRatings(movie
                    .getRating(), mContext.getResources());
            CharSequence length = MovieViewUtilities.formatLength(
                    movie.getLength(), mContext.getResources());
            holder.rating.setText(rating.toString());
            holder.length.setText(length.toString());
            String genres = movie.getGenres().toString();
            holder.genre.setText("Genre: " + genres.substring(1, genres.length()-1));
            holder.toggleButton
                    .setOnClickListener(new Button.OnClickListener() {
                        public void onClick(View v) {
                            Intent intent = new Intent();
                            intent.setClass(mContext,
                                    MovieDetailsActivity.class);
                            intent.putExtra("movie", (Parcelable) movie);
                            startActivity(intent);
                        }
                    });
            // Get and set scores text and background image
            Score score = mController.getScore(movie);
            int scoreValue = -1;
            if (score != null && !score.getValue().equals("")) {
                scoreValue = Integer.parseInt(score.getValue());
            } else {
            }
            ScoreType scoreType = mController.getScoreType();
            holder.score.setBackgroundDrawable(MovieViewUtilities
                    .formatScoreDrawable(scoreValue, scoreType, res));
            if (scoreValue != -1) {
                holder.score.setText(String.valueOf(scoreValue));
            }
          //  convertView.setBackgroundResource(mGalleryItemBackground);
            return convertView;
        }

        class MovieViewHolder {
            TextView header;
            Button score;
            TextView title;
            
            TextView rating;
            TextView length;
            TextView genre;
            
            Button toggleButton;
            ImageView poster;
        }

        public int getCount() {
            return movies.size();
        }

        public void refreshMovies(List<Movie> new_movies) {
            movies = new_movies;
            notifyDataSetChanged();
        }
    }
    
    class ThumbnailAdapter extends BaseAdapter {
        private Context mContext;
        private LayoutInflater mInflater;
        int mGalleryItemBackground;
        
        public ThumbnailAdapter(Context context) {
            mContext = context;
            // Cache the LayoutInflate to avoid asking for a new one each time.
            mInflater = LayoutInflater.from(context);
          
            TypedArray a = obtainStyledAttributes(android.R.styleable.Theme);
            mGalleryItemBackground = a.getResourceId(
                    android.R.styleable.Theme_galleryItemBackground, 0);
            a.recycle();
        }

        public Object getItem(int i) {
            return i;
        }

        public long getItemId(int i) {
            return i;
        }

        public View getView(int position, View convertView, ViewGroup viewGroup) {
           
            ImageView poster = new ImageView(mContext);
            poster.setLayoutParams(new Gallery.LayoutParams(100,130));
            // The preferred Gallery item background
            poster.setBackgroundResource(mGalleryItemBackground);
          
             Resources res = mContext.getResources();
            final Movie movie = movies.get(position);
           if (mController.getPoster(movie).getBytes().length > 0) {
                poster.setImageBitmap(BitmapFactory.decodeByteArray(mController
                        .getPoster(movie).getBytes(), 0, mController
                        .getPoster(movie).getBytes().length));
            } else {
                poster.setImageResource(R.drawable.image_not_available);
            }
           
            return poster;
        }

       

        public int getCount() {
            return movies.size();
        }

        public void refreshMovies(List<Movie> new_movies) {
            
            notifyDataSetChanged();
        }
    }

    public static void refresh(List<Movie> movies) {
        if (mDetailAdapter != null && mThumbnailAdapter != null) {
          mDetailAdapter.refreshMovies(movies);
          mThumbnailAdapter.refreshMovies(movies);
         
          
        }
    }
}
