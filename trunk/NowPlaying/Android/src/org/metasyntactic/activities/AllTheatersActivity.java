package org.metasyntactic.activities;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.metasyntactic.INowPlaying;
import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Theater;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.views.FastScrollView;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import android.app.ListActivity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class AllTheatersActivity extends ListActivity implements INowPlaying {
  private int lastPosition;
  private int lastSection;
  private TheatersAdapter adapter;
  private List<Theater> theaters = new ArrayList<Theater>();
  private final List<Theater> filteredTheaters = new ArrayList<Theater>();
  private final Map<Integer, Integer> alphaTheaterSectionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> alphaTheaterPositionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> distanceTheaterSectionsMap = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> distanceTheaterPositionsMap = new HashMap<Integer, Integer>();
  private String[] distances;
  private String[] alphabet;
  private final Collection<String> actualDistanceLevels = new ArrayList<String>();
  private final Collection<String> actualAlphabetLevels = new ArrayList<String>();
  private boolean filterTheatersByDistance = true;
  private Location userLocation;
  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(final Context context, final Intent intent) {
      refresh();
    }
  };
  // Define comparators for theater listings sort.
  private static final Comparator<Theater> TITLE_ORDER = new Comparator<Theater>() {
    public int compare(final Theater m1, final Theater m2) {
      return m1.getName().compareTo(m2.getName());
    }
  };
  private final Comparator<Theater> SEARCH_DISTANCE_ORDER = new Comparator<Theater>() {
    public int compare(final Theater m1, final Theater m2) {
      final Double dist_m1 = userLocation.distanceTo(m1.getLocation());
      final Double dist_m2 = userLocation.distanceTo(m2.getLocation());
      return dist_m1.compareTo(dist_m2);
    }
  };
  private final Comparator<Theater> DISTANCE_ORDER = new Comparator<Theater>() {
    public int compare(final Theater m1, final Theater m2) {
      final Double dist_m1 = userLocation.distanceTo(m1.getLocation());
      final Double dist_m2 = userLocation.distanceTo(m2.getLocation());
      return dist_m1.compareTo(dist_m2);
    }
  };
  // The order of items in this array should match the
  // entries_theater_sort_preference array in res/values/arrays.xml
  @SuppressWarnings("unchecked")
  private final List<Comparator<Theater>> THEATER_ORDER = Arrays.asList(TITLE_ORDER, DISTANCE_ORDER);

  @Override
  protected void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    LogUtilities.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);
    getAlphabet(this);
    setupView();
  }

  @Override
  protected void onDestroy() {
    LogUtilities.i(getClass().getSimpleName(), "onDestroy");
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override
  protected void onPause() {
    LogUtilities.i(getClass().getSimpleName(), "onPause");
    unregisterReceiver(broadcastReceiver);
    super.onPause();
  }

  @Override
  protected void onResume() {
    super.onResume();
    LogUtilities.i(getClass().getSimpleName(), "onResume");
    registerReceiver(broadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_CHANGED_INTENT));
    if (adapter != null) {
      adapter.refreshTheaters();
    }
  }

  @Override
  public Object onRetainNonConfigurationInstance() {
    LogUtilities.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    final Object result = new Object();
    NowPlayingControllerWrapper.onRetainNonConfigurationInstance(this, result);
    return result;
  }

  private final Comparator<Theater> RATING_ORDER = new Comparator<Theater>() {
    public int compare(final Theater m1, final Theater m2) {
      final boolean isFavoriteM1 = NowPlayingControllerWrapper.isFavoriteTheater(m1);
      final boolean isFavoriteM2 = NowPlayingControllerWrapper.isFavoriteTheater(m2);
      if (isFavoriteM1 && isFavoriteM2 || !isFavoriteM1 && !isFavoriteM2) {
        return 0;
      }
      if (isFavoriteM1) {
        return -1;
      }
      return 1;
    }
  };

  private void setupView() {
    theaters = new ArrayList<Theater>(NowPlayingControllerWrapper.getTheaters());
    setContentView(R.layout.theaterlist);
    final ListView list = getListView();
    userLocation = NowPlayingControllerWrapper.getLocationForAddress(NowPlayingControllerWrapper.getUserLocation());
    Collections.sort(theaters, SEARCH_DISTANCE_ORDER);
    // Set up Movies adapter
    adapter = new TheatersAdapter();
    list.setAdapter(adapter);
    populateFilteredTheaters();
    final TextView hiddenTheaters = (TextView)findViewById(R.id.hiddentheaters);
    hiddenTheaters.setOnClickListener(new OnClickListener() {
      public void onClick(final View view) {
        filterTheatersByDistance = !filterTheatersByDistance;
        hiddenTheaters.setText(getResources().getString(R.string.show_theaters_in_range));
      }
    });
  }

  private void populateFilteredTheaters() {
    filteredTheaters.clear();
    for (final Theater theater : theaters) {
      if (!NowPlayingControllerWrapper.isFavoriteTheater(theater)) {
        if (filterTheatersByDistance) {
          if (userLocation.distanceTo(theater.getLocation()) > NowPlayingControllerWrapper.getSearchDistance()) {
            continue;
          }
        }
      }

      filteredTheaters.add(theater);
    }

    Collections.sort(filteredTheaters, THEATER_ORDER.get(NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex()));
    Collections.sort(filteredTheaters, RATING_ORDER);

    populateAlphaTheaterSectionsAndPositions();
    populateDistanceTheaterSectionsAndPositions();
    FastScrollView.getSections();
    adapter.refreshTheaters();
  }

  private void populateAlphaTheaterSectionsAndPositions() {
    actualAlphabetLevels.clear();
    int i = 0;
    String prevLetter = null;
    final List<String> alphabets = Arrays.asList(alphabet);
    for (final Theater theater : filteredTheaters) {
      final String firstLetter = theater.getName().substring(0, 1);
      alphaTheaterSectionsMap.put(i, alphabets.indexOf(firstLetter));
      if (prevLetter == null || !firstLetter.equals(prevLetter)) {
        actualAlphabetLevels.add(firstLetter);
        alphaTheaterPositionsMap.put(alphabets.indexOf(firstLetter), i);
      }
      prevLetter = firstLetter;
      i++;
    }
    for (i = 0; i < alphabets.size(); i++) {
      if (alphaTheaterPositionsMap.get(i) == null) {
        if (i == 0) {
          alphaTheaterPositionsMap.put(0, 0);
        } else {
          alphaTheaterPositionsMap.put(i, alphaTheaterPositionsMap.get(i - 1));
        }
      }
    }
  }

  private String[] getDistances() {
    if (distances == null) {
      distances = new String[6];

      final String type = getResources().getString(R.string.miles);
      distances[0] = getResources().getString(R.string.less_than_number_string_away, 2, type);
      distances[1] = getResources().getString(R.string.less_than_number_string_away, 5, type);
      distances[2] = getResources().getString(R.string.less_than_number_string_away, 10, type);
      distances[3] = getResources().getString(R.string.less_than_number_string_away, 25, type);
      distances[4] = getResources().getString(R.string.less_than_number_string_away, 50, type);
      distances[5] = getResources().getString(R.string.less_than_number_string_away, 100, type);
    }

    return distances;
  }

  public static int getDistanceLevel(final double distance) {
    // Double dist_m2 = userLocation.distanceTo(m2.getLocation());
    if (distance <= 2 && distance >= 0) {
      return 0;
    }
    if (distance <= 5 && distance >= 2) {
      return 1;
    }
    if (distance <= 10 && distance >= 5) {
      return 2;
    }
    if (distance <= 25 && distance >= 10) {
      return 3;
    }
    if (distance <= 50 && distance >= 25) {
      return 4;
    }

    return 5;
  }

  private void populateDistanceTheaterSectionsAndPositions() {
    actualDistanceLevels.clear();
    int previousLevel = -1;
    for (int i = 0; i < filteredTheaters.size(); i++) {
      final Theater theater = filteredTheaters.get(i);
      final double localDistance = userLocation.distanceTo(theater.getLocation());
      final int distanceLevel = getDistanceLevel(localDistance);
      distanceTheaterSectionsMap.put(i, distanceLevel);
      if (distanceLevel != previousLevel) {
        actualDistanceLevels.add(getDistances()[distanceLevel]);
        distanceTheaterPositionsMap.put(distanceLevel, i);
      }
      previousLevel = distanceLevel;
    }
    for (int i = 0; i < getDistances().length; i++) {
      if (distanceTheaterPositionsMap.get(i) == null) {
        if (i == 0) {
          distanceTheaterPositionsMap.put(0, 0);
        } else {
          distanceTheaterPositionsMap.put(i, distanceTheaterPositionsMap.get(i - 1));
        }
      }
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(R.drawable.ic_menu_home)
    .setIntent(new Intent(this, AllTheatersActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SORT, 0, R.string.sort_theaters).setIcon(R.drawable.ic_menu_switch);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(android.R.drawable.ic_menu_preferences)
    .setIntent(new Intent(this, SettingsActivity.class).putExtra("from_menu", "yes"));
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {
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
      startActivity(new Intent(this, SettingsActivity.class).putExtra("from_menu", "yes"));
    }
    return true;
  }

  private void getAlphabet(final Context context) {
    final String alphabetString = context.getResources().getString(R.string.alphabet);
    alphabet = new String[alphabetString.length()];
    for (int i = 0; i < alphabet.length; i++) {
      alphabet[i] = String.valueOf(alphabetString.charAt(i));
    }
  }

  private class TheatersAdapter extends BaseAdapter implements FastScrollView.SectionIndexer {
    private final LayoutInflater inflater;

    private TheatersAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(AllTheatersActivity.this);
    }

    public Object getItem(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = inflater.inflate(R.layout.theaterview, null);
      // Creates a MovieViewHolder and store references to the
      // children
      // views we want to bind data to.
      final MovieViewHolder holder = new MovieViewHolder((TextView)convertView.findViewById(R.id.address),
          (TextView)convertView.findViewById(R.id.title));
      // Bind the data efficiently with the holder.
      final Theater theater = filteredTheaters.get(position);
      holder.title.setText(theater.getName());
      holder.address.setText(theater.getAddress() + ", " + theater.getLocation().getCity());
      if (NowPlayingControllerWrapper.isFavoriteTheater(theater)) {
        final View ratingImage = convertView.findViewById(R.id.ratingImage);
        ratingImage.setVisibility(View.VISIBLE);
      }
      return convertView;
    }

    public int getCount() {
      return filteredTheaters.size();
    }

    private class MovieViewHolder {
      private final TextView address;
      private final TextView title;

      private MovieViewHolder(final TextView address, final TextView title) {
        this.address = address;
        this.title = title;
      }
    }

    public void refreshTheaters() {
      notifyDataSetChanged();
    }

    public long getItemId(final int position) {
      return position;
    }

    public int getPositionForSection(final int section) {
      Integer position = null;
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 0) {
        position = alphaTheaterPositionsMap.get(section);
      }
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 1) {
        position = distanceTheaterPositionsMap.get(section);
      }
      if (position != null) {
        lastPosition = position;
      }
      return lastPosition;
    }

    public int getSectionForPosition(final int position) {
      Integer section = null;
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 0) {
        section = alphaTheaterSectionsMap.get(position);
      }
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 1) {
        section = distanceTheaterSectionsMap.get(position);
      }
      if (section != null) {
        lastSection = section;
      }
      return lastSection;
    }

    public Object[] getSections() {
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 0) {
        return actualAlphabetLevels.toArray();
      }
      if (NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex() == 1) {
        return actualDistanceLevels.toArray();
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

    populateFilteredTheaters();
  }

  @Override
  protected void onListItemClick(final ListView listView, final View view, final int position, final long id) {
    final Theater theater = filteredTheaters.get(position);
    final Intent intent = new Intent();
    intent.setClass(this, TheaterDetailsActivity.class);
    intent.putExtra("theater", (Parcelable)theater);
    startActivity(intent);
    super.onListItemClick(listView, view, position, id);
  }
}
