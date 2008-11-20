package org.metasyntactic;

import android.app.ListActivity;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Performance;
import org.metasyntactic.data.Theater;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class SettingsActivity extends ListActivity {
    private List<Theater> theaters;
    private Movie movie;
    private final List<SettingsItem> detailItems = new ArrayList<SettingsItem>();

    @Override
    protected void onListItemClick(final ListView l, final View v,
            final int position, final long id) {
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
        setContentView(R.layout.settings);
    }

    @Override
    protected void onDestroy() {
        NowPlayingControllerWrapper.removeActivity(this);
        super.onDestroy();
    }

    private void populateSettingsItems() {
        // location
        SettingsItem settings = new SettingsItem();
        settings.setLabel("Location");
        String location = NowPlayingControllerWrapper.getUserLocation();
        if (location != null)
            settings.setData(location);
        else
            settings.setData("Unknown");
        detailItems.add(settings);
        // search distance
        settings = new SettingsItem();
        settings.setLabel("Search Distance");
        int distance = NowPlayingControllerWrapper.getSearchDistance();
        settings.setData(String.valueOf(distance));
        detailItems.add(settings);
        // search date
        settings = new SettingsItem();
        settings.setLabel("Search Date");
        Date date = new Date();
        settings.setData(date.toLocaleString());
        detailItems.add(settings);
        // reviews provider
        settings = new SettingsItem();
        settings.setLabel("Reviews");
        ScoreType type = NowPlayingControllerWrapper.getScoreType();
        if (type != null) {
            settings.setData(type.toString());
        }else
            settings.setData("Unknown");
        detailItems.add(settings);
        // auto update location
        settings = new SettingsItem();
        settings.setLabel("Auto Update Location");
        settings.setData("Off");
        detailItems.add(settings);
    }

    @Override
    protected void onResume() {
        super.onResume();
        populateSettingsItems();
        SettingsAdapter settingsAdapter = new SettingsAdapter();
        setListAdapter(settingsAdapter);
    }

    private class SettingsAdapter extends BaseAdapter {
        private final LayoutInflater inflater;

        public SettingsAdapter() {
            // Cache the LayoutInflate to avoid asking for a new one each time.
            this.inflater = LayoutInflater.from(SettingsActivity.this);
        }

        public View getView(final int position, View convertView,
                final ViewGroup viewGroup) {
            convertView = this.inflater.inflate(R.layout.settings_item, null);
            final SettingsViewHolder holder = new SettingsViewHolder(
                    (TextView) convertView.findViewById(R.id.label),
                    (ImageView) convertView.findViewById(R.id.icon),
                    (TextView) convertView.findViewById(R.id.data));
            final SettingsItem settingsItem = SettingsActivity.this.detailItems
                    .get(position);
            holder.data.setText(settingsItem.getData());
            holder.label.setText(settingsItem.getLabel());
            return convertView;
        }

        public int getCount() {
            return SettingsActivity.this.detailItems.size();
        }

        private class SettingsViewHolder {
            private final TextView label;
            private final ImageView icon;
            private final TextView data;

            private SettingsViewHolder(TextView label, ImageView icon,
                    TextView data) {
                this.label = label;
                this.icon = icon;
                this.data = data;
            }
        }

        public long getEntryId(final int position) {
            return position;
        }

        public Object getItem(final int position) {
            return SettingsActivity.this.theaters.get(position);
        }

        public long getItemId(final int position) {
            return position;
        }

        public void refresh() {
            notifyDataSetChanged();
        }
    }
    private class SettingsItem {
        private Intent intent;
        private String label;
        private String data;

        public Intent getIntent() {
            return this.intent;
        }

        public void setIntent(final Intent intent) {
            this.intent = intent;
        }

        public String getLabel() {
            return label;
        }

        public void setLabel(String label) {
            this.label = label;
        }

        public String getData() {
            return data;
        }

        public void setData(String data) {
            this.data = data;
        }
    }
}
