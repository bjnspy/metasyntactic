package org.metasyntactic.activities;

import static org.metasyntactic.utilities.StringUtilities.isNullOrEmpty;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.metasyntactic.NowPlayingApplication;
import org.metasyntactic.RefreshableContext;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.utilities.LogUtilities;
import org.metasyntactic.utilities.MovieViewUtilities;
import org.metasyntactic.utilities.StringUtilities;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.DatePicker;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.CompoundButton.OnCheckedChangeListener;

/**
 * @author mjoshi@google.com (Megha Joshi)
 */
public class SettingsActivity extends AbstractNowPlayingListActivity implements RefreshableContext {
  private List<SettingsItem> detailItems;
  private SettingsAdapter settingsAdapter;
  private boolean isFirst;

  private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
      refresh();
    }
  };
  private final BroadcastReceiver updateLocationStartReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
      setTitle(R.string.finding_location);
      setProgressBarIndeterminateVisibility(true);
    }
  };
  private final BroadcastReceiver updateLocationStopReceiver = new BroadcastReceiver() {
    @Override public void onReceive(final Context context, final Intent intent) {
      setProgressBarIndeterminateVisibility(false);
      setTitle(NowPlayingApplication.getNameAndVersion(getResources()));
    }
  };

  @Override protected void onResumeAfterServiceConnected() {
  }

  @Override protected void onCreateAfterServiceConnected() {
    getUserLocation();
    populateSettingsItems();
    settingsAdapter = new SettingsAdapter();
    setListAdapter(settingsAdapter);
  }

  @Override
  public void onCreate(final Bundle bundle) {
    LogUtilities.i(getClass().getSimpleName(), "onCreate");
    super.onCreate(bundle);

    if (getIntent().getStringExtra("from_menu") == null) {
      isFirst = true;
    }

    requestWindowFeature(Window.FEATURE_INDETERMINATE_PROGRESS);
    setContentView(R.layout.settings);
    final View next = findViewById(R.id.next);
    next.setOnClickListener(new OnClickListener() {
      public void onClick(final View arg0) {
        final String searchLocation = service.getUserAddress();
        if (StringUtilities.isNullOrEmpty(searchLocation)) {
          Toast.makeText(SettingsActivity.this, getResources().getString(R.string.please_enter_your_location), Toast.LENGTH_LONG).show();
        } else {
          final Intent intent = new Intent();
          intent.setClass(SettingsActivity.this, NowPlayingActivity.class);
          startActivity(intent);
        }
      }
    });
    setTitle(NowPlayingApplication.getNameAndVersion(getResources()));
  }

  @Override
  protected void onResume() {
    LogUtilities.i(getClass().getSimpleName(), "onResume");
    super.onResume();

    if (!isFirst && getIntent().getStringExtra("from_menu") == null) {
      finish();
    }
    isFirst = false;

    registerReceiver(broadcastReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_CHANGED_INTENT));
    registerReceiver(updateLocationStartReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_UPDATING_LOCATION_START));
    registerReceiver(updateLocationStopReceiver, new IntentFilter(NowPlayingApplication.NOW_PLAYING_UPDATING_LOCATION_STOP));
  }

  @Override
  protected void onPause() {
    LogUtilities.i(getClass().getSimpleName(), "onPause");
    unregisterReceiver(broadcastReceiver);
    unregisterReceiver(updateLocationStopReceiver);
    unregisterReceiver(updateLocationStartReceiver);
    super.onPause();
  }

  private void getUserLocation() {
    final String userLocation = service.getUserAddress();
    if (!StringUtilities.isNullOrEmpty(userLocation)) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, NowPlayingActivity.class);
      startActivity(localIntent);
    }
  }

  @Override
  protected void onDestroy() {
    LogUtilities.i(getClass().getSimpleName(), "onDestroy");
    super.onDestroy();
  }

  @Override
  public Map<String,Object> onRetainNonConfigurationInstance() {
    LogUtilities.i(getClass().getSimpleName(), "onRetainNonConfigurationInstance");
    return super.onRetainNonConfigurationInstance();
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
      dialog = new NowPlayingPreferenceDialog(this).setKey(detailItems.get(1).getKey()).setTextView(textEntryView).setPositiveButton(R.string.ok)
      .setNegativeButton(android.R.string.cancel);
      dialog.setTitle(detailItems.get(1).getLabel());
      break;
    case 2:
      // The order in which the methods on the NowPlayingPreferenceDialog object
      // are called
      // should not be changed.
      final String[] distanceValues = getResources().getStringArray(R.array.entries_search_distance_preference);
      dialog = new NowPlayingPreferenceDialog(this).setKey(detailItems.get(2).getKey()).setItems(distanceValues);
      dialog.setTitle(detailItems.get(2).getLabel());
      break;
    case 4:
      // The order in which the methods on the NowPlayingPreferenceDialog object
      // are called
      // should not be changed.
      dialog = new NowPlayingPreferenceDialog(this).setKey(detailItems.get(4).getKey()).setEntries(R.array.entries_reviews_provider_preference)
      .setPositiveButton(android.R.string.ok).setNegativeButton(android.R.string.cancel);
      dialog.setTitle(detailItems.get(4).getLabel());
      break;
    case 0:
      // The order in which the methods on the NowPlayingPreferenceDialog object
      // are called
      // should not be changed.
      dialog = new NowPlayingPreferenceDialog(this).setKey(detailItems.get(0).getKey()).setEntries(R.array.entries_auto_update_preference)
      .setPositiveButton(android.R.string.ok).setNegativeButton(android.R.string.cancel);
      dialog.setTitle(detailItems.get(0).getLabel());
    }
    return dialog;
  }

  @Override
  protected void onPrepareDialog(final int id, final Dialog dialog) {
    super.onPrepareDialog(id, dialog);
    switch (id) {
    case 1:
      final LayoutInflater factory = LayoutInflater.from(this);
      final View textEntryView = factory.inflate(R.layout.alert_dialog_text_entry, null);
      // The order in which the methods on the NowPlayingPreferenceDialog object
      // are called
      // should not be changed.
      ((NowPlayingPreferenceDialog)dialog).setTextView(textEntryView);
      break;
    case 2:
      // The order in which the methods on the NowPlayingPreferenceDialog object
      // are called
      // should not be changed.
      final String[] distanceValues = getResources().getStringArray(R.array.entries_search_distance_preference);
      ((NowPlayingPreferenceDialog)dialog).setItems(distanceValues);
      break;
    case 4:
      // The order in which the methods on the NowPlayingPreferenceDialog object
      // are called
      // should not be changed.
      ((NowPlayingPreferenceDialog)dialog).setEntries(R.array.entries_reviews_provider_preference);
      break;
    case 0:
      // The order in which the methods on the NowPlayingPreferenceDialog object
      // are called
      // should not be changed.
      ((NowPlayingPreferenceDialog)dialog).setEntries(R.array.entries_auto_update_preference);
    }
  }

  @Override
  protected void onListItemClick(final ListView listView, final View v, final int position, final long id) {
    if (position == 3) {
      final DatePickerDialog.OnDateSetListener dateSetListener = new DatePickerDialog.OnDateSetListener() {
        public void onDateSet(final DatePicker view, final int year, final int monthOfYear, final int dayOfMonth) {
          final Calendar cal1 = Calendar.getInstance();
          cal1.set(year, monthOfYear, dayOfMonth);
          service.setSearchDate(cal1.getTime());
          refresh();
        }
      };
      final Date searchDate = service.getSearchDate();
      final Calendar cal = Calendar.getInstance();
      cal.setTime(searchDate);
      new DatePickerDialog(this, dateSetListener, cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH)).show();
    } else {
      showDialog(position);
    }
    super.onListItemClick(listView, v, position, id);
  }

  private void populateSettingsItems() {
    detailItems = new ArrayList<SettingsItem>();
    final Resources res = getResources();
    // auto update location - 0
    SettingsItem settings = new SettingsItem();
    settings.setLabel(res.getString(R.string.autoupdate_location));
    final boolean isAutoUpdate = service.isAutoUpdateEnabled();
    if (isAutoUpdate) {
      settings.setData(res.getString(R.string.on));
    } else {
      settings.setData(res.getString(R.string.off));
    }
    settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.AUTO_UPDATE_LOCATION);
    detailItems.add(settings);
    // location - 1
    settings = new SettingsItem();
    settings.setLabel(res.getString(R.string.location));
    final String location = service.getUserAddress();
    if (isNullOrEmpty(location)) {
      settings.setData(res.getString(R.string.tap_here_to_enter_your_search_location));
    } else {
      settings.setData(location);
    }
    settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.LOCATION);
    detailItems.add(settings);
    // search distance - 2
    settings = new SettingsItem();
    settings.setLabel(res.getString(R.string.search_distance));
    final int distance = service.getSearchDistance();

    // units is available.
    settings.setData(distance + " " + res.getString(R.string.miles));
    settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.SEARCH_DISTANCE);
    detailItems.add(settings);
    // search date - 3
    settings = new SettingsItem();
    settings.setLabel(res.getString(R.string.search_date));
    settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.SEARCH_DATE);
    final Date d1 = service.getSearchDate();
    final DateFormat df = DateFormat.getDateInstance(DateFormat.LONG);
    if (d1 != null) {
      settings.setData(df.format(d1));
    }
    detailItems.add(settings);
    // reviews provider - 4
    settings = new SettingsItem();
    settings.setLabel(res.getString(R.string.reviews));
    final ScoreType type = service.getScoreType();
    if (type != null) {
      settings.setData(type.toString());
      if (type == ScoreType.RottenTomatoes) {
        settings.setData2(res.getString(R.string.rotten_tomatoes_text));
      }
    }
    settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.REVIEWS_PROVIDER);
    detailItems.add(settings);
  }

  private class SettingsAdapter extends BaseAdapter {
    private final LayoutInflater inflater;

    private SettingsAdapter() {
      // Cache the LayoutInflate to avoid asking for a new one each time.
      inflater = LayoutInflater.from(SettingsActivity.this);
    }

    public View getView(final int position, View convertView, final ViewGroup viewGroup) {
      convertView = inflater.inflate(R.layout.settings_item, null);
      final SettingsViewHolder holder = new SettingsViewHolder((TextView)convertView.findViewById(R.id.label),
          (ImageView)convertView.findViewById(R.id.icon), (TextView)convertView.findViewById(R.id.data), (TextView)convertView.findViewById(R.id.data2),
          (CheckBox)convertView.findViewById(R.id.check));
      if (position == 0) {
        holder.check.setVisibility(View.VISIBLE);
        holder.icon.setVisibility(View.GONE);
        holder.check.setChecked(service.isAutoUpdateEnabled());
        holder.check.setOnCheckedChangeListener(new OnCheckedChangeListener() {
          public void onCheckedChanged(final CompoundButton arg0, final boolean checked) {
            service.setAutoUpdateEnabled(checked);
            refresh();
          }
        });
      }
      final SettingsItem settingsItem = detailItems.get(position);
      holder.data.setText(settingsItem.getData());
      holder.data2.setText(settingsItem.getData2());
      holder.label.setText(settingsItem.getLabel());
      return convertView;
    }

    public int getCount() {
      return detailItems.size();
    }

    private class SettingsViewHolder {
      private final TextView label;
      private final TextView data;
      private final TextView data2;
      private final CheckBox check;
      private final ImageView icon;

      private SettingsViewHolder(final TextView label, final ImageView icon, final TextView data, final TextView data2, final CheckBox check) {
        this.label = label;
        this.data = data;
        this.check = check;
        this.icon = icon;
        this.data2 = data2;
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

  private static class SettingsItem {
    private String label;
    private String data;
    private String data2;
    private NowPlayingPreferenceDialog.PreferenceKeys key;

    public NowPlayingPreferenceDialog.PreferenceKeys getKey() {
      return key;
    }

    public void setKey(final NowPlayingPreferenceDialog.PreferenceKeys key) {
      this.key = key;
    }

    public String getLabel() {
      return label;
    }

    public void setLabel(final String label) {
      this.label = label;
    }

    public String getData() {
      return data;
    }

    public void setData(final String data) {
      this.data = data;
    }

    public String getData2() {
      return data2;
    }

    public void setData2(final String data) {
      data2 = data;
    }
  }

  public void refresh() {
    populateSettingsItems();
    settingsAdapter.refresh();
  }

  @Override public Context getContext() {
    return this;
  }

  @Override
  public boolean onCreateOptionsMenu(final Menu menu) {
    menu.add(0, MovieViewUtilities.MENU_LICENSE, 0, R.string.license).setIcon(android.R.drawable.ic_menu_info_details);
    menu.add(0, MovieViewUtilities.MENU_CREDITS, 0, R.string.credits).setIcon(R.drawable.ic_menu_star);
    return super.onCreateOptionsMenu(menu);
  }

  @Override
  public boolean onOptionsItemSelected(final MenuItem item) {
    if (item.getItemId() == MovieViewUtilities.MENU_LICENSE) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, WebViewActivity.class);
      localIntent.putExtra("type","license");
      startActivity(localIntent);
      return true;
    }
    if (item.getItemId() == MovieViewUtilities.MENU_CREDITS) {
      final Intent localIntent = new Intent();
      localIntent.setClass(this, WebViewActivity.class);
      localIntent.putExtra("type","credits");
      startActivity(localIntent);
      return true;
    }
    return false;
  }
}