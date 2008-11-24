package org.metasyntactic;

import android.app.ListActivity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcelable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
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
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.ArrayList;
import java.util.List;

public class TheaterDetailsActivity extends ListActivity {
  /** Called when the activity is first created. */
  private Theater theater;
  private List<Movie> movies = new ArrayList<Movie>();

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.addActivity(this);
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
    final TextView theaterLabel = (TextView) findViewById(R.id.theater);
    theaterLabel.setEllipsize(TextUtils.TruncateAt.END);
    theaterLabel.setText(this.theater.getName());
    final TextView phoneLabel = (TextView) findViewById(R.id.phone);
    phoneLabel.setEllipsize(TextUtils.TruncateAt.END);
    phoneLabel.setText(this.theater.getPhoneNumber());
    final TextView mapLabel = (TextView) findViewById(R.id.map);
    mapLabel.setEllipsize(TextUtils.TruncateAt.END);
    final String address = this.theater.getAddress() + ", " + this.theater.getLocation().getCity();
    mapLabel.setText(address);
    this.movies = NowPlayingControllerWrapper.getMoviesAtTheater(this.theater);
    final ImageView mapIcon = (ImageView) findViewById(R.id.mapicon);
    final ImageView phoneIcon = (ImageView) findViewById(R.id.phoneicon);
    final Intent mapIntent = new Intent("android.intent.action.VIEW", Uri.parse("geo:0,0?q="
        + address));
    final Intent callIntent = new Intent("android.intent.action.DIAL", Uri.parse("tel:"
        + this.theater.getPhoneNumber()));
    mapIcon.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        startActivity(mapIntent);
      }
    });
    mapLabel.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        startActivity(mapIntent);
      }
    });
    phoneIcon.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        startActivity(callIntent);
      }
    });
    phoneLabel.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        startActivity(callIntent);
      }
    });
    MoviesAdapter moviesAdapter = new MoviesAdapter();
    setListAdapter(moviesAdapter);
  }

  private class MoviesAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public MoviesAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(TheaterDetailsActivity.this);
    }

    public Object getEntry(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = this.inflater.inflate(R.layout.theaterdetails_item, null);
      final MovieViewHolder holder = new MovieViewHolder((TextView) convertView
          .findViewById(R.id.label), (TextView) convertView.findViewById(R.id.data));
      final Movie movie = TheaterDetailsActivity.this.movies.get(position);
      holder.label.setText(movie.getDisplayTitle());
      final List<Performance> list = NowPlayingControllerWrapper.getPerformancesForMovieAtTheater(
          movie, TheaterDetailsActivity.this.theater);
      String performance = "";
      for (Performance aList : list) {
        performance += aList.getTime() + ", ";
      }
      performance = performance.substring(0, performance.length() - 2);
      holder.data.setText(performance);
      return convertView;
    }

    public int getCount() {
      return TheaterDetailsActivity.this.movies.size();
    }

    private class MovieViewHolder {
      private final TextView label;
      private final TextView data;

      private MovieViewHolder(TextView label, TextView data) {
        this.label = label;
        this.data = data;
      }
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
  
  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(
        R.drawable.movies).setIntent(
            new Intent(this, NowPlayingActivity.class)).setAlphabeticShortcut('m');    
    menu.add(0, MovieViewUtilities.MENU_THEATER, 0, R.string.menu_theater).setIcon(
        R.drawable.theatres);
    menu.add(0, MovieViewUtilities.MENU_UPCOMING, 0, R.string.menu_upcoming).setIcon(
        R.drawable.upcoming);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.menu_settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(
        new Intent(this, SettingsActivity.class)).setAlphabeticShortcut('s');
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {
   
    if (item.getItemId() == MovieViewUtilities.MENU_THEATER) {
      final Intent intent = new Intent();
      intent.setClass(TheaterDetailsActivity.this, AllTheatersActivity.class);
      startActivity(intent);
      return true;
    }
    return false;
  }

}
