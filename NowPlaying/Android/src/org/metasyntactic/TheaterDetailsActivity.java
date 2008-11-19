package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcelable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Theater;

import java.util.ArrayList;
import java.util.List;

public class TheaterDetailsActivity extends ListActivity {
  /** Called when the activity is first created. */
  NowPlayingControllerWrapper controller;
  private Theater theater;
  MoviesAdapter moviesAdapter;
  List<Movie> movies = new ArrayList<Movie>();

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.removeActivity(this);
    setContentView(R.layout.theaterdetails);
    this.theater = getIntent().getExtras().getParcelable("theater");
    bindView();
  }

  @Override
  protected void onListItemClick(final ListView l, final View v, final int position, final long id) {
    final Movie movie = this.movies.get(position);
    final Intent intent = new Intent();
    intent.setClass(this, MovieDetailsActivity.class);
    intent.putExtra("movie", (Parcelable) movie);
    startActivity(intent);
    super.onListItemClick(l, v, position, id);
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  private void bindView() {
    final TextView theaterlbl = (TextView) findViewById(R.id.theater);
    theaterlbl.setEllipsize(TextUtils.TruncateAt.END);
    theaterlbl.setText(this.theater.getName());
    final TextView phonelbl = (TextView) findViewById(R.id.phone);
    phonelbl.setEllipsize(TextUtils.TruncateAt.END);
    phonelbl.setText(this.theater.getPhoneNumber());
    final TextView maplbl = (TextView) findViewById(R.id.map);
    maplbl.setEllipsize(TextUtils.TruncateAt.END);
    final String address = this.theater.getAddress() + ", " + this.theater.getLocation().getCity();
    maplbl.setText(address);
    this.movies = NowPlayingControllerWrapper.getMoviesAtTheater(this.theater);
    final ImageView mapIcon = (ImageView) findViewById(R.id.mapicon);
    final ImageView phoneIcon = (ImageView) findViewById(R.id.phoneicon);
    final Intent mapIntent = new Intent("android.intent.action.VIEW", Uri
        .parse("geo:0,0?q=" + address));
    final Intent callIntent = new Intent("android.intent.action.DIAL", Uri
        .parse("tel:" + this.theater.getPhoneNumber()));
    mapIcon.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        startActivity(mapIntent);
      }
    });
    maplbl.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        startActivity(mapIntent);
      }
    });
    phoneIcon.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        startActivity(callIntent);
      }
    });
    phonelbl.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        startActivity(callIntent);
      }
    });
    this.moviesAdapter = new MoviesAdapter(this);
    setListAdapter(this.moviesAdapter);
  }

  @Override
  protected void onResume() {
    super.onResume();
  }

  class MoviesAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public MoviesAdapter(final Context context) {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(context);
    }

    public Object getEntry(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = this.inflater.inflate(R.layout.theaterdetails_item, null);
      final MovieViewHolder holder = new MovieViewHolder();
      holder.label = (TextView) convertView.findViewById(R.id.label);
      holder.data = (TextView) convertView.findViewById(R.id.data);
      final Movie movie = TheaterDetailsActivity.this.movies.get(position);
      holder.label.setText(movie.getDisplayTitle());
      final List<Performance> list = NowPlayingControllerWrapper
          .getPerformancesForMovieAtTheater(movie, TheaterDetailsActivity.this.theater);
      String performance = "";
      if (list != null) {
        for (int i = 0; i < list.size(); i++) {
          performance += list.get(i).getTime() + ", ";
        }
        performance = performance
            .substring(0, performance.length() - 2);
        holder.data.setText(performance);
      } else {
        holder.data.setText("Unknown.");
      }
      return convertView;
    }

    public int getCount() {
      return TheaterDetailsActivity.this.movies.size();
    }

    private class MovieViewHolder {
      TextView label;
      TextView data;
    }

    public long getEntryId(final int position) {
      return position;
    }

    public Object getItem(final int position) {
      return TheaterDetailsActivity.this.movies.get(position);
    }

    public long getItemId(final int position) {
      return position;
    }

    public void refresh() {
      notifyDataSetChanged();
    }
  }
}
