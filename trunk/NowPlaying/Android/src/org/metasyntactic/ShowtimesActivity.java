package org.metasyntactic;

import android.app.ListActivity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.res.Resources;
import android.os.Bundle;
import android.os.IBinder;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.TextView;

import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;

import java.util.ArrayList;
import java.util.List;

public class ShowtimesActivity extends ListActivity {
    /** Called when the activity is first created. */
    NowPlayingControllerWrapper controller;
    private Context mContext;
    TheaterAdapter theaterAdapter;
    List<Theater> theaters = new ArrayList<Theater>();

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.showtimes);
        movie = this.getIntent().getExtras().getParcelable("movie");
        mContext = this;
        theaterAdapter = new TheaterAdapter(this);
        setListAdapter(theaterAdapter);
    }

    private final ServiceConnection serviceConnection = new ServiceConnection() {
        public void onServiceConnected(ComponentName className, IBinder service) {
            // This is called when the connection with the service has been
            // established, giving us the service object we can use to
            // interact with the service. We are communicating with our
            // service through an IDL interface, so get a client-side
            // representation of that from the raw service object.
            controller = new NowPlayingControllerWrapper(
                    INowPlayingController.Stub.asInterface(service));
           
            bindView(movie);
           // theaters = controller.getTheaters(movie);
        }

        public void onServiceDisconnected(ComponentName className) {
            controller = null;
        }
    };

    @Override
    protected void onDestroy() {
        unbindService(serviceConnection);
        super.onDestroy();
    }

    private void bindView(final Movie movie) {
        TextView movielbl = (TextView) findViewById(R.id.movie);
       movielbl.setText(movie.getDisplayTitle());
    }

   
    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
        boolean bindResult = bindService(new Intent(getBaseContext(),
                NowPlayingControllerService.class), serviceConnection,
                Context.BIND_AUTO_CREATE);
        if (!bindResult) {
            throw new RuntimeException("Failed to bind to service!");
        }
    }

   
    class TheaterAdapter extends BaseAdapter {
        private final Context context;
        private final LayoutInflater inflater;

        public TheaterAdapter(Context context) {
            this.context = context;
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
         /*   Theater theater = theaters.get(position);
            holder.theater.setText(theater.getName());
            holder.address.setText(theater.getAddress() + ", " + theater.getLocation().getCity());
            holder.phone.setText(theater.getPhoneNumber());*/
            // todo add showtimes
            holder.showtimes.setText("11:00am, 2:00pm, 3:00pm, 7:30pm, 8:30pm, 9:00pm, 10:30pm, 11:30pm");
            holder.theater.setText("AMC Cupetino Square-16");
            holder.address.setText("10123 N. Wolfe Road, Cupertino");
            holder.phone.setText("408-242-2993");
            return convertView;
        }

        public int getCount() {
         //   return theaters.size();
            return 5;
        }

        private class MovieViewHolder {
            TextView theater;
            TextView showtimes;
            TextView address;
            TextView phone;
        }

        public long getEntryId(int position) {
            // TODO Auto-generated method stub
            return position;
        }

        @Override
        public Object getItem(int position) {
            // TODO Auto-generated method stub
            return theaters.get(position);
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
