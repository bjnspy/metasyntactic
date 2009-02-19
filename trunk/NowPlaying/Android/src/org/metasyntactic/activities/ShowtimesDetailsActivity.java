package org.metasyntactic.activities;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ListActivity;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.*;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Theater;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.utilities.StringUtilities;

import java.util.ArrayList;
import java.util.List;

public class ShowtimesDetailsActivity extends ListActivity {
  private Theater theater;
  private Movie movie;
  private final List<TheaterDetailItem> detailItems = new ArrayList<TheaterDetailItem>();
  private List<Performance> performances = new ArrayList<Performance>();
  private final List<String> showtimes = new ArrayList<String>();
  private final List<String> showtimes_url = new ArrayList<String>();

  private enum TheaterDetailItemType {
    NAME_SHOWTIMES, ADDRESS, PHONE
  }

  @Override protected void onListItemClick(final ListView listView, final View view, final int position, final long id) {
    final Intent intent = detailItems.get(position).getIntent();
    if (intent != null) {
      startActivity(intent);
    }
    super.onListItemClick(listView, view, position, id);
  }

  @Override public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Log.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);
    setContentView(R.layout.showtimedetails);
    movie = getIntent().getExtras().getParcelable("movie");
    theater = getIntent().getExtras().getParcelable("theater");
    performances = NowPlayingControllerWrapper.getPerformancesForMovieAtTheater(movie, theater);
    for (final Performance per : performances) {
      if (per != null && !StringUtilities.isNullOrEmpty(per.getUrl())) {
        showtimes.add(per.getTime());
        showtimes_url.add(per.getUrl());
      }
    }
    populateTheaterDetailItem();
    final TheaterAdapter theaterAdapter = new TheaterAdapter();
    setListAdapter(theaterAdapter);
    final TextView theaterTxt = (TextView) findViewById(R.id.theater);
    theaterTxt.setText(theater.getName());
    final Button orderTickets = (Button) findViewById(R.id.showtimes);
    orderTickets.setOnClickListener(new OnClickListener() {
      public void onClick(final View v) {
        showDialog(1);
      }
    });
    if (!showtimes.isEmpty()) {
      findViewById(R.id.bottom_bar).setVisibility(View.VISIBLE);
    }
  }

  @Override protected void onResume() {
    super.onResume();
    Log.i(getClass().getSimpleName(), "onResume");
  }

  @Override protected void onPause() {
    super.onPause();
    Log.i(getClass().getSimpleName(), "onPause");
  }

  @Override protected void onDestroy() {
    Log.i(getClass().getSimpleName(), "onDestroy");
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override public Object onRetainNonConfigurationInstance() {
    Log.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    final Object result = new Object();
    NowPlayingControllerWrapper.onRetainNonConfigurationInstance(this, result);
    return result;
  }

  private void populateTheaterDetailItem() {
    // Add name_showtimes type
    TheaterDetailItem entry1 = new TheaterDetailItem();
    entry1.setType(TheaterDetailItemType.NAME_SHOWTIMES);
    detailItems.add(entry1);
    // Add address type
    entry1 = new TheaterDetailItem();
    entry1.setType(TheaterDetailItemType.ADDRESS);
    detailItems.add(entry1);
    // Add phone type
    entry1 = new TheaterDetailItem();
    entry1.setType(TheaterDetailItemType.PHONE);
    detailItems.add(entry1);
  }

  private class TheaterAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    private TheaterAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(ShowtimesDetailsActivity.this);
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = inflater.inflate(R.layout.showtimes_item, null);
      final Resources res = getResources();
      final TheaterDetailsViewHolder holder = new TheaterDetailsViewHolder((TextView) convertView.findViewById(R.id.label), (ImageView) convertView
          .findViewById(R.id.icon), (TextView) convertView.findViewById(R.id.data));
      final int theaterIndex = position / TheaterDetailItemType.values().length;
      switch (detailItems.get(position).getType()) {
      case NAME_SHOWTIMES:
        holder.label.setText(res.getString(R.string.showtimes_for, movie.getCanonicalTitle(), theater.getName()));
        holder.icon.setImageDrawable(getResources().getDrawable(R.drawable.sym_action_email));
        String performance = "";
        for (final Performance per : performances) {
          performance += per.getTime() + ", ";
        }
        performance = performance.substring(0, performance.length() - 2);
        holder.data.setText(performance);
        final String addr = "user@example.com";
        final Intent intent1 = new Intent(Intent.ACTION_SENDTO, Uri.parse("mailto:" + addr));
        intent1.putExtra("subject", res.getString(R.string.showtimes_for, movie.getDisplayTitle(), theater.getName()));
        intent1.putExtra("body", performance);
        detailItems.get(position).setIntent(intent1);
        break;
      case PHONE:
        holder.data.setText(theater.getPhoneNumber());
        holder.icon.setImageDrawable(getResources().getDrawable(R.drawable.sym_action_call));
        holder.label.setText(res.getString(R.string.call));
        final Intent intent2 = new Intent("android.intent.action.DIAL", Uri.parse("tel:" + theater.getPhoneNumber()));
        detailItems.get(position).setIntent(intent2);
        break;
      case ADDRESS:
        final String address = theater.getAddress() + ", "
        + theater.getLocation().getCity();
        holder.data.setText(address);
        holder.icon.setImageDrawable(getResources().getDrawable(R.drawable.sym_action_map));
        holder.label.setText(res.getString(R.string.location));
        final Intent intent3 = new Intent("android.intent.action.VIEW", Uri.parse("geo:0,0?q=" + address));
        detailItems.get(position).setIntent(intent3);
      }
      return convertView;
    }

    public int getCount() {
      return detailItems.size();
    }

    private class TheaterDetailsViewHolder {
      private final TextView label;
      private final ImageView icon;
      private final TextView data;

      private TheaterDetailsViewHolder(final TextView label, final ImageView icon, final TextView data) {
        this.label = label;
        this.icon = icon;
        this.data = data;
      }
    }

    public long getEntryId(final int position) {
      return position;
    }

    public Object getItem(final int position) {
      return detailItems.get(position);
    }

    public long getItemId(final int position) {
      return position;
    }

    public void refresh() {
      notifyDataSetChanged();
    }
  }

  private static class TheaterDetailItem {
    private TheaterDetailItemType type;
    private Intent intent;

    public Intent getIntent() {
      return intent;
    }

    public void setIntent(final Intent intent) {
      this.intent = intent;
    }

    public TheaterDetailItemType getType() {
      return type;
    }

    public void setType(final TheaterDetailItemType type) {
      this.type = type;
    }
  }

  @Override public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_MOVIES, 0, R.string.menu_movies).setIcon(R.drawable.ic_menu_home).setIntent(
        new Intent(this, NowPlayingActivity.class));
    menu.add(0, MovieViewUtilities.MENU_SETTINGS, 0, R.string.settings).setIcon(android.R.drawable.ic_menu_preferences).setIntent(
        new Intent(this, SettingsActivity.class));
    return super.onCreateOptionsMenu(menu);
  }

  @Override protected Dialog onCreateDialog(final int id) {
    final String[] criteria = new String[showtimes.size()];
    showtimes.toArray(criteria);
    return new AlertDialog.Builder(this).setTitle(R.string.order_tickets).setItems(criteria, new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialog, final int which) {
        final String order_url = showtimes_url.get(which);
        final Intent intent = new Intent("android.intent.action.VIEW", Uri.parse(order_url));
        startActivity(intent);
      }
    }).create();
  }
}
