package org.metasyntactic.activities;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.app.ListActivity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.*;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.util.Log;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Theater;
import org.metasyntactic.utilities.StringUtilities;
import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;
import org.metasyntactic.views.NowPlayingPreferenceDialog;
import org.metasyntactic.INowPlaying;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.activities.R;
import org.metasyntactic.Application;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class SettingsActivity extends ListActivity implements INowPlaying {
  private List<Theater> theaters;
  private List<SettingsItem> detailItems;
  private SettingsAdapter settingsAdapter;
  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override
    public void onReceive(final Context context, final Intent intent) {
      refresh();
    }
  };

  @Override
  public void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Log.i(getClass().getSimpleName(), "onCreate");
    NowPlayingControllerWrapper.addActivity(this);

    setContentView(R.layout.settings);
    final Button next = (Button) findViewById(R.id.next);
    next.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        final String searchLocation = NowPlayingControllerWrapper.getUserLocation();
        if (StringUtilities.isNullOrEmpty(searchLocation)) {
          Toast.makeText(SettingsActivity.this,
                         SettingsActivity.this.getResources().getString(R.string.please_enter_your_location),
                         Toast.LENGTH_LONG).show();
        } else {
          final Intent intent = new Intent();
          intent.setClass(SettingsActivity.this, NowPlayingActivity.class);
          startActivity(intent);
        }
      }
    });
    populateSettingsItems();
  }

  @Override
  protected Dialog onCreateDialog(final int id) {
    Dialog dialog = null;
    switch (id) {
      case 1:
        final LayoutInflater factory = LayoutInflater.from(this);
        final View textEntryView = factory.inflate(R.layout.alert_dialog_text_entry, null);
        // The order in which the methods on the NowPlayingPreferenceDialog object
        // are called
        // should not be changed.
        dialog = new NowPlayingPreferenceDialog(this).setTitle(this.detailItems.get(1).getLabel()).setKey(
            this.detailItems.get(1).getKey()).setTextView(textEntryView).setPositiveButton(
            R.string.ok).setNegativeButton(android.R.string.cancel).create();
        break;
      case 2:
        // The order in which the methods on the NowPlayingPreferenceDialog object
        // are called
        // should not be changed.
        final String[] distanceValues = getResources().getStringArray(R.array.entries_search_distance_preference);
        dialog = new NowPlayingPreferenceDialog(this).setTitle(this.detailItems.get(2).getLabel()).setKey(
            this.detailItems.get(2).getKey()).setItems(distanceValues).create();
        break;
      case 4:
        // The order in which the methods on the NowPlayingPreferenceDialog object
        // are called
        // should not be changed.
        dialog = new NowPlayingPreferenceDialog(this).setTitle(this.detailItems.get(4).getLabel()).setKey(
            this.detailItems.get(4).getKey()).setEntries(R.array.entries_reviews_provider_preference).setPositiveButton(
            android.R.string.ok).setNegativeButton(android.R.string.cancel).create();
        break;
      case 0:
        // The order in which the methods on the NowPlayingPreferenceDialog object
        // are called
        // should not be changed.
        dialog = new NowPlayingPreferenceDialog(this).setTitle(this.detailItems.get(0).getLabel()).setKey(
            this.detailItems.get(0).getKey()).setEntries(R.array.entries_auto_update_preference).setPositiveButton(
            android.R.string.ok).setNegativeButton(android.R.string.cancel).create();
    }
    return dialog;
  }

  @Override
  protected void onListItemClick(final ListView listView, final View v, final int position, final long id) {
    if (position == 3) {
      final DatePickerDialog.OnDateSetListener dateSetListener = new DatePickerDialog.OnDateSetListener() {
        public void onDateSet(final DatePicker view, final int year, final int monthOfYear, final int dayOfMonth) {
          final Calendar cal1 = Calendar.getInstance();
          cal1.set(year, monthOfYear, dayOfMonth);
          NowPlayingControllerWrapper.setSearchDate(cal1.getTime());
          SettingsActivity.this.refresh();
        }
      };
      final Date searchDate = NowPlayingControllerWrapper.getSearchDate();
      final Calendar cal = Calendar.getInstance();
      cal.setTime(searchDate);
      new DatePickerDialog(this, dateSetListener, cal.get(Calendar.YEAR), cal.get(Calendar.MONTH),
                           cal.get(Calendar.DAY_OF_MONTH)).show();
    } else {
      showDialog(position);
    }
    super.onListItemClick(listView, v, position, id);
  }

  @Override
  protected void onDestroy() {
    Log.i(getClass().getSimpleName(), "onDestroy");

    NowPlayingControllerWrapper.removeActivity(this);
    super.onDestroy();
  }

  private void populateSettingsItems() {
    this.detailItems = new ArrayList<SettingsItem>();
    final Resources res = getResources();
    // auto update location - 0
    SettingsItem settings = new SettingsItem();
    settings.setLabel(res.getString(R.string.autoupdate_location));
    final boolean isAutoUpdate = NowPlayingControllerWrapper.isAutoUpdateEnabled();
    if (isAutoUpdate) {
      settings.setData(res.getString(R.string.on));
    } else {
      settings.setData(res.getString(R.string.off));
    }
    settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.AUTO_UPDATE_LOCATION);
    this.detailItems.add(settings);
    // location - 1
    settings = new SettingsItem();
    settings.setLabel(res.getString(R.string.location));
    final String location = NowPlayingControllerWrapper.getUserLocation();
    if (isNullOrEmpty(location)) {
      settings.setData(res.getString(R.string.tap_here_to_enter_your_search_location));
    } else {
      settings.setData(location);
    }
    settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.LOCATION);
    this.detailItems.add(settings);
    // search distance - 2
    settings = new SettingsItem();
    settings.setLabel(res.getString(R.string.search_distance));
    final int distance = NowPlayingControllerWrapper.getSearchDistance();
    // TODO Remove hardcoded values once the controller method for distance
    // units is available.
    settings.setData(distance + " " + res.getString(R.string.miles));
    settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.SEARCH_DISTANCE);
    this.detailItems.add(settings);
    // search date - 3
    settings = new SettingsItem();
    settings.setLabel(res.getString(R.string.search_date));
    settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.SEARCH_DATE);
    final Date d1 = NowPlayingControllerWrapper.getSearchDate();
    final DateFormat df = DateFormat.getDateInstance(DateFormat.LONG);
    if (d1 != null) {
      settings.setData(df.format(d1));
    }
    this.detailItems.add(settings);
    // reviews provider - 4
    settings = new SettingsItem();
    settings.setLabel(res.getString(R.string.reviews));
    final ScoreType type = NowPlayingControllerWrapper.getScoreType();
    if (type != null) {
      settings.setData(type.toString());
    }
    settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.REVIEWS_PROVIDER);
    this.detailItems.add(settings);
  }

  @Override
  protected void onResume() {
    super.onResume();
    Log.i(getClass().getSimpleName(), "onResume");

    registerReceiver(this.broadcastReceiver, new IntentFilter(Application.NOW_PLAYING_CHANGED_INTENT));
    this.settingsAdapter = new SettingsAdapter();
    setListAdapter(this.settingsAdapter);
  }

  private class SettingsAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    private SettingsAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      this.inflater = LayoutInflater.from(SettingsActivity.this);
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = this.inflater.inflate(R.layout.settings_item, null);
      final SettingsViewHolder holder = new SettingsViewHolder((TextView) convertView.findViewById(R.id.label),
                                                               (ImageView) convertView.findViewById(R.id.icon),
                                                               (TextView) convertView.findViewById(R.id.data),
                                                               (CheckBox) convertView.findViewById(R.id.check));
      if (position == 0) {
        holder.check.setVisibility(View.VISIBLE);
        holder.icon.setVisibility(View.GONE);
        holder.check.setChecked(NowPlayingControllerWrapper.isAutoUpdateEnabled());
        holder.check.setOnCheckedChangeListener(new OnCheckedChangeListener() {
          public void onCheckedChanged(final CompoundButton arg0, final boolean checked) {
            NowPlayingControllerWrapper.setAutoUpdateEnabled(checked);
            SettingsActivity.this.refresh();
          }
        });
      }
      final SettingsItem settingsItem = SettingsActivity.this.detailItems.get(position);
      holder.data.setText(settingsItem.getData());
      holder.label.setText(settingsItem.getLabel());
      return convertView;
    }

    public int getCount() {
      return SettingsActivity.this.detailItems.size();
    }

    private class SettingsViewHolder {
      private final TextView label;
      private final TextView data;
      private final CheckBox check;
      private final ImageView icon;

      private SettingsViewHolder(final TextView label, final ImageView icon, final TextView data,
                                 final CheckBox check) {
        this.label = label;
        this.data = data;
        this.check = check;
        this.icon = icon;
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

  private static class SettingsItem {
    private String label;
    private String data;
    private NowPlayingPreferenceDialog.PreferenceKeys key;

    public NowPlayingPreferenceDialog.PreferenceKeys getKey() {
      return this.key;
    }

    public void setKey(final NowPlayingPreferenceDialog.PreferenceKeys key) {
      this.key = key;
    }

    public String getLabel() {
      return this.label;
    }

    public void setLabel(final String label) {
      this.label = label;
    }

    public String getData() {
      return this.data;
    }

    public void setData(final String data) {
      this.data = data;
    }
  }

  public void refresh() {
    populateSettingsItems();
    this.settingsAdapter.refresh();
  }

  public Context getContext() {
    return this;
  }

  @Override
  protected void onPause() {
    Log.i(getClass().getSimpleName(), "onPause");
    unregisterReceiver(this.broadcastReceiver);
    super.onPause();
  }
}