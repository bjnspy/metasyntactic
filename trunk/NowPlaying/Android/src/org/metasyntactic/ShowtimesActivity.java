package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ListView;
import android.widget.TextView;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Theater;

import java.util.ArrayList;
import java.util.List;

public class ShowtimesActivity extends ListActivity {
  /** Called when the activity is first created. */
  private TheaterAdapter theaterAdapter;
  private final List<Theater> theaters = new ArrayList<Theater>();
  private Movie movie;

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper.addActivity(this);
    setContentView(R.layout.showtimes);
    this.movie = getIntent().getExtras().getParcelable("movie");
    this.theaterAdapter = new TheaterAdapter(this);
    setListAdapter(this.theaterAdapter);
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  @Override
  protected void onListItemClick(final ListView l, final View v, final int position, final long id) {
    super.onListItemClick(l, v, position, id);
  }

  class TheaterAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public TheaterAdapter(final Context context) {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(context);
    }

    public Object getEntry(final int i) {
      return i;
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = this.inflater.inflate(R.layout.showtimes_item, null);
      // Creates a MovieViewHolder and store references to the
      // children views we want to bind data to.
      final MovieViewHolder holder = new MovieViewHolder();
      holder.theater = (TextView) convertView.findViewById(R.id.theater);
      holder.showtimes = (TextView) convertView.findViewById(R.id.showtimes);
      holder.address = (TextView) convertView.findViewById(R.id.address);
      holder.phone = (TextView) convertView.findViewById(R.id.phone);
      final Theater theater = ShowtimesActivity.this.theaters.get(position);
      holder.theater.setText(theater.getName());
      holder.address.setText(theater.getAddress() + ", " + theater.getLocation().getCity());
      holder.phone.setText(theater.getPhoneNumber());
      final List<Performance> list = NowPlayingControllerWrapper.getPerformancesForMovieAtTheater(ShowtimesActivity.this.movie, theater);
      String performance = "";
      if (list != null) {
        for (int i = 0; i < list.size(); i++) {
          performance += list.get(i).getTime() + ", ";
        }

        holder.showtimes.setText(performance.substring(0, performance.length() - 2));
      } else {
        holder.showtimes.setText("Unknown.");
      }

      return convertView;
    }

    public int getCount() {
      return ShowtimesActivity.this.theaters.size();
    }

    private class MovieViewHolder {
      TextView theater;
      TextView showtimes;
      TextView address;
      TextView phone;
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
}
