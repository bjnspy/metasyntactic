// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package org.metasyntactic;

import android.app.Activity;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.utilities.MovieViewUtilities;

import java.util.ArrayList;

public class MovieDetailsActivity extends Activity {
  /** Called when the activity is first created. */
  NowPlayingControllerWrapper controller;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.moviedetails);
        final Movie movie = this.getIntent().getExtras().getParcelable("movie");
        controller = NowPlayingActivity_old.instance.getController();
        TextView title = (TextView) findViewById(R.id.header);
        ImageView poster = (ImageView) findViewById(R.id.poster);
        TextView desc1 = (TextView) findViewById(R.id.desc1);
        TextView desc2 = (TextView) findViewById(R.id.desc2);
        TextView rating_length = (TextView) findViewById(R.id.rated_length);
        Button trailerbtn = (Button) findViewById(R.id.trailerbtn);
        Button imdbbtn = (Button) findViewById(R.id.imdbbtn);
        Button reviewsbtn = (Button) findViewById(R.id.reviewsbtn);
        title.setText(movie.getDisplayTitle());
        if (controller.getPoster(movie).getBytes().length > 0) {
            poster.setImageBitmap(BitmapFactory.decodeByteArray(controller
                .getPoster(movie).getBytes(), 0, controller.getPoster(movie)
                .getBytes().length));

    String synopsis = controller.getSynopsis(movie);
    if (synopsis.length() > 0) {
      // hack to display text on left and bottom or poster
      if (synopsis.length() > 240) {
        String desc1_text = synopsis.substring(0, synopsis.lastIndexOf(" ", 250));
        String desc2_text = synopsis.substring(synopsis.lastIndexOf(" ", 250));
        desc1.setText(desc1_text);
        desc2.setText(desc2_text);
      } else {
        desc1.setText(synopsis);
      }
    }
  
        CharSequence rating =
            MovieViewUtilities.formatRatings(movie.getRating(),
                NowPlayingActivity_old.instance.getResources());
        CharSequence length =
            MovieViewUtilities.formatLength(movie.getLength(),
                NowPlayingActivity_old.instance.getResources());
        rating_length.setText(rating.toString() + " " + length.toString());
        trailerbtn.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                String trailer_url = null;
                if (controller.getTrailers(movie).size() > 0) {
                    trailer_url = controller.getTrailers(movie).get(0);
                }
                if (trailer_url != null) {
                    Intent intent = new Intent();
                    intent.putExtra("trailer_url", trailer_url);
                    intent.setClass(MovieDetailsActivity.this,
                        VideoViewActivity.class);
                    startActivity(intent);
                } else {
                    Toast.makeText(MovieDetailsActivity.this,
                        "This movie's trailer is not available.",
                        Toast.LENGTH_SHORT).show();
                }
            }
        });
        imdbbtn.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                String imdb_url = null;
                imdb_url = controller.getImdbAddress(movie);
                if (imdb_url != null) {
                    Intent intent = new Intent();
                    intent.putExtra("imdb_url", imdb_url);
                    intent.setClass(MovieDetailsActivity.this,
                        WebViewActivity.class);
                    startActivity(intent);
                } else {
                    Toast.makeText(MovieDetailsActivity.this,
                        "This movie's IMDB information is not available.",
                        Toast.LENGTH_SHORT).show();
                }
            }
        });
        reviewsbtn.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                ArrayList<Review> reviews =
                    (ArrayList) controller.getReviews(movie);
                if (reviews != null && reviews.size() > 0) {
                    Intent intent = new Intent();
                    intent.putParcelableArrayListExtra("reviews", reviews);
                    intent.setClass(MovieDetailsActivity.this,
                        AllReviewsActivity.class);
                    startActivity(intent);
                } else {
                    Toast.makeText(MovieDetailsActivity.this,
                        "This movie's reviews are not yet available.",
                        Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    imdbbtn.setOnClickListener(new OnClickListener() {
      public void onClick(View v) {
        String imdb_url = null;
        imdb_url = controller.getImdbAddress(movie);
        if (imdb_url != null) {
          Intent intent = new Intent();
          intent.putExtra("imdb_url", imdb_url);
          intent.setClass(MovieDetailsActivity.this, WebViewActivity.class);
          startActivity(intent);
        } else {
          Toast.makeText(MovieDetailsActivity.this, "This movie's IMDB information is not available.",
                         Toast.LENGTH_SHORT).show();
        }
      }
    });
    reviewsbtn.setOnClickListener(new OnClickListener() {
      public void onClick(View v) {
        ArrayList<Review> reviews = (ArrayList) controller
            .getReviews(movie);
        if (reviews != null && reviews.size() > 0) {
          Intent intent = new Intent();
          intent.putParcelableArrayListExtra("reviews", reviews);
          intent.setClass(MovieDetailsActivity.this, AllReviewsActivity.class);
          startActivity(intent);
        } else {
          Toast.makeText(MovieDetailsActivity.this, "This movie's reviews are not yet available.",
                         Toast.LENGTH_SHORT).show();
        }
      }
    });
  }


  @Override
  protected void onResume() {
    // TODO Auto-generated method stub
    super.onResume();
  }
}
