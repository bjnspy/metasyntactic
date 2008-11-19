package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.os.ConditionVariable;
import android.os.Parcelable;
import android.view.*;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Theater;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.io.IOException;
import java.util.*;

/** @author mjoshi@google.com (Megha Joshi) */
public class AllTheatersActivity extends ListActivity implements INowPlaying {
  public static final int MENU_SORT = 1;
  public static final int MENU_SETTINGS = 2;

  private Pulser pulser;
  private TheatersAdapter adapter;
  private NowPlayingActivity activity;
  private List<Theater> theaters = new ArrayList<Theater>();
  // variable which controls the theater update thread
  private ConditionVariable condition;
  private ConditionVariable condition2;
  private Location userLocation;

  private Address userAddress;

  // Define comparators for theater listings sort.
  private final Comparator<Theater> TITLE_ORDER = new Comparator<Theater>() {
    public int compare(Theater m1, Theater m2) {
      return m1.getName().compareTo(m2.getName());
    }
  };
  private final Comparator<Theater> DISTANCE_ORDER = new Comparator<Theater>() {
    public int compare(Theater m1, Theater m2) {
      Double dist_m1 = userLocation.distanceTo(m1.getLocation());
      Double dist_m2 = userLocation.distanceTo(m2.getLocation());
      return dist_m1.compareTo(dist_m2);
    }
  };
  // The order of items in this array should match the
  // entries_theater_sort_preference array in res/values/arrays.xml
  private final List<Comparator<Theater>> THEATER_ORDER = Arrays.asList(TITLE_ORDER, DISTANCE_ORDER);


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.addActivity(this);
    setupView();
    refresh();
  }

  private void setupView() {
    theaters = NowPlayingControllerWrapper.getTheaters();
    String userPostalCode = NowPlayingControllerWrapper.getUserLocation();

    try {
      userAddress = new Geocoder(this).getFromLocationName(userPostalCode, 1).get(0);
    } catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }
    userLocation = new Location(userAddress.getLatitude(), userAddress
        .getLongitude(), null, null, null, null, null);

    Collections.sort(theaters, THEATER_ORDER.get(NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex()));
    // Set up Movies adapter
    adapter = new TheatersAdapter();
    setListAdapter(adapter);
  }

  public INowPlaying getNowPlayingActivityContext() {
    return activity;
  }

  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    if (item.getItemId() == MENU_SORT) {
      NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this).setTitle(
          R.string.theaters_select_sort_title).setKey(NowPlayingPreferenceDialog.Preference_keys.THEATERS_SORT)
          .setEntries(R.array.entries_theaters_sort_preference)
          .show();
      return true;
    }
    return true;
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {

    menu.add(0, MENU_SORT, 0, R.string.menu_theater_sort).setIcon(android.R.drawable.star_on);

    menu.add(0, MENU_SETTINGS, 0, R.string.settings)
        .setIcon(android.R.drawable.ic_menu_preferences)
        .setIntent(new Intent(this, SettingsActivity.class))
        .setAlphabeticShortcut('s');

    return super.onCreateOptionsMenu(menu);
  }

  private class TheatersAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public TheatersAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(getContext());
    }

    public Object getItem(final int i) {
      return i;
    }

    public View getView(int position, View convertView, ViewGroup viewGroup) {

      convertView = inflater.inflate(R.layout.theaterview, null);
      // Creates a MovieViewHolder and store references to the
      // children
      // views we want to bind data to.
      MovieViewHolder holder = new MovieViewHolder();
      holder.divider = (ImageView) convertView
          .findViewById(R.id.divider1);
      holder.title = (TextView) convertView.findViewById(R.id.title);
      holder.address = (TextView) convertView.findViewById(R.id.address);
      holder.header = (TextView) convertView.findViewById(R.id.header);
      // Bind the data efficiently with the holder.
      Resources res = AllTheatersActivity.this.getResources();
      Theater theater = theaters.get(position);

      String headerText = MovieViewUtilities.getTheaterHeader(theaters, position,
                                                              NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex(),
                                                              userAddress);

      if (headerText != null) {
        holder.header.setVisibility(1);
        holder.header.setText(headerText);
      } else {
        holder.header.setVisibility(-1);
        holder.header.setHeight(0);
        holder.divider.setVisibility(-1);
        holder.divider.setMaxHeight(0);
      }
      holder.title.setText(theater.getName());
      holder.address.setText(theater.getAddress() + ", " + theater.getLocation().getCity());
      return convertView;
    }

    public int getCount() {
      return theaters.size();
    }

    private class MovieViewHolder {
      TextView header;
      TextView address;
      TextView title;
      ImageView divider;
    }

    public void refreshTheaters(List<Theater> new_theaters) {
      theaters = new_theaters;
      notifyDataSetChanged();
    }

    public long getItemId(final int position) {
      return position;
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

    Collections.sort(theaters, THEATER_ORDER.get(NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex()));
    adapter.refreshTheaters(theaters);
  }

  @Override
  protected void onListItemClick(ListView l, View v, int position, long id) {
    // TODO Auto-generated method stub
    Theater theater = theaters.get(position);
    Intent intent = new Intent();
    intent.setClass(this, TheaterDetailsActivity.class);
    intent.putExtra("theater", (Parcelable) theater);
    startActivity(intent);
    super.onListItemClick(l, v, position, id);
  }
}
