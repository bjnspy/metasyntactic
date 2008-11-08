// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package org.metasyntactic.views;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.graphics.drawable.Drawable;
import android.widget.AdapterView.OnItemSelectedListener;
import org.metasyntactic.INowPlaying;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.R;

public class NowPlayingPreferenceDialog {

  private AlertDialog.Builder builder;

  private Preference_keys preference_key;

  private int preference_value;

  private INowPlaying nowPlaying;

  private NowPlayingControllerWrapper controller;

  public NowPlayingPreferenceDialog(final INowPlaying nowPlaying) {
    this.nowPlaying = nowPlaying;
    Context context = nowPlaying.getContext();
    controller = nowPlaying.getController();
    builder = new AlertDialog.Builder(context);
    DialogInterface.OnClickListener listener = new DialogInterface.OnClickListener() {
      public void onClick(DialogInterface dialog, int whichButton) {
        setPreferenceValue();
        nowPlaying.refresh();
      }
    };
    builder.setPositiveButton(android.R.string.ok, listener)
        .setNegativeButton(android.R.string.cancel, null)
        .setSingleChoiceItems(R.array.entries_movies_sort_preference, 0, null);
  }

  public NowPlayingPreferenceDialog create() {
    builder.create();
    return this;
  }

  public NowPlayingPreferenceDialog setIcon(Drawable icon) {
    // TODO Auto-generated method stub
    builder.setIcon(icon);
    return this;
  }

  public NowPlayingPreferenceDialog setInverseBackgroundForced(boolean useInverseBackground) {

    builder.setInverseBackgroundForced(useInverseBackground);
    return this;
  }

  public NowPlayingPreferenceDialog setNegativeButton(int textId, OnClickListener listener) {
    // TODO Auto-generated method stub
    builder.setNegativeButton(textId, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setOnItemSelectedListener(OnItemSelectedListener listener) {
    // TODO Auto-generated method stub
    builder.setOnItemSelectedListener(listener);
    return this;
  }

  private NowPlayingPreferenceDialog setPositiveButton(int textId, OnClickListener listener) {
    // TODO Auto-generated method stub


    builder.setPositiveButton(textId, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setEntries(int items) {
    // TODO Auto-generated method stub
    DialogInterface.OnClickListener listener = new DialogInterface.OnClickListener() {
      public void onClick(DialogInterface dialog, int which) {
        // TODO Auto-generated method stub
        preference_value = which;
      }
    };
    preference_value = getPreferenceValue();
    setSingleChoiceItems(items, preference_value, listener);
    return this;
  }

  private NowPlayingPreferenceDialog setSingleChoiceItems(int items, int checkedItem, OnClickListener listener) {
    // TODO Auto-generated method stub
    builder.setSingleChoiceItems(items, checkedItem, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setTitle(int title) {
    // TODO Auto-generated method stub
    builder.setTitle(title);
    return this;
  }

  public NowPlayingPreferenceDialog setKey(Preference_keys key) {
    // TODO Auto-generated method stub
    this.preference_key = key;
    return this;
  }

  public NowPlayingPreferenceDialog show() {
    // TODO Auto-generated method stub
    builder.show();
    return this;
  }

  private int getPreferenceValue() {

    // TODO Auto-generated method stub
    switch (preference_key) {
      case MOVIES_SORT:

        return controller.getAllMoviesSelectedSortIndex();
      case THEATERS_SORT:

        return controller.getAllTheatersSelectedSortIndex();
    }
    return 0;
  }

  private void setPreferenceValue() {

    switch (preference_key) {

      case MOVIES_SORT:
        controller.setAllMoviesSelectedSortIndex(preference_value);
        break;
      case THEATERS_SORT:
        controller.setAllTheatersSelectedSortIndex(preference_value);
    }
  }

  public enum Preference_keys {
    MOVIES_SORT, THEATERS_SORT
  }
}
