package org.metasyntactic.activities;

import android.app.ListActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Parcelable;
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
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Theater;
import org.metasyntactic.utilities.MovieViewUtilities;

import java.util.ArrayList;
import java.util.List;

public class TheaterDetailsActivity extends ListActivity {
  /**
   * Called when the activity is first created.
   */
  private Theater theater;
  private List<Movie> movies = new ArrayList<Movie>();
  private List<TheaterDetailEntry> theaterDetailEntries = new ArrayList<TheaterDetailEntry>();

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Log.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);
    setContentView(R.layout.theaterdetails);
    this.theater = getIntent().getExtras().getParcelable("theater");
    this.movies = NowPlayingControllerWrapper.getMoviesAtTheater(this.theater);
    populateTheaterDetailEntries();
    final TextView titleView = (TextView) findViewById(R.id.theater);
    titleView.setText(this.theater.getName());
    setListAdapter(new TheaterDetailsAdapter());
  }

  @Override
  protected void onResume() {
    super.onResume();
    Log.i(getClass().getSimpleName(), "onResume");
  }

  @Override
  protected void onPause() {
    super.onPause();
    Log.i(getClass().getSimpleName(), "onPause");
  }

  @Override
  protected void onDestroy() {
    Log.i(getClass().getSimpleName(), "onDestroy");
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override
  public Object onRetainNonConfigurationInstance() {
    Log.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    final Object result = this.theaterDetailEntries;
    NowPlayingControllerWrapper.onRetainNonConfigurationInstance(this, result);
    return result;
  }

  @Override
  protected void onListItemClick(final ListView listView, final View view, final int position,
      final long id) {
    final Intent intent = this.theaterDetailEntries.get(position).intent;
    if (intent != null) {
      startActivity(intent);
    }
    super.onListItemClick(listView, view, position, id);
  }

  private void populateTheaterDetailEntries() {
    theaterDetailEntries = (List<TheaterDetailEntry>) getLastNonConfigurationInstance();
    if (theaterDetailEntries == null || theaterDetailEntries.isEmpty()) {
      theaterDetailEntries = new ArrayList<TheaterDetailEntry>();
      final Resources res = getResources();
      {
        // Add map header
        final TheaterDetailEntry entry = new TheaterDetailEntry(res.getString(R.string.map), null,
            TheaterDetailItemType.HEADER, null, null, false);
        this.theaterDetailEntries.add(entry);
      }
      {
        // Add map
        final String address = this.theater.getAddress() + ", "
            + this.theater.getLocation().getCity();
        final Intent mapIntent = new Intent("android.intent.action.VIEW", Uri.parse("geo:0,0?q="
            + address));
        final Drawable mapIcon = res.getDrawable(R.drawable.sym_action_map);
        final TheaterDetailEntry entry = new TheaterDetailEntry(address, null,
            TheaterDetailItemType.ACTION, mapIcon, mapIntent, true);
        this.theaterDetailEntries.add(entry);
      }
      {
        // Add phone header
        final TheaterDetailEntry entry = new TheaterDetailEntry(res.getString(R.string.call), null,
            TheaterDetailItemType.HEADER, null, null, false);
        this.theaterDetailEntries.add(entry);
      }
      {
        // Add phone
        final String phone = this.theater.getPhoneNumber();
        final Intent phoneIntent = new Intent("android.intent.action.DIAL", Uri.parse("tel:"
            + this.theater.getPhoneNumber()));
        final Drawable phoneIcon = res.getDrawable(R.drawable.sym_action_call);
        final TheaterDetailEntry entry = new TheaterDetailEntry(phone, null,
            TheaterDetailItemType.ACTION, phoneIcon, phoneIntent, true);
        this.theaterDetailEntries.add(entry);
      }
      {
        // Add showtimes header
        final TheaterDetailEntry entry = new TheaterDetailEntry(
            res.getString(R.string.now_showing), null, TheaterDetailItemType.HEADER, null, null,
            false);
        this.theaterDetailEntries.add(entry);
      }
      {
        // Add movies
        for (final Movie movie : this.movies) {
          final String movieTitle = movie.getDisplayTitle();
          final List<Performance> list = NowPlayingControllerWrapper
              .getPerformancesForMovieAtTheater(movie, TheaterDetailsActivity.this.theater);
          String performance = "";
          for (final Performance aList : list) {
            performance += aList.getTime() + ", ";
          }
          performance = performance.substring(0, performance.length() - 2);
          final Intent movieIntent = new Intent();
          movieIntent.setClass(this, MovieDetailsActivity.class);
          movieIntent.putExtra("movie", (Parcelable) movie);
          final TheaterDetailEntry entry = new TheaterDetailEntry(movieTitle, performance,
              TheaterDetailItemType.DATA, null, movieIntent, true);
          this.theaterDetailEntries.add(entry);
        }
      }
    }
  }

  private class TheaterDetailsAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    @Override
    public boolean areAllItemsEnabled() {
      return false;
    }

    @Override
    public boolean isEnabled(final int position) {
      return TheaterDetailsActivity.this.theaterDetailEntries.get(position).isSelectable();
    }

    private TheaterDetailsAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(TheaterDetailsActivity.this);
    }

    public Object getEntry(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      final TheaterDetailEntry entry = TheaterDetailsActivity.this.theaterDetailEntries
          .get(position);
      switch (entry.type) {
      case DATA:
        convertView = this.inflater.inflate(R.layout.theaterdetails_item, null);
        final TextView movieView = (TextView) convertView.findViewById(R.id.label);
        movieView.setText(entry.data);
        final TextView showtimesView = (TextView) convertView.findViewById(R.id.data);
        showtimesView.setText(entry.data2);
        break;
      case HEADER:
        convertView = this.inflater.inflate(R.layout.headerview, null);
        final TextView headerView = (TextView) convertView.findViewById(R.id.name);
        headerView.setText(entry.data);
        break;
      case ACTION:
        convertView = this.inflater.inflate(R.layout.theaterdetails_icon_item, null);
        final TextView actionView = (TextView) convertView.findViewById(R.id.data);
        actionView.setText(entry.data);
        final ImageView actionIcon = (ImageView) convertView.findViewById(R.id.icon);
        actionIcon.setImageDrawable(entry.icon);
        break;
      }
      return convertView;
    }

    public int getCount() {
      Log.i("TEST", "Size of list is " + TheaterDetailsActivity.this.theaterDetailEntries.size());
      return TheaterDetailsActivity.this.theaterDetailEntries.size();
    }

    public long getEntryId(final int position) {
      return position;
    }

    public Object getItem(final int position) {
      return TheaterDetailsActivity.this.theaterDetailEntries.get(position);
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
        R.drawable.ic_menu_home).setIntent(new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class));
    return super.onCreateOptionsMenu(menu);
  }

  private enum TheaterDetailItemType {
    DATA, ACTION, HEADER
  }

  private static class TheaterDetailEntry {
    private final TheaterDetailItemType type;
    private final Drawable icon;
    private final boolean selectable;
    private final String data;
    private final Intent intent;
    private final String data2;

    private TheaterDetailEntry(final String data, final String data2,
        final TheaterDetailItemType type, final Drawable icon, final Intent intent,
        final boolean selectable) {
      this.data = data;
      this.data2 = data2;
      this.type = type;
      this.icon = icon;
      this.selectable = selectable;
      this.intent = intent;
    }

    public boolean isSelectable() {
      return this.selectable;
    }
  }
}
