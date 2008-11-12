package org.metasyntactic;

import android.app.ListActivity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.ServiceConnection;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.IBinder;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Review;
import org.metasyntactic.utilities.MovieViewUtilities;

import java.util.ArrayList;
import java.util.List;

public class MovieDetailsActivity extends ListActivity {
    /** Called when the activity is first created. */
    NowPlayingControllerWrapper controller;
    List<MovieDetailEntry> movieDetailEntries = new ArrayList<MovieDetailEntry>();
    private Context mContext;
    MovieAdapter movieAdapter;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.moviedetails);
        movie = this.getIntent().getExtras().getParcelable("movie");
        mContext = this;
        movieAdapter = new MovieAdapter(this);
        setListAdapter(movieAdapter);
    }

    private final ServiceConnection serviceConnection = new ServiceConnection() {
        public void onServiceConnected(ComponentName className, IBinder service) {
            // This is called when the connection with the service has been
            // established, giving us the service object we can use to
            // interact with the service. We are communicating with our
            // service through an IDL interface, so get a client-side
            // representation of that from the raw service object.
            controller = new NowPlayingControllerWrapper(
                    INowPlayingController.Stub.asInterface(service));
            populateMovieEntries();
            bindView(movie);
        }

        public void onServiceDisconnected(ComponentName className) {
            controller = null;
        }
    };

    @Override
    protected void onDestroy() {
        unbindService(serviceConnection);
        super.onDestroy();
    }

    private void bindView(final Movie movie) {
        Button trailerbtn = (Button) findViewById(R.id.trailerbtn);
        Button imdbbtn = (Button) findViewById(R.id.imdbbtn);
        Button reviewsbtn = (Button) findViewById(R.id.reviewsbtn);
        trailerbtn.setOnClickListener(trailerOnClickListener);
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
                            "IMDB information is not available.",
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
                    intent.setClass(MovieDetailsActivity.this,
                            AllReviewsActivity.class);
                    startActivity(intent);
                } else {
                    Toast.makeText(MovieDetailsActivity.this,
                            "Reviews are not available.", Toast.LENGTH_SHORT)
                            .show();
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
                            "IMDB information is not available.",
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
                    intent.setClass(MovieDetailsActivity.this,
                            AllReviewsActivity.class);
                    startActivity(intent);
                } else {
                    Toast.makeText(MovieDetailsActivity.this,
                            "Reviews are not yet available.",
                            Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    private void populateMovieEntries() {
        // TODO put all strings in res/values/strings.xml
        MovieDetailEntry entry = new MovieDetailEntry();
        //Add synopsis
        entry.setName(movie.getDisplayTitle());
        String synopsis = controller.getSynopsis(movie);
        if (synopsis != null && synopsis.length() > 0) {
            // hack to display text on left and bottom or poster
            entry.setValue(synopsis);
        } else {
            entry.setValue("No synopsis available.");
        }
        movieDetailEntries.add(entry);
        //Add rating
        entry = new MovieDetailEntry();
        entry.setName("Rating");
        CharSequence rating = MovieViewUtilities.formatRatings(movie
                .getRating(), NowPlayingActivity.instance.getResources());
        if (rating != null && rating.length() > 0) {
            // hack to display text on left and bottom or poster
            entry.setValue(rating.toString());
        } else {
            entry.setValue("UnRated.");
        }
        movieDetailEntries.add(entry);
        //Add length
        entry = new MovieDetailEntry();
        entry.setName("Running Time");
        CharSequence length = MovieViewUtilities.formatLength(
                movie.getLength(), NowPlayingActivity.instance.getResources());
        if (length != null && length.length() > 0) {
            // hack to display text on left and bottom or poster
            entry.setValue(length.toString());
        } else {
            entry.setValue("Unknown.");
        }
        movieDetailEntries.add(entry);
        //Add release date
        entry = new MovieDetailEntry();
        entry.setName("Release Date");
        if (movie.getReleaseDate() != null) {
            entry.setValue(movie.getReleaseDate().toLocaleString());
        } else {
            entry.setValue("Unknown.");
        }
        movieDetailEntries.add(entry);
        //Add directors
        entry = new MovieDetailEntry();
        entry.setName("Director(s)");
        if (movie.getDirectors() != null && movie.getDirectors().size() > 0) {
            String director = movie.getDirectors().toString();
            entry.setValue(director.substring(1, director.length() - 1));
        } else {
            entry.setValue("Unknown.");
        }
        movieDetailEntries.add(entry);
        //Add cast
        entry = new MovieDetailEntry();
        entry.setName("Cast");
        if (movie.getCast() != null && movie.getCast().size() > 0) {
            String cast = movie.getCast().toString();
            entry.setValue(cast.substring(1, cast.length() - 1));
        } else {
            entry.setValue("Unknown.");
        }
        movieDetailEntries.add(entry);
        //Add Genres
        entry = new MovieDetailEntry();
        entry.setName("Genre");
        if (movie.getGenres() != null && movie.getGenres().size() > 0) {
            String genres = movie.getGenres().toString();
            entry.setValue(genres.substring(1, genres.length() - 1));
        } else {
            entry.setValue("Unknown.");
        }
        movieDetailEntries.add(entry);
        movieAdapter.refresh();
    }

    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
        boolean bindResult = bindService(new Intent(getBaseContext(),
                NowPlayingControllerService.class), serviceConnection,
                Context.BIND_AUTO_CREATE);
        if (!bindResult) {
            throw new RuntimeException("Failed to bind to service!");
        }
    }

    OnClickListener trailerOnClickListener = new OnClickListener() {
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
                        "Trailer is not available.", Toast.LENGTH_SHORT).show();
            }
        }
    };

    class MovieAdapter extends BaseAdapter {
        private final Context context;
        private final LayoutInflater inflater;

        public MovieAdapter(Context context) {
            this.context = context;
            // Cache the LayoutInflate to avoid asking for a new one each time.
            inflater = LayoutInflater.from(context);
        }

        public Object getEntry(int i) {
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
            // Bind the data efficiently with the holder.
            Resources res = context.getResources();
            return convertView;
        }

        public int getCount() {
            return movieDetailEntries.size();
        }

        private class MovieViewHolder {
            TextView name;
            TextView value;
        }

        public long getEntryId(int position) {
            // TODO Auto-generated method stub
            return position;
        }

        @Override
        public Object getItem(int position) {
            // TODO Auto-generated method stub
            return movieDetailEntries.get(position);
        }

        @Override
        public long getItemId(int position) {
            // TODO Auto-generated method stub
            return position;
        }

        public void refresh() {
            // TODO Auto-generated method stub
            notifyDataSetChanged();
        }
    }
    private class MovieDetailEntry {
        String name;
        String value;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }
    }

    private Movie movie;
}
