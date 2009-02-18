package org.metasyntactic.activities;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.data.Review;
import org.metasyntactic.utilities.MovieViewUtilities;

import java.util.List;

public class AllReviewsActivity extends ListActivity {
  private List<Review> reviews;

  @Override
  protected void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Log.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);
    this.reviews = getIntent().getParcelableArrayListExtra("reviews");
    setListAdapter(new ReviewsAdapter(this));
  }

  @Override protected void onResume() {
    super.onResume();
    Log.i(getClass().getSimpleName(), "onResume");
  }

  @Override protected void onPause() {
    super.onPause();
    Log.i(getClass().getSimpleName(), "onPause");
  }

  @Override
  protected void onDestroy() {
    Log.i(getClass().getSimpleName(), "onDestroy");

    NowPlayingControllerWrapper.removeActivity(this);
    MovieViewUtilities.cleanUpDrawables();
    super.onDestroy();
  }

  @Override public Object onRetainNonConfigurationInstance() {
    Log.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    final Object result = new Object();
    NowPlayingControllerWrapper.onRetainNonConfigurationInstance(this, result);
    return result;
  }

  @Override
  protected void onListItemClick(final ListView listView, final View view, final int position, final long id) {
    final String review_url = this.reviews.get(position).getLink();
    final Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(review_url));
    startActivity(intent);

    super.onListItemClick(listView, view, position, id);
  }

  private class ReviewsAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    private ReviewsAdapter(final Context context) {
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
      convertView = this.inflater.inflate(R.layout.reviewview, null);
      final MovieViewHolder holder = new MovieViewHolder((ImageView) convertView.findViewById(R.id.score),
                                                         (TextView) convertView.findViewById(R.id.author),
                                                         (TextView) convertView.findViewById(R.id.source),
                                                         (TextView) convertView.findViewById(R.id.desc));
      convertView.setTag(holder);
      final Review review = AllReviewsActivity.this.reviews.get(position);
      holder.author.setText(review.getAuthor());
      holder.source.setText(review.getSource());
      holder.description.setText(review.getText());
      holder.score.setBackgroundDrawable(
          MovieViewUtilities.formatBasicSquareDrawable(review.getScore(), getResources()));
      return convertView;
    }

    private class MovieViewHolder {
      private final ImageView score;
      private final TextView author;
      private final TextView source;
      private final TextView description;

      private MovieViewHolder(final ImageView score, final TextView author, final TextView source,
                              final TextView description) {
        this.score = score;
        this.author = author;
        this.source = source;
        this.description = description;
      }
    }

    public int getCount() {
      return AllReviewsActivity.this.reviews.size();
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(R.drawable.ic_menu_home).setIntent(
        new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class));
    return super.onCreateOptionsMenu(menu);
  }
}
