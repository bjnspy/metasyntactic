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
import android.content.res.Resources;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.*;
import org.metasyntactic.data.Review;

import java.util.List;

public class AllReviewsActivity extends ListActivity {
  private static Context context;

  private List<Review> reviews;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    // TODO Auto-generated method stub
    super.onCreate(savedInstanceState);
    context = this;
    reviews = getIntent().getParcelableArrayListExtra("reviews");
    this.setListAdapter(new ReviewsAdapter(this));
  }

  private class ReviewsAdapter extends BaseAdapter {
    private final Context context;
    private final LayoutInflater inflater;

    public ReviewsAdapter(Context context) {
      this.context = context;
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(context);
    }

    public Object getItem(int i) {
      return i;
    }

    public long getItemId(int i) {
      return i;
    }

    public View getView(int position, View convertView, ViewGroup viewGroup) {
      MovieViewHolder holder;
      convertView = inflater.inflate(R.layout.reviewview, null);
      holder = new MovieViewHolder();
      holder.toggleButton = (Button) convertView
          .findViewById(R.id.togglebtn);
      holder.score = (Button) convertView.findViewById(R.id.score);
      holder.author = (TextView) convertView.findViewById(R.id.author);
      holder.source = (TextView) convertView.findViewById(R.id.source);
      holder.desc = (TextView) convertView.findViewById(R.id.desc);
      convertView.setTag(holder);
      Resources res = context.getResources();
      final Review review = reviews.get(position);
      holder.author.setText(review.getAuthor());
      holder.source.setText(review.getSource());
      holder.desc.setText(review.getText());
      holder.score.setText(String.valueOf(review.getScore()));
      holder.toggleButton.setOnClickListener(new OnClickListener() {
        public void onClick(View v) {
          String review_url = null;
          review_url = review.getLink();
          if (review_url != null) {
            Intent intent = new Intent();
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
      return reviews.size();
    }
  }
}
