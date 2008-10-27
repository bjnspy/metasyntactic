package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.*;
import android.widget.BaseAdapter;
import android.widget.TextView;
import org.metasyntactic.data.Theater;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.util.ArrayList;
import java.util.List;

/** @author mjoshi@google.com (Megha Joshi) */
public class AllTheatersActivity extends ListActivity {
  private NowPlayingActivity activity;
  private List<Theater> theaters = new ArrayList<Theater>();
  private static TheatersAdapter mAdapter;
  private static Context mContext;

  public static final int MENU_SORT = 1;
  public static final int MENU_SETTINGS = 2;


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    // TODO Auto-generated method stub
    super.onCreate(savedInstanceState);
    activity = (NowPlayingActivity) getParent();
    mContext = this;

    theaters = activity.getController().getTheaters();
    // Set up Movies adapter
    mAdapter = new TheatersAdapter(this);
    setListAdapter(mAdapter);
  }


  @Override
  public boolean onCreateOptionsMenu(Menu menu) {

    menu.add(0, MENU_SORT, 0, R.string.menu_theater_sort)
        .setIcon(android.R.drawable.star_on);

    menu.add(0, MENU_SETTINGS, 0, R.string.menu_settings)
        .setIcon(android.R.drawable.ic_menu_preferences)
        .setIntent(new Intent(this, SettingsActivity.class))
        .setAlphabeticShortcut('s');

    return super.onCreateOptionsMenu(menu);
  }


  public NowPlayingActivity getNowPlayingActivityContext() {
    return activity;
  }


  @Override
  public boolean onOptionsItemSelected(MenuItem item) {
    if (item.getItemId() == MENU_SORT) {
      NowPlayingPreferenceDialog builder = new NowPlayingPreferenceDialog(this.activity)

          .setTitle(R.string.theaters_select_sort_title)
          .setKey(NowPlayingPreferenceDialog.Preference_keys.THEATERS_SORT)
          .setEntries(R.array.entries_theaters_sort_preference)
          .show();

      return true;
    }
    return false;
  }


  class TheatersAdapter extends BaseAdapter {
    private Context mContext;

    private LayoutInflater mInflater;


    public TheatersAdapter(Context context) {
      mContext = context;
      // Cache the LayoutInflate to avoid asking for a new one each time.
      mInflater = LayoutInflater.from(context);

    }


    public Object getItem(int i) {
      return i;
    }


    public long getItemId(int i) {
      return i;
    }


    public View getView(int position, View convertView, ViewGroup viewGroup) {
      MovieViewHolder holder;
      if (convertView == null) {
        convertView = mInflater.inflate(R.layout.theaterview, null);
        // Creates a MovieViewHolder and store references to the
        // children
        // views we want to bind data to.
        holder = new MovieViewHolder();
        holder.title = (TextView) convertView.findViewById(R.id.title);
        holder.address = (TextView) convertView.findViewById(R.id.address);

        convertView.setTag(holder);
      } else {
        // Get the MovieViewHolder back to get fast access to the child
        // views
        holder = (MovieViewHolder) convertView.getTag();
      }
      // Bind the data efficiently with the holder.
      Resources res = mContext.getResources();
      Theater theater = theaters.get(position);
      holder.title.setText(theater.getName());
      holder.address.setText(theater.getAddress());

      return convertView;
    }


    class MovieViewHolder {
      TextView address;

      TextView title;
    }


    public int getCount() {
      return theaters.size();
    }


    public void refreshTheaters(List<Theater> new_theaters) {
      theaters = new_theaters;
      notifyDataSetChanged();
    }
  }


  public static void refresh(List<Theater> theaters) {
    mAdapter.refreshTheaters(theaters);
  }
}
