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
  private List<Theater> theaters = new ArrayList<Theater>();
  private Movie movie;

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    NowPlayingControllerWrapper1.addActivity(this);
    setContentView(R.layout.showtimes);
    movie = this.getIntent().getExtras().getParcelable("movie");
    theaterAdapter = new TheaterAdapter(this);
    setListAdapter(theaterAdapter);
  }

  @Override
  protected void onDestroy() {
    NowPlayingControllerWrapper1.removeActivity(this);
    super.onDestroy();
  }

  @Override
  protected void onListItemClick(ListView l, View v, int position, long id) {
    super.onListItemClick(l, v, position, id);
  }

  private void bindView(final Movie movie) {
    TextView movielbl = (TextView) findViewById(R.id.movie);
    movielbl.setEllipsize(TextUtils.TruncateAt.END);
    movielbl.setText(movie.getDisplayTitle());
  }

  class TheaterAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    public TheaterAdapter(Context context) {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(context);
    }

    public Object getEntry(int i) {
      return i;
    }

    public View getView(int position, View convertView, ViewGroup viewGroup) {
      convertView = inflater.inflate(R.layout.showtimes_item, null);
      // Creates a MovieViewHolder and store references to the
      // children views we want to bind data to.
      MovieViewHolder holder = new MovieViewHolder();
      holder.theater = (TextView) convertView.findViewById(R.id.theater);
      holder.showtimes = (TextView) convertView.findViewById(R.id.showtimes);
      holder.address = (TextView) convertView.findViewById(R.id.address);
      holder.phone = (TextView) convertView.findViewById(R.id.phone);
      Theater theater = theaters.get(position);
      holder.theater.setText(theater.getName());
      holder.address.setText(theater.getAddress() + ", " + theater.getLocation().getCity());
      holder.phone.setText(theater.getPhoneNumber());
      List<Performance> list = NowPlayingControllerWrapper1.getPerformancesForMovieAtTheater(movie, theater);
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
      return theaters.size();
    }

    private class MovieViewHolder {
      TextView theater;
      TextView showtimes;
      TextView address;
      TextView phone;
    }

    public long getEntryId(int position) {
      return position;
    }

    public Object getItem(int position) {
      return theaters.get(position);
    }

    public long getItemId(int position) {
      return position;
    }

    public void refresh() {
      notifyDataSetChanged();
    }
  }
}
