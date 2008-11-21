package org.metasyntactic;

import android.app.DatePickerDialog;
import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

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
  private Movie movie;
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
	Button next = (Button)findViewById(R.id.next);
	next.setOnClickListener(new OnClickListener(){

	  @Override
	  public void onClick(View arg0) {
		String searchLocation = NowPlayingControllerWrapper.getUserLocation();
		if (searchLocation!=null && searchLocation!=""){
		  Intent intent = new Intent();
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
	switch (detailItems.get(position).getKey()) {

	case LOCATION:
	  LayoutInflater factory = LayoutInflater.from(this);
	  final View textEntryView = factory.inflate(
		  R.layout.alert_dialog_text_entry, null);
	  // The order in which the methods on the NowPlayingPreferenceDialog object are called
	  // should not be changed.
	  dialog = new NowPlayingPreferenceDialog(SettingsActivity.this).setTitle(
		  detailItems.get(position).getLabel()).setKey(
		  detailItems.get(position).getKey()).setTextView(textEntryView)
		  .setPositiveButton(R.string.ok).setNegativeButton(
			  android.R.string.cancel);
	  break;

	case SEARCH_DISTANCE:

	  // The order in which the methods on the NowPlayingPreferenceDialog object are called
	  // should not be changed.

	  String[] distanceValues = SettingsActivity.this.getResources()
		  .getStringArray(R.array.entries_search_distance_preference);
	  dialog = new NowPlayingPreferenceDialog(SettingsActivity.this).setTitle(
		  detailItems.get(position).getLabel()).setKey(
		  detailItems.get(position).getKey()).setItems(distanceValues);
	  break;

	case REVIEWS_PROVIDER:

	  // The order in which the methods on the NowPlayingPreferenceDialog object are called
	  // should not be changed.
	  dialog = new NowPlayingPreferenceDialog(SettingsActivity.this).setTitle(
		  detailItems.get(position).getLabel()).setKey(
		  detailItems.get(position).getKey()).setEntries(
		  R.array.entries_reviews_provider_preference).setPositiveButton(
		  android.R.string.ok).setNegativeButton(android.R.string.cancel);

	  break;

	case AUTO_UPDATE_LOCATION:

	  // The order in which the methods on the NowPlayingPreferenceDialog object are called
	  // should not be changed.
	  dialog = new NowPlayingPreferenceDialog(SettingsActivity.this).setTitle(
		  detailItems.get(position).getLabel()).setKey(
		  detailItems.get(position).getKey()).setEntries(
		  R.array.entries_auto_update_preference).setPositiveButton(
		  android.R.string.ok).setNegativeButton(android.R.string.cancel);

	  break;

	case SEARCH_DATE:

	  DatePickerDialog.OnDateSetListener mDateSetListener = new DatePickerDialog.OnDateSetListener() {
		public void onDateSet(DatePicker view, int year, int monthOfYear,
			int dayOfMonth) {
		  mYear = year;
		  mMonth = monthOfYear;
		  mDay = dayOfMonth;
		  Calendar cal1 = Calendar.getInstance();
		  cal1.set(mYear, mMonth, mDay);
		  NowPlayingControllerWrapper.setSearchDate(cal1.getTime());
		  refresh();
		}
	  };
	  Date searchDate = NowPlayingControllerWrapper.getSearchDate();
	  final Calendar cal = Calendar.getInstance();
	  cal.setTime(searchDate);
	  
	  mYear = cal.get(Calendar.YEAR);
	  mMonth = cal.get(Calendar.MONTH);
	  mDay = cal.get(Calendar.DAY_OF_MONTH);
	  new DatePickerDialog(SettingsActivity.this,
		  mDateSetListener, mYear, mMonth, mDay).show();
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
	detailItems = new ArrayList<SettingsItem>();
	SettingsItem settings = new SettingsItem();
	settings.setLabel("Set Location");
	String location = NowPlayingControllerWrapper.getUserLocation();
	if (location != null && location != "") {
	  settings.setData(location);
	} else {
	  settings.setData("Click here and enter location to search for movies.");
	}
	settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.LOCATION);
	detailItems.add(settings);

	// search distance
	settings = new SettingsItem();
	settings.setLabel("Set Search Distance");
	int distance = NowPlayingControllerWrapper.getSearchDistance();
	settings.setData(String.valueOf(distance));
	settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.SEARCH_DISTANCE);
	detailItems.add(settings);

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
      
	detailItems.add(settings);

	// reviews provider
	settings = new SettingsItem();
	settings.setLabel("Set Reviews Provider");
	ScoreType type = NowPlayingControllerWrapper.getScoreType();
	if (type != null) {
	  settings.setData(type.toString());
	} else {
	  settings.setData("Unknown");
	}
	settings.setKey(NowPlayingPreferenceDialog.PreferenceKeys.REVIEWS_PROVIDER);
	detailItems.add(settings);

	// auto update location
	settings = new SettingsItem();
	settings.setLabel("Auto Update Location");
	Boolean isAutoUpdate = NowPlayingControllerWrapper.isAutoUpdateEnabled();
	if (isAutoUpdate != null) {
	  if (isAutoUpdate)
		settings.setData("On");
	  else
		settings.setData("Off");
	} else {
	  settings.setData("Unknown");
	}
	settings
		.setKey(NowPlayingPreferenceDialog.PreferenceKeys.AUTO_UPDATE_LOCATION);
	detailItems.add(settings);
  }

  @Override
  protected void onResume() {
	super.onResume();
	populateSettingsItems();
	settingsAdapter = new SettingsAdapter();
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

	  private SettingsViewHolder(TextView label, ImageView icon, TextView data) {
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
	private String label;
	private String data;
	private NowPlayingPreferenceDialog.PreferenceKeys key;

	public NowPlayingPreferenceDialog.PreferenceKeys getKey() {
	  return key;
	}

	public void setKey(NowPlayingPreferenceDialog.PreferenceKeys key) {
	  this.key = key;
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

  @Override
  public Context getContext() {
	// TODO Auto-generated method stub
	return SettingsActivity.this;
  }

  @Override
  public void refresh() {
	// TODO Auto-generated method stub
	populateSettingsItems();
	settingsAdapter.refresh();
  }
}
