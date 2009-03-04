package org.metasyntactic.views;

import java.util.Arrays;
import java.util.List;

import org.metasyntactic.INowPlaying;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.activities.R;
import org.metasyntactic.caches.scores.ScoreType;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.view.View;
import android.widget.TextView;
import android.widget.AdapterView.OnItemSelectedListener;

public class NowPlayingPreferenceDialog extends AlertDialog {
  private final AlertDialog.Builder builder;
  private PreferenceKeys prefKey;
  private int intValue;
  private TextView textView;
  private final INowPlaying context;
  DialogInterface.OnClickListener positiveButtonListener;

  public NowPlayingPreferenceDialog(final Context context) {
    super(context);
    builder = new AlertDialog.Builder(context);
    this.context = (INowPlaying)context;
  }

  public Dialog create() {
    return builder.create();
  }

  public NowPlayingPreferenceDialog setNegativeButton(final int textId, final OnClickListener listener) {
    builder.setNegativeButton(textId, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setOnItemSelectedListener(final OnItemSelectedListener listener) {
    builder.setOnItemSelectedListener(listener);
    return this;
  }

  public NowPlayingPreferenceDialog setEntries(final int items) {
    intValue = getIntPreferenceValue();
    final DialogInterface.OnClickListener radioButtonListener = new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialog, final int which) {
        intValue = which;
      }
    };
    setSingleChoiceItems(items, getIntPreferenceValue(), radioButtonListener);
    positiveButtonListener = new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialog, final int which) {
        setIntPreferenceValue(intValue);
        context.refresh();
      }
    };
    return this;
  }

  private NowPlayingPreferenceDialog setSingleChoiceItems(final int items, final int checkedItem, final OnClickListener listener) {
    builder.setSingleChoiceItems(items, checkedItem, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setItems(final String[] distanceValues) {
    final DialogInterface.OnClickListener listItemListener = new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialog, final int which) {
        setIntPreferenceValue(Integer.parseInt(distanceValues[which]));
        context.refresh();
      }
    };
    builder.setItems(distanceValues, listItemListener);
    return this;
  }

  /*
   * public NowPlayingPreferenceDialog setTitle(final int title) {
   * this.builder.setTitle(title); return this; }
   *
   * public NowPlayingPreferenceDialog setTitle(final CharSequence title) {
   * this.builder.setTitle(title); return this; }
   */

  public NowPlayingPreferenceDialog setPositiveButton(final int textId) {
    builder.setPositiveButton(textId, positiveButtonListener);
    return this;
  }

  public NowPlayingPreferenceDialog setNegativeButton(final int textId) {
    builder.setNegativeButton(textId, null);
    return this;
  }

  public NowPlayingPreferenceDialog setKey(final PreferenceKeys key) {
    prefKey = key;
    return this;
  }

  @Override
  public void show() {
    builder.show();
  }

  private int getIntPreferenceValue() {
    switch (prefKey) {
    case MOVIES_SORT:
      return NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex();
    case UPCOMING_MOVIES_SORT:
      return NowPlayingControllerWrapper.getUpcomingMoviesSelectedSortIndex();
    case THEATERS_SORT:
      return NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex();
    case SEARCH_DISTANCE:
      return NowPlayingControllerWrapper.getSearchDistance();
    case REVIEWS_PROVIDER:
      return scoreTypes.indexOf(NowPlayingControllerWrapper.getScoreType());
    case AUTO_UPDATE_LOCATION:
      return autoUpdate.indexOf(NowPlayingControllerWrapper.isAutoUpdateEnabled());
    }
    return 0;
  }

  private String getStringPreferenceValue() {
    switch (prefKey) {
    case LOCATION:
      return NowPlayingControllerWrapper.getUserLocation();
    }
    return null;
  }

  private void setIntPreferenceValue(final int prefValue) {
    switch (prefKey) {
    case MOVIES_SORT:
      NowPlayingControllerWrapper.setAllMoviesSelectedSortIndex(prefValue);
      break;
    case UPCOMING_MOVIES_SORT:
      NowPlayingControllerWrapper.setUpcomingMoviesSelectedSortIndex(prefValue);
      break;
    case THEATERS_SORT:
      NowPlayingControllerWrapper.setAllTheatersSelectedSortIndex(prefValue);
      break;
    case SEARCH_DISTANCE:
      NowPlayingControllerWrapper.setSearchDistance(prefValue);
      break;
    case REVIEWS_PROVIDER:
      NowPlayingControllerWrapper.setScoreType(scoreTypes.get(prefValue));
      break;
    case AUTO_UPDATE_LOCATION:
      NowPlayingControllerWrapper.setAutoUpdateEnabled(autoUpdate.get(prefValue));
      break;
    }
  }

  private void setStringPreferenceValue(final String prefValue) {
    switch (prefKey) {
    case LOCATION:
      NowPlayingControllerWrapper.setUserLocation(prefValue);
      break;
    }
  }

  public enum PreferenceKeys {
    MOVIES_SORT, UPCOMING_MOVIES_SORT, THEATERS_SORT, LOCATION, SEARCH_DISTANCE, SEARCH_DATE, REVIEWS_PROVIDER, AUTO_UPDATE_LOCATION
  }

  public NowPlayingPreferenceDialog setTextView(final View textEntryView) {
    textView = (TextView)textEntryView.findViewById(R.id.dialogEdit);
    textView.setText(getStringPreferenceValue());
    builder.setView(textEntryView);
    positiveButtonListener = new OnClickListener() {
      public void onClick(final DialogInterface dialog, final int which) {
        setStringPreferenceValue(textView.getText().toString());
        context.refresh();
      }
    };
    return this;
  }

  // Work around to make handling of scoretype,auto_update same as sort
  // preference, as both are choicetypes.
  private final List<ScoreType> scoreTypes = Arrays.asList(ScoreType.Google, ScoreType.Metacritic, ScoreType.RottenTomatoes);
  private final List<Boolean> autoUpdate = Arrays.asList(Boolean.TRUE, Boolean.FALSE);

  @Override
  public void setTitle(final CharSequence title) {
    // TODO Auto-generated method stub
    super.setTitle(title);
    builder.setTitle(title);
  }

  @Override
  public void setTitle(final int titleId) {
    // TODO Auto-generated method stub
    super.setTitle(titleId);
    builder.setTitle(titleId);
  }
}
