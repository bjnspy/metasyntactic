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
import org.metasyntactic.NowPlayingControllerWrapper1;
import org.metasyntactic.R;

public class NowPlayingPreferenceDialog {

  private AlertDialog.Builder builder;

  private Preference_keys preference_key;

  private int preference_value;

  public NowPlayingPreferenceDialog(final INowPlaying nowPlaying) {
    Context context = nowPlaying.getContext();
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

  public NowPlayingPreferenceDialog setIcon(Drawable icon) {    builder.setIcon(icon);
    return this;
  }

  public NowPlayingPreferenceDialog setInverseBackgroundForced(boolean useInverseBackground) {

    builder.setInverseBackgroundForced(useInverseBackground);
    return this;
  }

  public NowPlayingPreferenceDialog setNegativeButton(int textId, OnClickListener listener) {
    builder.setNegativeButton(textId, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setOnItemSelectedListener(OnItemSelectedListener listener) {
    builder.setOnItemSelectedListener(listener);
    return this;
  }

  private NowPlayingPreferenceDialog setPositiveButton(int textId, OnClickListener listener) {
    builder.setPositiveButton(textId, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setEntries(int items) {
    DialogInterface.OnClickListener listener = new DialogInterface.OnClickListener() {
      public void onClick(DialogInterface dialog, int which) {
        preference_value = which;
      }
    };
    preference_value = getPreferenceValue();
    setSingleChoiceItems(items, preference_value, listener);
    return this;
  }

  private NowPlayingPreferenceDialog setSingleChoiceItems(int items, int checkedItem, OnClickListener listener) {
    builder.setSingleChoiceItems(items, checkedItem, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setTitle(int title) {
    builder.setTitle(title);
    return this;
  }

  public NowPlayingPreferenceDialog setKey(Preference_keys key) {
    this.preference_key = key;
    return this;
  }

  public NowPlayingPreferenceDialog show() {
    builder.show();
    return this;
  }

  private int getPreferenceValue() {
    switch (preference_key) {
      case MOVIES_SORT:
        return NowPlayingControllerWrapper1.getAllMoviesSelectedSortIndex();
      case THEATERS_SORT:
        return NowPlayingControllerWrapper1.getAllTheatersSelectedSortIndex();
    }
    return 0;
  }

  private void setPreferenceValue() {
    switch (preference_key) {
      case MOVIES_SORT:
        NowPlayingControllerWrapper1.setAllMoviesSelectedSortIndex(preference_value);
        break;
      case THEATERS_SORT:
    	NowPlayingControllerWrapper1.setAllTheatersSelectedSortIndex(preference_value);
    	break;
    }
  }

  public enum Preference_keys {
    MOVIES_SORT, THEATERS_SORT
  }
}
