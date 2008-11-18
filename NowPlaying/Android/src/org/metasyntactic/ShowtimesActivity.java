package org.metasyntactic;

import android.app.ListActivity;
import android.content.Context;
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
    /** Called when the activity is first created. */
    private TheaterAdapter theaterAdapter;
    private List<Theater> theaters ;
    private Movie movie;
    private List<TheaterDetailItem> detailItems = new ArrayList<TheaterDetailItem>();
    private Context mContext;

    enum TheaterDetailItemType {
        NAME_SHOWTIMES, ADDRESS, PHONE
    }

    @Override
    protected void onListItemClick(ListView l, View v, int position, long id) {
        // TODO Auto-generated method stub
        Intent intent = detailItems.get(position).getIntent();
        if (intent != null) startActivity(intent);
        super.onListItemClick(l, v, position, id);
    }

    @Override
    public void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        NowPlayingControllerWrapper.addActivity(this);
        setContentView(R.layout.showtimes);
        mContext = this;
        this.movie = getIntent().getExtras().getParcelable("movie");
    }

    @Override
    protected void onDestroy() {
        NowPlayingControllerWrapper.removeActivity(this);
        super.onDestroy();
    }
    private void bindView() {
        TextView movielbl = (TextView) findViewById(R.id.movie);
        movielbl.setEllipsize(TextUtils.TruncateAt.END);
        movielbl.setText(movie.getDisplayTitle());
        theaters = NowPlayingControllerWrapper.getTheatersShowingMovie(movie);
      
    }

    private void populateTheaterDetailItems() {
        // TODO Auto-generated method stub
        for (int i = 0; i < theaters.size(); i++) {
            populateTheaterDetailItem();
        }
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

   
    @Override
    protected void onResume() {
        // TODO Auto-generated method stub
        super.onResume();
        bindView();
        populateTheaterDetailItems();
        theaterAdapter = new TheaterAdapter(this);
        setListAdapter(theaterAdapter);
    }

    class TheaterAdapter extends BaseAdapter {
        private final Context context;
        private final LayoutInflater inflater;

        public TheaterAdapter(Context context) {
            this.context = context;
            // Cache the LayoutInflate to avoid asking for a new one each time.
            inflater = LayoutInflater.from(context);
        }

        public View getView(int position, View convertView, ViewGroup viewGroup) {
            convertView = inflater.inflate(R.layout.showtimes_item, null);
            TheaterDetailsViewHolder holder = new TheaterDetailsViewHolder();
            holder.label = (TextView) convertView.findViewById(R.id.label);
            holder.icon = (ImageView) convertView.findViewById(R.id.icon);
            holder.data = (TextView) convertView.findViewById(R.id.data);
            int theaterIndex = position / TheaterDetailItemType.values().length;
            Theater theater = theaters.get(theaterIndex);
            switch (detailItems.get(position).getType()) {
                case NAME_SHOWTIMES:
                    holder.label.setTextAppearance(mContext,
                            android.R.attr.textAppearanceLarge);
                    // holder.label.setTextColor(Color.BLACK);
                    holder.label.setMinHeight(50);
                    holder.label
                            .setBackgroundColor(Color.parseColor("#2c2c2b"));
                    holder.label.setText(theater.getName());
                    List<Performance> list = NowPlayingControllerWrapper
                            .getPerformancesForMovieAtTheater(movie, theater);
                    holder.icon.setImageDrawable(mContext.getResources()
                            .getDrawable(android.R.drawable.sym_action_email));
                    String performance = "";
                    if (list != null) {
                        for (int i = 0; i < list.size(); i++) {
                            performance += list.get(i).getTime() + ", ";
                        }
                        performance = performance.substring(0, performance
                                .length() - 2);
                        holder.data.setText(performance);
                        String addr = "user@example.com";
                        Intent intent1 = new Intent(Intent.ACTION_SENDTO, Uri
                                .parse("mailto:" + addr));
                        intent1.putExtra("subject", "ShowTimes for "
                                + movie.getDisplayTitle() + " at "
                                + theater.getName());
                        intent1.putExtra("body", performance);
                        detailItems.get(position).setIntent(intent1);
                    } else {
                        holder.data.setText("Unknown.");
                    }
                    break;
                case PHONE:
                    holder.data.setText(theater.getPhoneNumber());
                    holder.icon.setImageDrawable(mContext.getResources()
                            .getDrawable(android.R.drawable.sym_action_call));
                    holder.label.setText("Phone");
                    Intent intent2 = new Intent("android.intent.action.DIAL",
                            Uri.parse("tel:" + theater.getPhoneNumber()));
                    detailItems.get(position).setIntent(intent2);
                    break;
                case ADDRESS:
                    String address = theater.getAddress() + ", "
                            + theater.getLocation().getCity();
                    holder.data.setText(address);
                    holder.icon.setImageDrawable(mContext.getResources()
                            .getDrawable(R.drawable.sym_action_map));
                    holder.label.setText("Address");
                    Intent intent3 = new Intent("android.intent.action.VIEW",
                            Uri.parse("geo:0,0?q=" + address));
                    detailItems.get(position).setIntent(intent3);
            }
            return convertView;
        }

        public int getCount() {
            return detailItems.size();
        }

        private class TheaterDetailsViewHolder {
            TextView label;
            ImageView icon;
            TextView data;
        }

        public long getEntryId(final int position) {
            return position;
        }

        public Object getItem(final int position) {
            return ShowtimesActivity.this.theaters.get(position);
        }

        @Override
        public long getItemId(int position) {
            // TODO Auto-generated method stub
            return position;
        }

        public void refresh() {
            notifyDataSetChanged();
        }
    }
    private class TheaterDetailItem {
        TheaterDetailItemType type;
        Intent intent;

        public Intent getIntent() {
            return intent;
        }

        public void setIntent(Intent intent) {
            this.intent = intent;
        }

        public TheaterDetailItemType getType() {
            return type;
        }

        public void setType(TheaterDetailItemType type) {
            this.type = type;
        }
    }
}
