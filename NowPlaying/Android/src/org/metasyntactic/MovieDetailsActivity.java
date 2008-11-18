package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.utilities.MovieViewUtilities;

import java.util.ArrayList;
import java.util.List;

public class MovieDetailsActivity extends ListActivity {
    /** Called when the activity is first created. */
    private final List<MovieDetailEntry> movieDetailEntries = new ArrayList<MovieDetailEntry>();
    private MovieAdapter movieAdapter;
    private Movie movie;
    Context mContext;

    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        NowPlayingControllerWrapper.addActivity(this);
        setContentView(R.layout.moviedetails);
        mContext = this;
        this.movie = getIntent().getExtras().getParcelable("movie");
        populateMovieDetailEntries();
        this.movieAdapter = new MovieAdapter(this);
        setListAdapter(this.movieAdapter);
        bindButtonClickListeners();
    }

    private void populateMovieDetailEntries() {
        final Resources res = mContext.getResources();
        // Add title and synopsis
        MovieDetailEntry entry = new MovieDetailEntry();
        entry.setName(movie.getDisplayTitle());
        String synopsis = movie.getSynopsis();
        if (synopsis != null || synopsis.length() > 0)
            entry.setValue(synopsis);
        else
            entry.setValue("Unknown");
        movieDetailEntries.add(entry);
        // Add Rating
        entry = new MovieDetailEntry();
        entry.setName("Rating");
        entry.setValue(MovieViewUtilities.formatRatings(movie.getRating(), res)
                .toString());
        movieDetailEntries.add(entry);
        // Add release Date
        entry = new MovieDetailEntry();
        entry.setName("Release Date");
        entry.setValue(movie.getReleaseDate().toLocaleString());
        movieDetailEntries.add(entry);
        // Add length
        entry = new MovieDetailEntry();
        entry.setName("Duration");
        entry.setValue(MovieViewUtilities.formatLength(movie.getLength(), res)
                .toString());
        movieDetailEntries.add(entry);
        // Add cast
        entry = new MovieDetailEntry();
        entry.setName("Cast");
        entry.setValue(MovieViewUtilities.formatListToString(movie.getCast())
                .toString());
        movieDetailEntries.add(entry);
        // Add cast
        entry = new MovieDetailEntry();
        entry.setName("Director");
        entry.setValue(MovieViewUtilities.formatListToString(
                movie.getDirectors()).toString());
        movieDetailEntries.add(entry);
    }

    @Override
    protected void onDestroy() {
        NowPlayingControllerWrapper.removeActivity(this);
        super.onDestroy();
    }

    void bindButtonClickListeners() {
        Button imdbbtn = (Button) findViewById(R.id.imdbbtn);
        Button reviewsbtn = (Button) findViewById(R.id.reviewsbtn);
        Button trailersbtn = (Button) findViewById(R.id.trailerbtn);
        Button showtimes = (Button) findViewById(R.id.showtimesbtn);
        imdbbtn.setOnClickListener(new OnClickListener() {
            public void onClick(View v) {
                String imdb_url = null;
                imdb_url = NowPlayingControllerWrapper.getImdbAddress(movie);
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
                ArrayList<Review> reviews = (ArrayList) NowPlayingControllerWrapper
                        .getReviews(movie);
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
        
        showtimes.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View arg0) {
                // TODO Auto-generated method stub
               
                Intent intent = new Intent();
                intent.setClass(mContext, ShowtimesActivity.class);
                intent.putExtra("movie", (Parcelable) movie);
                startActivity(intent);
            }
        });
    }

    class MovieAdapter extends BaseAdapter {
        private final LayoutInflater inflater;

        public MovieAdapter(final Context context) {
            // Cache the LayoutInflate to avoid asking for a new one each time.
            this.inflater = LayoutInflater.from(context);
        }

        public Object getEntry(final int i) {
            return i;
        }

        public View getView(int position, View convertView, ViewGroup viewGroup) {
            convertView = inflater.inflate(R.layout.moviedetails_item, null);
            // Creates a MovieViewHolder and store references to the
            // children views we want to bind data to.
            MovieViewHolder holder = new MovieViewHolder();
            holder.name = (TextView) convertView.findViewById(R.id.name);
            holder.value = (TextView) convertView.findViewById(R.id.value);
            MovieDetailEntry entry = movieDetailEntries.get(position);
            holder.name.setText(entry.getName());
            holder.value.setText(entry.getValue());
            if (position == 0) {
                holder.name.setTextAppearance(mContext,
                        android.R.attr.textAppearanceLarge);
                holder.name.setBackgroundResource(R.drawable.shape_1);
                holder.name.setMinHeight(50);
            }
            return convertView;
        }

        public int getCount() {
            return MovieDetailsActivity.this.movieDetailEntries.size();
        }

        private class MovieViewHolder {
            TextView name;
            TextView value;
        }

        public long getEntryId(final int position) {
            return position;
        }

        public Object getItem(final int position) {
            return MovieDetailsActivity.this.movieDetailEntries.get(position);
        }

        public long getItemId(final int position) {
            return position;
        }

        public void refresh() {
            notifyDataSetChanged();
        }
    }
    private class MovieDetailEntry {
        String name;
        String value;

        public String getName() {
            return this.name;
        }

        public void setName(final String name) {
            this.name = name;
        }

        public String getValue() {
            return this.value;
        }

        public void setValue(final String value) {
            this.value = value;
        }
    }
}
