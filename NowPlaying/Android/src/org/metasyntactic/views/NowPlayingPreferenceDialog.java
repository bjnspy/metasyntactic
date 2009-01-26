package org.metasyntactic.views;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.graphics.drawable.Drawable;
import android.view.View;
import android.widget.TextView;
import android.widget.AdapterView.OnItemSelectedListener;

import org.metasyntactic.Application;
import org.metasyntactic.INowPlaying;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.R;
import org.metasyntactic.caches.scores.ScoreType;

import java.util.Arrays;
import java.util.List;

public class NowPlayingPreferenceDialog {
  private final AlertDialog.Builder builder;
  private PreferenceKeys prefKey;
  private int intValue;
  private TextView textView;
  private final INowPlaying context;
  DialogInterface.OnClickListener positiveButtonListener;

  public NowPlayingPreferenceDialog(final Context context) {
    this.builder = new AlertDialog.Builder(context);
    this.context = (INowPlaying) context;
  }

  public Dialog create() {
    return builder.create();
  }

  public NowPlayingPreferenceDialog setIcon(final Drawable icon) {
    this.builder.setIcon(icon);
    return this;
  }

  public NowPlayingPreferenceDialog setInverseBackgroundForced(final boolean useInverseBackground) {
    this.builder.setInverseBackgroundForced(useInverseBackground);
    return this;
  }

  public NowPlayingPreferenceDialog setNegativeButton(final int textId,
      final OnClickListener listener) {
    this.builder.setNegativeButton(textId, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setOnItemSelectedListener(final OnItemSelectedListener listener) {
    this.builder.setOnItemSelectedListener(listener);
    return this;
  }

  public NowPlayingPreferenceDialog setEntries(final int items) {
    final DialogInterface.OnClickListener radioButtonListener = new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialog, final int which) {
        NowPlayingPreferenceDialog.this.intValue = which;
      }
    };
    setSingleChoiceItems(items, getIntPreferenceValue(), radioButtonListener);
    this.positiveButtonListener = new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialog, final int which) {
        setIntPreferenceValue(NowPlayingPreferenceDialog.this.intValue);
        context.refresh();
      }
    };
    return this;
  }

  private NowPlayingPreferenceDialog setSingleChoiceItems(final int items, final int checkedItem,
      final OnClickListener listener) {
    this.builder.setSingleChoiceItems(items, checkedItem, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setItems(final String[] distanceValues) {
    final DialogInterface.OnClickListener listItemListener = new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialog, final int which) {
        setIntPreferenceValue(Integer.parseInt(distanceValues[which]));
        context.refresh();
      }
    };
    this.builder.setItems(distanceValues, listItemListener);
    return this;
  }

  public NowPlayingPreferenceDialog setTitle(final int title) {
    this.builder.setTitle(title);
    return this;
  }

  public NowPlayingPreferenceDialog setTitle(final CharSequence title) {
    this.builder.setTitle(title);
    return this;
  }

  public NowPlayingPreferenceDialog setPositiveButton(final int textId) {
    this.builder.setPositiveButton(textId, this.positiveButtonListener);
    return this;
  }

  public NowPlayingPreferenceDialog setNegativeButton(final int textId) {
    this.builder.setNegativeButton(textId, null);
    return this;
  }

  public NowPlayingPreferenceDialog setKey(final PreferenceKeys key) {
    this.prefKey = key;
    return this;
  }

  public void show() {
    this.builder.show();
  }

  private int getIntPreferenceValue() {
    switch (this.prefKey) {
    case MOVIES_SORT:
      return NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex();
    case THEATERS_SORT:
      return NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex();
    case SEARCH_DISTANCE:
      return NowPlayingControllerWrapper.getSearchDistance();
    case REVIEWS_PROVIDER:
      return this.scoreTypes.indexOf(NowPlayingControllerWrapper.getScoreType());
    case AUTO_UPDATE_LOCATION:
      return this.autoUpdate.indexOf(NowPlayingControllerWrapper.isAutoUpdateEnabled());
    }
    return 0;
  }

  private String getStringPreferenceValue() {
    switch (this.prefKey) {
    case LOCATION:
      return NowPlayingControllerWrapper.getUserLocation();
    }
    return null;
  }

  private void setIntPreferenceValue(final int prefValue) {
    switch (this.prefKey) {
    case MOVIES_SORT:
      NowPlayingControllerWrapper.setAllMoviesSelectedSortIndex(prefValue);
      break;
    case THEATERS_SORT:
      NowPlayingControllerWrapper.setAllTheatersSelectedSortIndex(prefValue);
      break;
    case SEARCH_DISTANCE:
      NowPlayingControllerWrapper.setSearchDistance(prefValue);
      break;
    case REVIEWS_PROVIDER:
      NowPlayingControllerWrapper.setScoreType(this.scoreTypes.get(prefValue));
      break;
    case AUTO_UPDATE_LOCATION:
      NowPlayingControllerWrapper.setAutoUpdateEnabled(this.autoUpdate.get(prefValue));
      break;
    }
  }

  private void setStringPreferenceValue(final String prefValue) {
    switch (this.prefKey) {
    case LOCATION:
      NowPlayingControllerWrapper.setUserLocation(prefValue);
      break;
    }
  }

  public enum PreferenceKeys {
    MOVIES_SORT, THEATERS_SORT, LOCATION, SEARCH_DISTANCE, SEARCH_DATE, REVIEWS_PROVIDER, AUTO_UPDATE_LOCATION
  }

  public NowPlayingPreferenceDialog setTextView(final View textEntryView) {
    this.textView = (TextView) textEntryView.findViewById(R.id.dialogEdit);
    this.textView.setText(getStringPreferenceValue());
    this.builder.setView(textEntryView);
    this.positiveButtonListener = new OnClickListener() {
      public void onClick(final DialogInterface dialog, final int which) {
        setStringPreferenceValue(NowPlayingPreferenceDialog.this.textView.getText().toString());
        context.refresh();
      }
    };
    return this;
  }

  // Work around to make handling of scoretype,auto_update same as sort
  // preference, as both are choicetypes.
  private final List<ScoreType> scoreTypes = Arrays.asList(ScoreType.Google, ScoreType.Metacritic,
      ScoreType.RottenTomatoes);
  private final List<Boolean> autoUpdate = Arrays.asList(Boolean.TRUE, Boolean.FALSE);
}
