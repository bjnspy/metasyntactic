package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import android.widget.Toast;
import org.metasyntactic.data.Movie;

import java.util.ArrayList;
import java.util.List;

public class MovieDetailsActivity extends ListActivity {
  /** Called when the activity is first created. */
  private final List<MovieDetailEntry> movieDetailEntries = new ArrayList<MovieDetailEntry>();
  private MovieAdapter movieAdapter;
  private Movie movie;

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.addActivity(this);
    setContentView(R.layout.moviedetails);
    this.movie = getIntent().getExtras().getParcelable("movie");
    this.movieAdapter = new MovieAdapter(this);
    setListAdapter(this.movieAdapter);
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  OnClickListener trailerOnClickListener = new OnClickListener() {
    public void onClick(final View v) {
      String trailer_url = null;
      final List<String> trailers = NowPlayingControllerWrapper.getTrailers(MovieDetailsActivity.this.movie);
      if (trailers.size() > 0) {
        trailer_url = trailers.get(0);
      }
      if (trailer_url != null) {
        final Intent intent = new Intent();
        intent.putExtra("trailer_url", trailer_url);
        intent.setClass(MovieDetailsActivity.this, VideoViewActivity.class);
        startActivity(intent);
      } else {
        Toast.makeText(MovieDetailsActivity.this, "Trailer is not available.", Toast.LENGTH_SHORT).show();
      }
    }
  };

  class MovieAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public MovieAdapter(final Context context) {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(context);
    }

    public Object getEntry(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = this.inflater.inflate(R.layout.moviedetails_item, null);
      // Creates a MovieViewHolder and store references to the
      // children views we want to bind data to.
      final MovieViewHolder holder = new MovieViewHolder();
      holder.name = (TextView) convertView.findViewById(R.id.name);
      holder.value = (TextView) convertView.findViewById(R.id.value);
      final MovieDetailEntry entry = MovieDetailsActivity.this.movieDetailEntries.get(position);
      holder.name.setText(entry.getName());
      holder.value.setText(entry.getValue());
      // Bind the data efficiently with the holder.
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
