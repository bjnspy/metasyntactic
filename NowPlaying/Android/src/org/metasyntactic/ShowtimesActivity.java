package org.metasyntactic;

import android.app.ListActivity;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Theater;

import java.util.ArrayList;
import java.util.List;

public class ShowtimesActivity extends ListActivity {
  private List<Theater> theaters;
  private Movie movie;
  private final List<TheaterDetailItem> detailItems = new ArrayList<TheaterDetailItem>();

  enum TheaterDetailItemType {
    NAME_SHOWTIMES, ADDRESS, PHONE
  }

  @Override
  protected void onListItemClick(final ListView l, final View v, final int position, final long id) {
    final Intent intent = this.detailItems.get(position).getIntent();
    if (intent != null) {
      startActivity(intent);
    }
    super.onListItemClick(l, v, position, id);
  }

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.addActivity(this);
    setContentView(R.layout.showtimes);
    this.movie = getIntent().getExtras().getParcelable("movie");
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  private void bindView() {
    final TextView movielbl = (TextView) findViewById(R.id.movie);
    movielbl.setEllipsize(TextUtils.TruncateAt.END);
    movielbl.setText(this.movie.getDisplayTitle());
    this.theaters = NowPlayingControllerWrapper.getTheatersShowingMovie(this.movie);
  }

  private void populateTheaterDetailItems() {
    for (Theater theater : this.theaters) {
      populateTheaterDetailItem();
    }
  }

  private void populateTheaterDetailItem() {
    // Add name_showtimes type
    TheaterDetailItem entry1 = new TheaterDetailItem();
    entry1.setType(TheaterDetailItemType.NAME_SHOWTIMES);
    this.detailItems.add(entry1);
    // Add address type
    entry1 = new TheaterDetailItem();
    entry1.setType(TheaterDetailItemType.ADDRESS);
    this.detailItems.add(entry1);
    // Add phone type
    entry1 = new TheaterDetailItem();
    entry1.setType(TheaterDetailItemType.PHONE);
    this.detailItems.add(entry1);
  }

  @Override
  protected void onResume() {
    super.onResume();
    bindView();
    populateTheaterDetailItems();
    TheaterAdapter theaterAdapter = new TheaterAdapter();
    setListAdapter(theaterAdapter);
  }

  private class TheaterAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public TheaterAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(ShowtimesActivity.this);
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = this.inflater.inflate(R.layout.showtimes_item, null);
      final TheaterDetailsViewHolder holder = new TheaterDetailsViewHolder((TextView) convertView.findViewById(
          R.id.label), (ImageView) convertView.findViewById(R.id.icon), (TextView) convertView.findViewById(R.id.data));

      final int theaterIndex = position / TheaterDetailItemType.values().length;
      final Theater theater = ShowtimesActivity.this.theaters.get(theaterIndex);
      switch (ShowtimesActivity.this.detailItems.get(position).getType()) {
        case NAME_SHOWTIMES:
          holder.label.setTextAppearance(ShowtimesActivity.this, android.R.attr.textAppearanceLarge);
          // holder.label.setTextColor(Color.BLACK);
          holder.label.setMinHeight(50);
          holder.label
              .setBackgroundColor(Color.parseColor("#808080"));
         holder.label.setTextColor(Color.WHITE);
          holder.label.setText(theater.getName());
          final List<Performance> list = NowPlayingControllerWrapper
              .getPerformancesForMovieAtTheater(ShowtimesActivity.this.movie, theater);
          holder.icon.setImageDrawable(ShowtimesActivity.this.getResources()
              .getDrawable(android.R.drawable.sym_action_email));
          String performance = "";
          if (list != null) {
            for (Performance per : list) {
              performance += per.getTime() + ", ";
            }
            performance = performance.substring(0, performance.length() - 2);
            holder.data.setText(performance);
            final String addr = "user@example.com";
            final Intent intent1 = new Intent(Intent.ACTION_SENDTO, Uri
                .parse("mailto:" + addr));
            intent1.putExtra("subject", "ShowTimes for " + ShowtimesActivity.this.movie
                .getDisplayTitle() + " at " + theater.getName());
            intent1.putExtra("body", performance);
            ShowtimesActivity.this.detailItems.get(position).setIntent(intent1);
          } else {
            holder.data.setText("Unknown.");
          }
          break;
        case PHONE:
          holder.data.setText(theater.getPhoneNumber());
          holder.icon.setImageDrawable(ShowtimesActivity.this.getResources()
              .getDrawable(android.R.drawable.sym_action_call));
          holder.label.setText("Phone");
          final Intent intent2 = new Intent("android.intent.action.DIAL", Uri.parse("tel:" + theater.getPhoneNumber()));
          ShowtimesActivity.this.detailItems.get(position).setIntent(intent2);
          break;
        case ADDRESS:
          final String address = theater.getAddress() + ", " + theater.getLocation().getCity();
          holder.data.setText(address);
          holder.icon.setImageDrawable(ShowtimesActivity.this.getResources()
              .getDrawable(R.drawable.sym_action_map));
          holder.label.setText("Address");
          final Intent intent3 = new Intent("android.intent.action.VIEW", Uri.parse("geo:0,0?q=" + address));
          ShowtimesActivity.this.detailItems.get(position).setIntent(intent3);
      }
      return convertView;
    }

    public int getCount() {
      return ShowtimesActivity.this.detailItems.size();
    }

    private class TheaterDetailsViewHolder {
      private final TextView label;
      private final ImageView icon;
      private final TextView data;

      private TheaterDetailsViewHolder(TextView label, ImageView icon, TextView data) {
        this.label = label;
        this.icon = icon;
        this.data = data;
      }
    }

    public long getEntryId(final int position) {
      return position;
    }

    public Object getItem(final int position) {
      return ShowtimesActivity.this.theaters.get(position);
    }

    public long getItemId(final int position) {
      return position;
    }

    public void refresh() {
      notifyDataSetChanged();
    }
  }

  private class TheaterDetailItem {
    private TheaterDetailItemType type;
    private Intent intent;

    public Intent getIntent() {
      return this.intent;
    }

    public void setIntent(final Intent intent) {
      this.intent = intent;
    }

    public TheaterDetailItemType getType() {
      return this.type;
    }

    public void setType(final TheaterDetailItemType type) {
      this.type = type;
    }
  }
}
