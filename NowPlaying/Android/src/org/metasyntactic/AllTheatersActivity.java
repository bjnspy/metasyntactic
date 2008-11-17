package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.os.ConditionVariable;
import android.view.*;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import org.metasyntactic.data.Location;
import org.metasyntactic.data.Theater;
import org.metasyntactic.threading.ThreadingUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/** @author mjoshi@google.com (Megha Joshi) */

public class AllTheatersActivity extends ListActivity implements INowPlaying {
  public static final int MENU_SORT = 1;
  public static final int MENU_SETTINGS = 2;

  private static NowPlayingControllerWrapper controller;
  private static TheatersAdapter adapter;
  private static Context mContext;

  private NowPlayingActivity activity;

  private List<Theater> theaters = new ArrayList<Theater>();

  // variable which controls the theater update thread
  private ConditionVariable condition;
  private ConditionVariable condition2;
  private static Location userLocation;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    // TODO Auto-generated method stub
    super.onCreate(savedInstanceState);

    activity = (NowPlayingActivity) getParent();
    mContext = this;
    controller = activity.getController();
    theaters = controller.getTheaters();
    String userPostalCode = controller.getUserLocation();
    Address address = null;
    try {
      address = new Geocoder(mContext).getFromLocationName(userPostalCode, 1).get(0);
    } catch (IOException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }

    userLocation = new Location(address.getLatitude(), address.getLongitude(), null, null, null, null, null);

    Collections.sort(theaters, THEATER_ORDER.get(controller
        .getAllTheatersSelectedSortIndex()));

    // Set up Movies adapter
    TheatersAdapter mAdapter = new TheatersAdapter(this);
    setListAdapter(mAdapter);
  }

  @Override
  protected void onPause() {
    // stop the thread updating theaters
    condition.open();
    super.onPause();
  }

  @Override
  protected void onResume() {
    // Condition variables controlling the runnables updating
    // the theaters view.
    condition = new ConditionVariable(false);
    if (theaters.size() > 0) {
      condition2 = new ConditionVariable(true);
    } else {
      condition2 = new ConditionVariable(false);
    }
    // update the theaters UI every 5 seconds until all the theaters
    // are loaded.
    Runnable runnable1 = new Runnable() {
      public void run() {
        while (true) {
          if (condition2.block(5 * 1000)) {
            break;
          }
          refresh();
        }
      }
    };
    Thread thread2 = new Thread(null, runnable1);
    thread2.start();

    // update the theaters every 5 minutes after all theaters are loaded.
    Runnable runnable = new Runnable() {
      public void run() {
        while (true) {
          if (condition.block(5 * 60 * 1000)) {
            break;
          }

          refresh();
        }
      }
    };
    Thread thread = new Thread(null, runnable);
    thread.start();

    super.onResume();
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {

    menu.add(0, MENU_SORT, 0, R.string.menu_theater_sort).setIcon(android.R.drawable.star_on);

    menu.add(0, MENU_SETTINGS, 0, R.string.settings)
        .setIcon(android.R.drawable.ic_menu_preferences)
        .setIntent(new Intent(this, SettingsActivity.class))
        .setAlphabeticShortcut('s');

    return super.onCreateOptionsMenu(menu);
  }

  public INowPlaying getNowPlayingActivityContext() {
    return activity;
  }

  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    if (item.getItemId() == MENU_SORT) {
      NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this)

          .setTitle(R.string.theaters_select_sort_title)
          .setKey(NowPlayingPreferenceDialog.Preference_keys.THEATERS_SORT)
          .setEntries(R.array.entries_theaters_sort_preference);
      builder.show();

      return true;
    }
    return false;
  }

  class TheatersAdapter extends BaseAdapter {
    private final Context context;
    private final LayoutInflater inflater;

    public TheatersAdapter(Context context) {
      this.context = context;
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(context);
    }

    public Object getItem(int i) {
      return i;
    }

    public View getView(int position, View convertView, ViewGroup viewGroup) {
      NowPlayingControllerWrapper controller = activity.getController();

      convertView = inflater.inflate(R.layout.theaterview, null);

      // Creates a MovieViewHolder and store references to the
      // children
      // views we want to bind data to.
      MovieViewHolder holder = new MovieViewHolder();
      holder.divider = (ImageView) convertView.findViewById(R.id.divider1);
      holder.title = (TextView) convertView.findViewById(R.id.title);
      holder.address = (TextView) convertView.findViewById(R.id.address);
      holder.header = (TextView) convertView.findViewById(R.id.header);

      // Bind the data efficiently with the holder.
      Theater theater = theaters.get(position);
      Address address = null;
      try {
        address = new Geocoder(context).getFromLocationName(controller.getUserLocation(), 1).get(0);
      } catch (IOException e) {
        // TODO Auto-generated catch block
        e.printStackTrace();
      }
      String headerText = MovieViewUtilities.getTheaterHeader(theaters, position, controller
          .getAllTheatersSelectedSortIndex(), address);
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

    class MovieViewHolder {
      TextView header;
      TextView address;
      TextView title;
      ImageView divider;
    }

    public void refreshTheaters(List<Theater> new_theaters) {
      theaters = new_theaters;
      notifyDataSetChanged();
    }

    public long getItemId(int position) {
      // TODO Auto-generated method stub
      return position;
    }
  }

  public void refresh() {
    if (ThreadingUtilities.isBackgroundThread()) {
      Runnable runnable = new Runnable() {
        public void run() {
          refresh();
        }
      };
      ThreadingUtilities.performOnMainThread(runnable);
      return;
    }
    List<Theater> theaters = controller.getTheaters();
    if (theaters.size() > 0) {
      condition2.open();
    }
    Collections.sort(theaters, THEATER_ORDER.get(controller
        .getAllTheatersSelectedSortIndex()));
    adapter.refreshTheaters(theaters);
  }

  // Define comparators for theater listings sort.
  private static final Comparator<Theater> TITLE_ORDER = new Comparator<Theater>() {
    public int compare(Theater m1, Theater m2) {
      return m1.getName().compareTo(m2.getName());
    }
  };

  private static final Comparator<Theater> DISTANCE_ORDER = new Comparator<Theater>() {
    public int compare(Theater m1, Theater m2) {

      Double dist_m1 = userLocation.distanceTo(m1.getLocation());
      Double dist_m2 = userLocation.distanceTo(m2.getLocation());
      return dist_m1.compareTo(dist_m2);
    }
  };
  // The order of items in this array should match the
  // entries_theater_sort_preference array in res/values/arrays.xml
  private static final List<Comparator<Theater>> THEATER_ORDER = Arrays.asList(TITLE_ORDER, DISTANCE_ORDER);

  public Context getContext() {
    // TODO Auto-generated method stub
    return this;
  }

  public NowPlayingControllerWrapper getController() {
    // TODO Auto-generated method stub
    return controller;
  }
}
