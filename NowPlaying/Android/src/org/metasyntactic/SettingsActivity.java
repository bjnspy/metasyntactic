package org.metasyntactic;

import android.app.DatePickerDialog;
import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.*;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Theater;
import org.metasyntactic.views.NowPlayingPreferenceDialog;

import java.text.DateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

public class SettingsActivity extends ListActivity implements INowPlaying {
  private List<Theater> theaters;
  private List<SettingsItem> detailItems;
  private SettingsAdapter settingsAdapter;
  private int mYear;
  private int mMonth;
  private int mDay;

  @Override
  public void onCreate(final Bundle savedInstanceState) {
	super.onCreate(savedInstanceState);
	NowPlayingControllerWrapper.addActivity(this);
	setContentView(R.layout.settings);
	final Button next = (Button)findViewById(R.id.next);
	next.setOnClickListener(new OnClickListener(){
	  public void onClick(final View arg0) {
		final String searchLocation = NowPlayingControllerWrapper.getUserLocation();
		if (searchLocation!=null && searchLocation!=""){
		  final Intent intent = new Intent();
		  intent.setClass(SettingsActivity.this,NowPlayingActivity.class);
		  startActivity(intent);
		} else{
		  Toast.makeText(SettingsActivity.this,"Location is required", Toast.LENGTH_LONG).show();
		}

	  }

	});
  }

  @Override
  protected void onListItemClick(final ListView l, final View v,
	  final int position, final long id) {
	NowPlayingPreferenceDialog dialog = null;
	switch (this.detailItems.get(position).getKey()) {

	case LOCATION:
	  final LayoutInflater factory = LayoutInflater.from(this);
	  final View textEntryView = factory.inflate(
		  R.layout.alert_dialog_text_entry, null);
	  // The order in which the methods on the NowPlayingPreferenceDialog object are called
	  // should not be changed.
	  dialog = new NowPlayingPreferenceDialog(SettingsActivity.this).setTitle(
		  this.detailItems.get(position).getLabel()).setKey(
		  this.detailItems.get(position).getKey()).setTextView(textEntryView)
		  .setPositiveButton(R.string.ok).setNegativeButton(
			  android.R.string.cancel);
	  break;

	case SEARCH_DISTANCE:

	  // The order in which the methods on the NowPlayingPreferenceDialog object are called
	  // should not be changed.

	  final String[] distanceValues = SettingsActivity.this.getResources()
		  .getStringArray(R.array.entries_search_distance_preference);
	  dialog = new NowPlayingPreferenceDialog(SettingsActivity.this).setTitle(
		  this.detailItems.get(position).getLabel()).setKey(
		  this.detailItems.get(position).getKey()).setItems(distanceValues);
	  break;

	case REVIEWS_PROVIDER:

	  // The order in which the methods on the NowPlayingPreferenceDialog object are called
	  // should not be changed.
	  dialog = new NowPlayingPreferenceDialog(SettingsActivity.this).setTitle(
		  this.detailItems.get(position).getLabel()).setKey(
		  this.detailItems.get(position).getKey()).setEntries(
		  R.array.entries_reviews_provider_preference).setPositiveButton(
		  android.R.string.ok).setNegativeButton(android.R.string.cancel);

	  break;

	case AUTO_UPDATE_LOCATION:

	  // The order in which the methods on the NowPlayingPreferenceDialog object are called
	  // should not be changed.
	  dialog = new NowPlayingPreferenceDialog(SettingsActivity.this).setTitle(
		  this.detailItems.get(position).getLabel()).setKey(
		  this.detailItems.get(position).getKey()).setEntries(
		  R.array.entries_auto_update_preference).setPositiveButton(
		  android.R.string.ok).setNegativeButton(android.R.string.cancel);

	  break;

	case SEARCH_DATE:

	  final DatePickerDialog.OnDateSetListener mDateSetListener = new DatePickerDialog.OnDateSetListener() {
		public void onDateSet(final DatePicker view, final int year, final int monthOfYear,
			final int dayOfMonth) {
		  SettingsActivity.this.mYear = year;
		  SettingsActivity.this.mMonth = monthOfYear;
		  SettingsActivity.this.mDay = dayOfMonth;
		  final Calendar cal1 = Calendar.getInstance();
		  cal1.set(SettingsActivity.this.mYear, SettingsActivity.this.mMonth, SettingsActivity.this.mDay);
		  NowPlayingControllerWrapper.setSearchDate(cal1.getTime());
		  refresh();
		}
	  };
	  final Date searchDate = NowPlayingControllerWrapper.getSearchDate();
	  final Calendar cal = Calendar.getInstance();
	  cal.setTime(searchDate);

	  this.mYear = cal.get(Calendar.YEAR);
	  this.mMonth = cal.get(Calendar.MONTH);
	  this.mDay = cal.get(Calendar.DAY_OF_MONTH);
	  new DatePickerDialog(SettingsActivity.this,
		  mDateSetListener, this.mYear, this.mMonth, this.mDay).show();
	  super.onListItemClick(l, v, position, id);
	  return;
	}

	if (dialog != null) {
	  dialog.show();
	}
	super.onListItemClick(l, v, position, id);
  }



  @Override
  protected void onDestroy() {
	NowPlayingControllerWrapper.removeActivity(this);
	super.onDestroy();
  }

  private void populateSettingsItems() {
	// location
	this.detailItems = new ArrayList<SettingsItem>();
	SettingsItem settings = new SettingsItem();
	settings.setLabel("Set Location");
	final String location = NowPlayingControllerWrapper.getUserLocation();
	if (location != null && location != "") {
	  settings.setData(location);
	} else {
	  settings.setData("Click here and enter location to search for movies.");
	}
	settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.LOCATION);
	this.detailItems.add(settings);

	// search distance
	settings = new SettingsItem();
	settings.setLabel("Set Search Distance");
	final int distance = NowPlayingControllerWrapper.getSearchDistance();
	//TODO Remove hardcoded values once the controller method for distance units
	// is available.
	settings.setData(String.valueOf(distance) + " miles");
	settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.SEARCH_DISTANCE);
	this.detailItems.add(settings);

	// search date
	settings = new SettingsItem();
	settings.setLabel("Set Search Date");
	settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.SEARCH_DATE);
	  final Date d1 = NowPlayingControllerWrapper.getSearchDate();
      final DateFormat df = DateFormat.getDateInstance(DateFormat.LONG);
      if(d1!=null){
      settings.setData(df.format(d1));
      } else{
    	settings.setData("Unknown");
      }

	this.detailItems.add(settings);

	// reviews provider
	settings = new SettingsItem();
	settings.setLabel("Set Reviews Provider");
	final ScoreType type = NowPlayingControllerWrapper.getScoreType();
	if (type != null) {
	  settings.setData(type.toString());
	} else {
	  settings.setData("Unknown");
	}
	settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.REVIEWS_PROVIDER);
	this.detailItems.add(settings);

	// auto update location
	settings = new SettingsItem();
	settings.setLabel("Auto Update Location");
	final Boolean isAutoUpdate = NowPlayingControllerWrapper.isAutoUpdateEnabled();
	if (isAutoUpdate != null) {
	  if (isAutoUpdate) {
      settings.setData("On");
    } else {
      settings.setData("Off");
    }
	} else {
	  settings.setData("Unknown");
	}
	settings
		.setKey(NowPlayingPreferenceDialog.PreferenceKeys.AUTO_UPDATE_LOCATION);
	this.detailItems.add(settings);
  }

  @Override
  protected void onResume() {
	super.onResume();
	populateSettingsItems();
	this.settingsAdapter = new SettingsAdapter();
	setListAdapter(this.settingsAdapter);
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
	  private final TextView data;

	  private SettingsViewHolder(final TextView label, final ImageView icon, final TextView data) {
		this.label = label;
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

  public Context getContext() {
	// TODO Auto-generated method stub
	return SettingsActivity.this;
  }

  public void refresh() {
	// TODO Auto-generated method stub
	populateSettingsItems();
	this.settingsAdapter.refresh();
  }
}
