package org.metasyntactic.activities;

import android.app.ListActivity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.os.Parcelable;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.INowPlaying;
import org.metasyntactic.NowPlayingControllerWrapper;
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

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class AllTheatersActivity extends ListActivity implements INowPlaying {
  private int lastPosition;
  private int lastSection;
  private TheatersAdapter adapter;
  private List<Theater> theaters = new ArrayList<Theater>();
  private final Map<Integer, Integer> alphaTheaterSectionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> alphaTheaterPositionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> distanceTheaterSectionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> distanceTheaterPositionsMap = new HashMap<Integer, Integer>();
  private String[] distance;
  private String[] alphabet;
  private Location userLocation;
  private Address userAddress;
  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
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
  @SuppressWarnings("unchecked") private final List<Comparator<Theater>> THEATER_ORDER = Arrays.asList(this.TITLE_ORDER, this.DISTANCE_ORDER);

  @Override protected void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Log.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);
    getAlphabet(this);
    getDistances();
    setupView();
  }

  @Override protected void onDestroy() {
    Log.i(getClass().getSimpleName(), "onDestroy");
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override protected void onPause() {
    Log.i(getClass().getSimpleName(), "onPause");
    unregisterReceiver(this.broadcastReceiver);
    super.onPause();
  }

  @Override protected void onResume() {
    super.onResume();
    Log.i(getClass().getSimpleName(), "onResume");
    registerReceiver(this.broadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_CHANGED_INTENT));
  }

  @Override public Object onRetainNonConfigurationInstance() {
    Log.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    final Object result = new Object();
    NowPlayingControllerWrapper.onRetainNonConfigurationInstance(this, result);
    return result;
  }

  private void setupView() {
    this.theaters = new ArrayList<Theater>(NowPlayingControllerWrapper.getTheaters());
    setContentView(R.layout.theaterlist);
    final ListView list = getListView();
    final String userPostalCode = NowPlayingControllerWrapper.getUserLocation();
    try {
      this.userAddress = new Geocoder(this).getFromLocationName(userPostalCode, 1).get(0);
    } catch (final IOException e) {
      throw new RuntimeException(e);
    }
    this.userLocation = new Location(this.userAddress.getLatitude(), this.userAddress.getLongitude(), null, null, null, null, null);
    Collections.sort(this.theaters, this.THEATER_ORDER.get(NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex()));
    populateAlphaTheaterSectionsAndPositions();
    populateDistanceTheaterSectionsAndPositions();
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
      if (prevLetter == null || !firstLetter.equals(prevLetter)) {
        this.alphaTheaterPositionsMap.put(alphabets.indexOf(firstLetter), i);
      }
      prevLetter = firstLetter;
      i++;
    }
    for (i = 0; i < alphabets.size(); i++) {
      if (this.alphaTheaterPositionsMap.get(i) == null) {
        if (i == 0) {
          this.alphaTheaterPositionsMap.put(i, 0);
        } else {
          this.alphaTheaterPositionsMap.put(i, this.alphaTheaterPositionsMap.get(i - 1));
        }
      }
    }
  }

  private void getDistances() {
    this.distance = new String[6];
    this.distance[0] = getResources().getString(R.string.less_than_number_string_away, 2, getResources().getString(R.string.miles));
    this.distance[1] = getResources().getString(R.string.less_than_number_string_away, 5, getResources().getString(R.string.miles));
    this.distance[2] = getResources().getString(R.string.less_than_number_string_away, 10, getResources().getString(R.string.miles));
    this.distance[3] = getResources().getString(R.string.less_than_number_string_away, 25, getResources().getString(R.string.miles));
    this.distance[4] = getResources().getString(R.string.less_than_number_string_away, 50, getResources().getString(R.string.miles));
    this.distance[5] = getResources().getString(R.string.less_than_number_string_away, 100, "miles");
  }

  private void populateDistanceTheaterSectionsAndPositions() {
    int i = 0;
    int prevLevel = 0;
    final List<String> distances = Arrays.asList(this.distance);
    for (final Theater theater : this.theaters) {
      final double distance = this.userLocation.distanceTo(theater.getLocation());
      final int distanceLevel = MovieViewUtilities.getDistanceLevel(distance);
      this.distanceTheaterSectionsMap.put(i, distanceLevel);
      if (prevLevel == 0 || distanceLevel != prevLevel) {
        this.distanceTheaterPositionsMap.put(distanceLevel, i);
      }
      prevLevel = distanceLevel;
      i++;
    }
    for (i = 0; i < distances.size(); i++) {
      if (this.distanceTheaterPositionsMap.get(i) == null) {
        if (i == 0) {
          this.distanceTheaterPositionsMap.put(i, 0);
        } else {
          this.distanceTheaterPositionsMap.put(i, this.distanceTheaterPositionsMap.get(i - 1));
        }
      }
    }
  }

  @Override public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(R.drawable.ic_menu_home).setIntent(
        new Intent(this, AllTheatersActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SORT, 0, R.string.sort_theaters).setIcon(R.drawable.ic_menu_switch);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(android.R.drawable.ic_menu_preferences).setIntent(
        new Intent(this, SettingsActivity.class));
    return super.onCreateOptionsMenu(menu);
  }

  @Override public boolean onOptionsItemSelected(final MenuItem item) {
    if (item.getItemId() == MovieViewUtilities.MENU_SORT) {
      final NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this).setKey(NowPlayingPreferenceDialog.PreferenceKeys.THEATERS_SORT)
      .setEntries(R.array.entries_theaters_sort_preference).setPositiveButton(android.R.string.ok).setNegativeButton(android.R.string.cancel);
      builder.setTitle(R.string.sort_theaters);
      builder.show();
    }
    if (item.getItemId() == MovieViewUtilities.MENU_MOVIES) {
      startActivity(new Intent(this, AllTheatersActivity.class));
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

    private TheatersAdapter() {
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
      final MovieViewHolder holder = new MovieViewHolder((TextView) convertView.findViewById(R.id.address), (TextView) convertView
          .findViewById(R.id.title));
      // Bind the data efficiently with the holder.
      final Theater theater = AllTheatersActivity.this.theaters.get(position);
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
      Integer position = null;
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 0) {
        position = AllTheatersActivity.this.alphaTheaterPositionsMap.get(section);
      }
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 1) {
        position = AllTheatersActivity.this.distanceTheaterPositionsMap.get(section);
      }
      if (position != null) {
        AllTheatersActivity.this.lastPosition = position;
      }
      return AllTheatersActivity.this.lastPosition;
    }

    public int getSectionForPosition(final int position) {
      Integer section = null;
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 0) {
        section = AllTheatersActivity.this.alphaTheaterSectionsMap.get(position);
      }
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 1) {
        section = AllTheatersActivity.this.distanceTheaterSectionsMap.get(position);
      }
      if (section != null) {
        AllTheatersActivity.this.lastSection = section;
      }
      return AllTheatersActivity.this.lastSection;
    }

    public Object[] getSections() {
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 0) {
        return AllTheatersActivity.this.alphabet;
      }
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 1) {
        return AllTheatersActivity.this.distance;
      }
      return null;
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
    final List<Theater> localTheaters = NowPlayingControllerWrapper.getTheaters();
    Collections.sort(localTheaters, this.THEATER_ORDER.get(NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex()));
    populateAlphaTheaterSectionsAndPositions();
    populateDistanceTheaterSectionsAndPositions();
    FastScrollView.getSections();
    this.adapter.refreshTheaters(localTheaters);
  }

  @Override protected void onListItemClick(final ListView listView, final View view, final int position, final long id) {
    final Theater theater = this.theaters.get(position);
    final Intent intent = new Intent();
    intent.setClass(this, TheaterDetailsActivity.class);
    intent.putExtra("theater", (Parcelable) theater);
    startActivity(intent);
    super.onListItemClick(listView, view, position, id);
  }
}
