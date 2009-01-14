package org.metasyntactic;

import android.app.ListActivity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import org.metasyntactic.data.Location;
import org.metasyntactic.data.Theater;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.views.FastScrollView;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** @author mjoshi@google.com (Megha Joshi) */
public class AllTheatersActivity extends ListActivity implements INowPlaying {
  private int lastPosition;
  private TheatersAdapter adapter;
  private List<Theater> theaters = new ArrayList<Theater>();
  private final Map<Integer, Integer> alphaTheaterSectionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> alphaTheaterPositionsMap = new HashMap<Integer, Integer>();
  private String[] alphabet;
  private Location userLocation;
  private Address userAddress;
  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(final Context context, final Intent intent) {
      refresh();
    }
  };
  // Define comparators for theater listings sort.
  private final Comparator<Theater> TITLE_ORDER = new Comparator<Theater>() {
    public int compare(final Theater m1, final Theater m2) {
      return m1.getName().compareTo(m2.getName());
    }
  };
  private final Comparator<Theater> DISTANCE_ORDER = new Comparator<Theater>() {
    public int compare(final Theater m1, final Theater m2) {
      final Double dist_m1 = AllTheatersActivity.this.userLocation.distanceTo(m1.getLocation());
      final Double dist_m2 = AllTheatersActivity.this.userLocation.distanceTo(m2.getLocation());
      return dist_m1.compareTo(dist_m2);
    }
  };
  // The order of items in this array should match the
  // entries_theater_sort_preference array in res/values/arrays.xml
  @SuppressWarnings("unchecked")
  private final List<Comparator<Theater>> THEATER_ORDER = Arrays.asList(this.TITLE_ORDER,
      this.DISTANCE_ORDER);

  @Override
  protected void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.addActivity(this);
    getAlphabet(AllTheatersActivity.this);
    setupView();
  }

  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  protected void onPause() {
    unregisterReceiver(this.broadcastReceiver);
    super.onPause();
  }

  protected void onResume() {
    super.onResume();
    registerReceiver(this.broadcastReceiver, new IntentFilter(
        Application.NOW_PLAYING_CHANGED_INTENT));
  }

  private void setupView() {
    this.theaters = NowPlayingControllerWrapper.getTheaters();
    setContentView(R.layout.theaterlist);
    final ListView list = getListView();
    final String userPostalCode = NowPlayingControllerWrapper.getUserLocation();
    try {
      this.userAddress = new Geocoder(this).getFromLocationName(userPostalCode, 1).get(0);
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
    this.userLocation = new Location(this.userAddress.getLatitude(), this.userAddress
        .getLongitude(), null, null, null, null, null);
    Collections.sort(this.theaters, this.THEATER_ORDER.get(NowPlayingControllerWrapper
        .getAllTheatersSelectedSortIndex()));
    populateAlphaTheaterSectionsAndPositions();
    // Set up Movies adapter
    this.adapter = new TheatersAdapter();
    list.setAdapter(this.adapter);
  }

  private void populateAlphaTheaterSectionsAndPositions() {
    int i = 0;
    String prevLetter = null;
    final List<String> alphabets = Arrays.asList(this.alphabet);
    for (final Theater theater : this.theaters) {
      final String firstLetter = theater.getName().substring(0, 1);
      this.alphaTheaterSectionsMap.put(i, alphabets.indexOf(firstLetter));
      if (!firstLetter.equals(prevLetter)) {
        this.alphaTheaterPositionsMap.put(alphabets.indexOf(firstLetter), i);
      }
      prevLetter = firstLetter;
      i++;
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(
        R.drawable.ic_menu_home).setIntent(new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SORT, 0, R.string.menu_theater_sort).setIcon(
        R.drawable.ic_menu_switch);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.menu_settings).setIcon(
        android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class));
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {
    if (item.getItemId() == MovieViewUtilities.MENU_SORT) {
      final NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this).setTitle(
          R.string.theaters_select_sort_title).setKey(
          NowPlayingPreferenceDialog.PreferenceKeys.THEATERS_SORT).setEntries(
          R.array.entries_theaters_sort_preference).setPositiveButton(android.R.string.ok)
          .setNegativeButton(android.R.string.cancel);
      builder.show();
    }
    if (item.getItemId() == MovieViewUtilities.MENU_MOVIES) {
      startActivity(new Intent(this, NowPlayingActivity.class));
    }
    if (item.getItemId() == MovieViewUtilities.MENU_SETTINGS) {
      startActivity(new Intent(this, SettingsActivity.class));
    }
    return true;
  }

  private void getAlphabet(final Context context) {
    final String alphabetString = context.getResources().getString(R.string.alphabet);
    this.alphabet = new String[alphabetString.length()];
    for (int i = 0; i < this.alphabet.length; i++) {
      this.alphabet[i] = String.valueOf(alphabetString.charAt(i));
    }
  }

  private class TheatersAdapter extends BaseAdapter implements FastScrollView.SectionIndexer {
    private final LayoutInflater inflater;

    public TheatersAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(AllTheatersActivity.this);
    }

    public Object getItem(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = this.inflater.inflate(R.layout.theaterview, null);
      // Creates a MovieViewHolder and store references to the
      // children
      // views we want to bind data to.
      final MovieViewHolder holder = new MovieViewHolder((TextView) convertView
          .findViewById(R.id.address), (TextView) convertView.findViewById(R.id.title));
      // Bind the data efficiently with the holder.
      final Theater theater = AllTheatersActivity.this.theaters.get(position);
      final String headerText = MovieViewUtilities.getTheaterHeader(
          AllTheatersActivity.this.theaters, position, NowPlayingControllerWrapper
              .getAllTheatersSelectedSortIndex(), AllTheatersActivity.this.userAddress);
      holder.title.setText(theater.getName());
      holder.address.setText(theater.getAddress() + ", " + theater.getLocation().getCity());
      return convertView;
    }

    public int getCount() {
      return AllTheatersActivity.this.theaters.size();
    }

    private class MovieViewHolder {
      private final TextView address;
      private final TextView title;

      private MovieViewHolder(final TextView address, final TextView title) {
        this.address = address;
        this.title = title;
      }
    }

    public void refreshTheaters(final List<Theater> new_theaters) {
      AllTheatersActivity.this.theaters = new_theaters;
      notifyDataSetChanged();
    }

    public long getItemId(final int position) {
      return position;
    }

    public int getPositionForSection(final int section) {
      final Integer position = AllTheatersActivity.this.alphaTheaterPositionsMap.get(section);
      if (position != null) {
        AllTheatersActivity.this.lastPosition = position;
        return position;
      }
      return AllTheatersActivity.this.lastPosition;
    }

    public int getSectionForPosition(final int position) {
      return AllTheatersActivity.this.alphaTheaterSectionsMap.get(position);
    }

    public Object[] getSections() {
      return AllTheatersActivity.this.alphabet;
    }
  }

  public Context getContext() {
    return this;
  }

  public void refresh() {
    if (ThreadingUtilities.isBackgroundThread()) {
      final Runnable runnable = new Runnable() {
        public void run() {
          refresh();
        }
      };
      ThreadingUtilities.performOnMainThread(runnable);
      return;
    }
    final List<Theater> theaters = NowPlayingControllerWrapper.getTheaters();
    Collections.sort(theaters, this.THEATER_ORDER.get(NowPlayingControllerWrapper
        .getAllTheatersSelectedSortIndex()));
    this.adapter.refreshTheaters(theaters);
  }

  @Override
  protected void onListItemClick(final ListView l, final View v, final int position, final long id) {
    final Theater theater = this.theaters.get(position);
    final Intent intent = new Intent();
    intent.setClass(this, TheaterDetailsActivity.class);
    intent.putExtra("theater", (Parcelable) theater);
    startActivity(intent);
    super.onListItemClick(l, v, position, id);
  }
}
