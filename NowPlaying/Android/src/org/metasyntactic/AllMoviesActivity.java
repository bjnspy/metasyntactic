package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
import android.content.res.Resources;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.utilities.MovieViewUtilities;

import java.util.ArrayList;
import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class AllMoviesActivity extends ListActivity {
    private NowPlayingActivity activity;
    private List<Movie> movies = new ArrayList<Movie>();
    private static MoviesAdapter mAdapter;
    private static Context mContext;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        activity = (NowPlayingActivity) getParent();
        mContext = this;

        // Set up Movies adapter
        mAdapter = new MoviesAdapter(this);
        setListAdapter(mAdapter);
    }


    class MoviesAdapter extends BaseAdapter {
        private Context mContext;

        private LayoutInflater mInflater;


        public MoviesAdapter(Context context) {
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
            Log.i("AllMoviesActivity", "Movie List item at position "
                + position + " redrawn.");

            if (convertView == null) {
                convertView = mInflater.inflate(R.layout.movieview, null);
                // Creates a MovieViewHolder and store references to the
                // children
                // views we want to bind data to.
                holder = new MovieViewHolder();
                holder.score = (TextView) convertView.findViewById(R.id.score);
                holder.title = (TextView) convertView.findViewById(R.id.title);
                holder.rating =
                    (TextView) convertView.findViewById(R.id.rating);
                holder.length =
                    (TextView) convertView.findViewById(R.id.length);
                convertView.setTag(holder);
            } else {
                // Get the MovieViewHolder back to get fast access to the child
                // views
                holder = (MovieViewHolder) convertView.getTag();
            }
            // Bind the data efficiently with the holder.
            Resources res = mContext.getResources();
            Movie movie = movies.get(position);
            holder.title.setText(movie.getDisplayTitle());
            holder.rating.setText(MovieViewUtilities.formatRatings(movie
                .getRating(), res));
            holder.length.setText(MovieViewUtilities.formatLength(movie
                .getLength(), res));

            // Get and set scores text and background image
            Score score = activity.getScore(movie);
            int scoreValue = -1;
            if (score != null) {
                scoreValue = Integer.parseInt(score.getValue());
            }
            ScoreType scoreType = activity.getScoreType();

            holder.score.setBackgroundDrawable(MovieViewUtilities
                .formatScoreDrawable(scoreValue, scoreType, res));
            holder.score.setText(String.valueOf(scoreValue));


            return convertView;
        }

        class MovieViewHolder {
            TextView score;

            TextView title;
            TextView rating;

            TextView length;


        }


        public int getCount() {
            return movies.size();
        }



        public void refreshMovies() {
            movies = activity.getMovies();
            notifyDataSetChanged();
        }
    }


    public static void refresh() {
        mAdapter.refreshMovies();
    }
}
