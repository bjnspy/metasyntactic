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

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.*;
import org.metasyntactic.data.Review;

import java.util.List;

public class AllReviewsActivity extends ListActivity {
  private List<Review> reviews;

  @Override
  protected void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.addActivity(this);
    this.reviews = getIntent().getParcelableArrayListExtra("reviews");
    setListAdapter(new ReviewsAdapter(this));
  }

  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  private class ReviewsAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public ReviewsAdapter(final Context context) {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(context);
    }

    public Object getItem(final int i) {
      return i;
    }

    public long getItemId(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      MovieViewHolder holder;
      convertView = this.inflater.inflate(R.layout.reviewview, null);
      holder = new MovieViewHolder();
      holder.toggleButton = (Button) convertView.findViewById(R.id.togglebtn);
      holder.score = (Button) convertView.findViewById(R.id.score);
      holder.author = (TextView) convertView.findViewById(R.id.author);
      holder.source = (TextView) convertView.findViewById(R.id.source);
      holder.desc = (TextView) convertView.findViewById(R.id.desc);
      convertView.setTag(holder);
      final Review review = AllReviewsActivity.this.reviews.get(position);
      holder.author.setText(review.getAuthor());
      holder.source.setText(review.getSource());
      holder.desc.setText(review.getText());
      holder.score.setText(String.valueOf(review.getScore()));
      holder.toggleButton.setOnClickListener(new OnClickListener() {
        public void onClick(final View v) {
          String review_url = null;
          review_url = review.getLink();
          if (review_url != null) {
            final Intent intent = new Intent();
            intent.putExtra("url", review_url);
            intent.setClass(AllReviewsActivity.this, WebViewActivity.class);
            startActivity(intent);
          } else {
            Toast.makeText(AllReviewsActivity.this, "This review article is not available.", Toast.LENGTH_SHORT).show();
          }
        }
      });
      return convertView;
    }

    class MovieViewHolder {
      Button score;
      TextView author;
      TextView source;
      TextView desc;
      Button toggleButton;
      ImageView divider;
    }

    public int getCount() {
      return AllReviewsActivity.this.reviews.size();
    }
  }
}
