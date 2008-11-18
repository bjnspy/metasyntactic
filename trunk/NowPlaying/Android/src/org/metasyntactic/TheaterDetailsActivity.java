package org.metasyntactic;

import android.app.ListActivity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcelable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import org.metasyntactic.ShowtimesActivity.TheaterDetailItemType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Theater;

import java.util.ArrayList;
import java.util.List;

public class TheaterDetailsActivity extends ListActivity {
    /** Called when the activity is first created. */
    NowPlayingControllerWrapper controller;
    private Context mContext;
    private Theater theater;
    MoviesAdapter moviesAdapter;
    List<Movie> movies = new ArrayList<Movie>();
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        NowPlayingControllerWrapper.removeActivity(this);
        setContentView(R.layout.theaterdetails);
        theater = this.getIntent().getExtras().getParcelable("theater");
        
        mContext = this;
        bindView();
    }

      

    @Override
    protected void onListItemClick(ListView l, View v, int position, long id) {
        // TODO Auto-generated method stub
        Movie movie = movies.get(position);
        Intent intent = new Intent();
        intent.setClass(mContext,MovieDetailsActivity.class);
        intent.putExtra("movie",(Parcelable)movie);
       
       startActivity(intent);
        super.onListItemClick(l, v, position, id);
    }

  

   
    @Override
    protected void onDestroy() {
        // TODO Auto-generated method stub
        NowPlayingControllerWrapper.removeActivity(this);
        super.onDestroy();
    }



    private void bindView() {
        TextView theaterlbl = (TextView) findViewById(R.id.theater);
        theaterlbl.setEllipsize(TextUtils.TruncateAt.END);
        theaterlbl.setText(theater.getName());
        
        TextView phonelbl = (TextView) findViewById(R.id.phone);
        phonelbl.setEllipsize(TextUtils.TruncateAt.END);
        phonelbl.setText(theater.getPhoneNumber());
        
        TextView maplbl = (TextView) findViewById(R.id.map);
        maplbl.setEllipsize(TextUtils.TruncateAt.END);
        maplbl.setText(theater.getAddress() + ", " + theater.getLocation().getCity());
        
        moviesAdapter = new MoviesAdapter(this);
        setListAdapter(moviesAdapter);
    }

    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
     
    }

    class MoviesAdapter extends BaseAdapter {
        private final Context context;
        private final LayoutInflater inflater;

        public MoviesAdapter(Context context) {
           this.context = context;
            // Cache the LayoutInflate to avoid asking for a new one each time.
            inflater = LayoutInflater.from(context);
        }
        public Object getEntry(int i) {
            return i;
        }

        public View getView(int position, View convertView, ViewGroup viewGroup) {
            convertView = inflater.inflate(R.layout.theaterdetails_item, null);
            MovieViewHolder holder = new MovieViewHolder();
            holder.label = (TextView) convertView.findViewById(R.id.label);
            
            holder.data = (TextView) convertView.findViewById(R.id.data);
            int theaterIndex = position / TheaterDetailItemType.values().length;
            Movie movie = movies.get(position);
            holder.label.setText(movie.getDisplayTitle());
                    List<Performance> list = controller
                            .getPerformancesForMovieAtTheater(movie, theater);
                  
                    String performance = "";
                    if (list != null) {
                        for (int i = 0; i < list.size(); i++) {
                            performance += list.get(i).getTime() + ", ";
                        }
                        performance = performance.substring(0, performance
                                .length() - 2);
                        holder.data.setText(performance);
                      
                    } else {
                        holder.data.setText("Unknown.");
                    }
                
             
          
            return convertView;
        }

        public int getCount() {
            return movies.size();
        }

        private class MovieViewHolder {
            TextView label;
                       TextView data;
        }

        public long getEntryId(int position) {
            // TODO Auto-generated method stub
            return position;
        }

        @Override
        public Object getItem(int position) {
            // TODO Auto-generated method stub
            return movies.get(position);
        }

        @Override
        public long getItemId(int position) {
            // TODO Auto-generated method stub
            return position;
        }

        public void refresh() {
            // TODO Auto-generated method stub
            notifyDataSetChanged();
        }
    }
   
    private Movie movie;

}
