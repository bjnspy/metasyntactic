package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import org.metasyntactic.data.Movie;

import java.util.ArrayList;
import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class AllMoviesActivity extends ListActivity {
  private NowPlayingActivity activity;
  private List<Movie> movies = new ArrayList<Movie>();
  private static MoviesAdapter mAdapter;
  private static Context mContext;


  @Override
  protected void onCreate(Bundle savedInstanceState) {
    // TODO Auto-generated method stub
    super.onCreate(savedInstanceState);
    activity = (NowPlayingActivity) getParent();
    mContext = this;

    // Set up Movies adapter
    mAdapter = new MoviesAdapter(this);
    setListAdapter(mAdapter);
  }


  class MoviesAdapter extends BaseAdapter {
    private Context mContext;

    private LayoutInflater mInflater;


    public MoviesAdapter(Context context) {
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
      ViewHolder holder;
      if (convertView == null) {
        convertView = mInflater.inflate(R.layout.listitem, null);
        // Creates a ViewHolder and store references to the children
        // views we want to bind data to.
        holder = new ViewHolder();
        holder.title = (TextView) convertView.findViewById(R.id.text1);
        holder.rating = (TextView) convertView
            .findViewById(R.id.text2);
        convertView.setTag(holder);
      } else {
        // Get the ViewHolder back to get fast access to the child views
        holder = (ViewHolder) convertView.getTag();
      }
      // Bind the data efficiently with the holder.
      holder.title.setText(movies.get(position).getDisplayTitle());
      CharSequence mRating = (movies.get(position).getRating().equals("")) ?
          mContext.getResources().getText(R.string.unrated) :
          (mContext.getResources().getText(R.string.rated)
              + movies.get(position).getRating());

      holder.rating.setText(mRating);

      return convertView;
    }


    class ViewHolder {
      TextView title;

      TextView rating;
    }


    public int getCount() {
      return movies.size();
    }


    public void refreshMovies() {
      movies = activity.getMovies();
      notifyDataSetChanged();
    }
  }


  public static void refresh() {
    mAdapter.refreshMovies();
  }
}
