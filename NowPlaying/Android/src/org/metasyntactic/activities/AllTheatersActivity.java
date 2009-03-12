package org.metasyntactic.activities;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.RefreshableContext;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Theater;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.views.FastScrollView;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

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
public class AllTheatersActivity extends AbstractNowPlayingListActivity implements RefreshableContext {
  private TheatersAdapter adapter;
  private List<Theater> theaters = new ArrayList<Theater>();
  private final List<Theater> filteredTheaters = new ArrayList<Theater>();
  private final Map<Integer, Integer> theaterIndexToSectionIndex = new HashMap<Integer, Integer>();
  private final Map<Integer, Integer> sectionIndexToTheaterIndex = new HashMap<Integer, Integer>();
  private List<String> distances;
  private final List<String> actualSections = new ArrayList<String>();
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

  @Override protected void onCreateAfterServiceConnected() {
    setupView();
  }

  @Override protected void onResumeAfterServiceConnected() {
    if (adapter != null) {
      adapter.refreshTheaters();
    }
  }

  @Override
  protected void onCreate(final Bundle bundle) {
    LogUtilities.i(getClass().getSimpleName(), "onCreate");
    super.onCreate(bundle);
  }

  @Override
  protected void onResume() {
    super.onResume();
    LogUtilities.i(getClass().getSimpleName(), "onResume");
    registerReceiver(broadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_CHANGED_INTENT));
  }

  @Override
  protected void onPause() {
    LogUtilities.i(getClass().getSimpleName(), "onPause");
    unregisterReceiver(broadcastReceiver);
    super.onPause();
  }

  @Override
  protected void onDestroy() {
    LogUtilities.i(getClass().getSimpleName(), "onDestroy");
    super.onDestroy();
  }

  @Override
  public Map<String,Object> onRetainNonConfigurationInstance() {
    LogUtilities.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");

    return super.onRetainNonConfigurationInstance();
  }

  private final Comparator<Theater> RATING_ORDER = new Comparator<Theater>() {
    public int compare(final Theater m1, final Theater m2) {
      final boolean isFavoriteM1 = service.isFavoriteTheater(m1);
      final boolean isFavoriteM2 = service.isFavoriteTheater(m2);
      if (isFavoriteM1 == isFavoriteM2) {
        return 0;
      } else if (isFavoriteM1) {
        return -1;
      } else {
        return 1;
      }
    }
  };

  private void setupView() {
    theaters = new ArrayList<Theater>(service.getTheaters());
    setContentView(R.layout.theaterlist);
    final ListView list = getListView();
    userLocation = service.getLocationForAddress(service.getUserAddress());
    Collections.sort(theaters, SEARCH_DISTANCE_ORDER);
    // Set up Movies adapter
    adapter = new TheatersAdapter();
    list.setAdapter(adapter);
    populateFilteredTheaters();
    final TextView hiddenTheaters = (TextView)findViewById(R.id.hiddentheaters);
    hiddenTheaters.setOnClickListener(new OnClickListener() {
      public void onClick(final View view) {
        filterTheatersByDistance = !filterTheatersByDistance;

        if (filterTheatersByDistance) {
          hiddenTheaters.setText(getResources().getString(R.string.show_theaters_out_of_range));
        } else {
          hiddenTheaters.setText(getResources().getString(R.string.show_theaters_in_range));
        }
        refresh();
      }
    });
  }

  private void populateFilteredTheaters() {
    filteredTheaters.clear();
    for (final Theater theater : theaters) {
      if (!service.isFavoriteTheater(theater)) {
        if (filterTheatersByDistance) {
          if (userLocation.distanceTo(theater.getLocation()) > service.getSearchDistance()) {
            continue;
          }
        }
      }

      filteredTheaters.add(theater);
    }

    Collections.sort(filteredTheaters, THEATER_ORDER.get(service.getAllTheatersSelectedSortIndex()));
    Collections.sort(filteredTheaters, RATING_ORDER);

    actualSections.clear();
    theaterIndexToSectionIndex.clear();
    sectionIndexToTheaterIndex.clear();

    if (service.getAllTheatersSelectedSortIndex() == 0) {
      populateAlphaTheaterSectionsAndPositions();
    } else {
      populateDistanceTheaterSectionsAndPositions();
    }

    FastScrollView.getSections();
    adapter.refreshTheaters();
  }

  private void populateAlphaTheaterSectionsAndPositions() {
    for (int i = 0; i < filteredTheaters.size(); i++) {
      final Theater theater = filteredTheaters.get(i);
      final String sectionTitle;

      if (service.isFavoriteTheater(theater)) {
        sectionTitle = "★";
      } else {
        sectionTitle = theater.getName().substring(0, 1);
      }

      if (!actualSections.contains(sectionTitle)) {
        actualSections.add(sectionTitle);
      }

      final int sectionIndex = actualSections.indexOf(sectionTitle);
      theaterIndexToSectionIndex.put(i, sectionIndex);
      if (!sectionIndexToTheaterIndex.containsKey(sectionIndex)) {
        sectionIndexToTheaterIndex.put(sectionIndex, i);
      }
    }
  }

  private List<String> getDistances() {
    if (distances == null) {
      distances = new ArrayList<String>();

      final String type = getResources().getString(R.string.miles);
      distances.add(getResources().getString(R.string.less_than_number_string_away, 2, type));
      distances.add(getResources().getString(R.string.less_than_number_string_away, 5, type));
      distances.add(getResources().getString(R.string.less_than_number_string_away, 10, type));
      distances.add(getResources().getString(R.string.less_than_number_string_away, 25, type));
      distances.add(getResources().getString(R.string.less_than_number_string_away, 50, type));
      distances.add(getResources().getString(R.string.less_than_number_string_away, 100, type));
    }

    return distances;
  }

  public static int getDistanceLevel(final double distance) {
    if (distance > 50) {
      return 5;
    } else if (distance > 25) {
      return 4;
    } else if (distance > 10) {
      return 3;
    } else if (distance > 5) {
      return 2;
    } else if (distance > 2) {
      return 1;
    } else {
      return 0;
    }
  }

  private void populateDistanceTheaterSectionsAndPositions() {
    for (int i = 0; i < filteredTheaters.size(); i++) {
      final Theater theater = filteredTheaters.get(i);
      final String sectionTitle;

      if (service.isFavoriteTheater(theater)) {
        sectionTitle = "★";
      } else {
        final double distance = userLocation.distanceTo(theater.getLocation());
        sectionTitle = getDistances().get(getDistanceLevel(distance));
      }

      if (!actualSections.contains(sectionTitle)) {
        actualSections.add(sectionTitle);
      }

      final int sectionIndex = actualSections.indexOf(sectionTitle);
      theaterIndexToSectionIndex.put(i, sectionIndex);
      if (!sectionIndexToTheaterIndex.containsKey(sectionIndex)) {
        sectionIndexToTheaterIndex.put(sectionIndex, i);
      }
    }
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(R.drawable.ic_menu_home).setIntent(new Intent(this, AllTheatersActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SORT, 0, R.string.sort_theaters).setIcon(R.drawable.ic_menu_switch);
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(android.R.drawable.ic_menu_preferences).setIntent(new Intent(this, SettingsActivity.class).putExtra("from_menu", "yes"));
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
      if (service.isFavoriteTheater(theater)) {
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
      final Integer position = sectionIndexToTheaterIndex.get(section);

      if (position == null) {
        return 0;
      }

      return position;
    }

    public int getSectionForPosition(final int position) {
      final Integer section = theaterIndexToSectionIndex.get(position);
      if (section == null) {
        return 0;
      }

      return section;
    }

    public Object[] getSections() {
      return actualSections.toArray();
    }
  }

  @Override public Context getContext() {
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
