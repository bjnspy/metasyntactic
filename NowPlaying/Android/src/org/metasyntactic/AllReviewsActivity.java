package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.List;

/** @author mjoshi@google.com (Megha Joshi) */
public class AllReviewsActivity extends ListActivity {
    private List<Review> reviews;
    private static Context mContext;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        mContext = this;
        reviews = getIntent().getParcelableArrayListExtra("reviews");
        this.setListAdapter(new ReviewsAdapter(this));
    }

    class ReviewsAdapter extends BaseAdapter {
        private Context mContext;
        private LayoutInflater mInflater;

        public ReviewsAdapter(Context context) {
            mContext = context;
            // Cache the LayoutInflate to avoid asking for a new one each time.
            mInflater = LayoutInflater.from(context);
        }

        public Object getItem(int i) {
            return i;
        }

        public long getItemId(int i) {
            return i;
        }

        public View getView(int position, View convertView, ViewGroup viewGroup) {
            MovieViewHolder holder;
            convertView = mInflater.inflate(R.layout.reviewview, null);
            holder = new MovieViewHolder();
            holder.toggleButton = (Button) convertView
                    .findViewById(R.id.togglebtn);
            holder.score = (Button) convertView.findViewById(R.id.score);
            holder.author = (TextView) convertView.findViewById(R.id.author);
            holder.source = (TextView) convertView.findViewById(R.id.source);
            holder.desc = (TextView) convertView.findViewById(R.id.desc);
            convertView.setTag(holder);
            Resources res = mContext.getResources();
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
                        intent.setClass(AllReviewsActivity.this,
                                WebViewActivity.class);
                        startActivity(intent);
                    } else {
                        Toast.makeText(AllReviewsActivity.this,
                                "This review article is not available.",
                                Toast.LENGTH_SHORT).show();
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
