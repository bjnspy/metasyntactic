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
  private final AlertDialog.Builder builder;
  private Preference_keys preference_key;
  private int preference_value;

  public NowPlayingPreferenceDialog(final INowPlaying nowPlaying) {
    final Context context = nowPlaying.getContext();
    this.builder = new AlertDialog.Builder(context);
    final DialogInterface.OnClickListener listener = new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialog, final int whichButton) {
        setPreferenceValue();
        nowPlaying.refresh();
      }
    };
    this.builder.setPositiveButton(android.R.string.ok, listener)
        .setNegativeButton(android.R.string.cancel, null)
        .setSingleChoiceItems(R.array.entries_movies_sort_preference, 0, null);
  }

  public NowPlayingPreferenceDialog create() {
    this.builder.create();
    return this;
  }

  public NowPlayingPreferenceDialog setIcon(final Drawable icon) {
    this.builder.setIcon(icon);
    return this;
  }

  public NowPlayingPreferenceDialog setInverseBackgroundForced(final boolean useInverseBackground) {

    this.builder.setInverseBackgroundForced(useInverseBackground);
    return this;
  }

  public NowPlayingPreferenceDialog setNegativeButton(final int textId, final OnClickListener listener) {
    this.builder.setNegativeButton(textId, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setOnItemSelectedListener(final OnItemSelectedListener listener) {
    this.builder.setOnItemSelectedListener(listener);
    return this;
  }

  public NowPlayingPreferenceDialog setEntries(final int items) {
    final DialogInterface.OnClickListener listener = new DialogInterface.OnClickListener() {
      public void onClick(final DialogInterface dialog, final int which) {
        NowPlayingPreferenceDialog.this.preference_value = which;
      }
    };
    this.preference_value = getPreferenceValue();
    setSingleChoiceItems(items, this.preference_value, listener);
    return this;
  }

  private NowPlayingPreferenceDialog setSingleChoiceItems(final int items, final int checkedItem, final OnClickListener listener) {
    this.builder.setSingleChoiceItems(items, checkedItem, listener);
    return this;
  }

  public NowPlayingPreferenceDialog setTitle(final int title) {
    this.builder.setTitle(title);
    return this;
  }

  public NowPlayingPreferenceDialog setKey(final Preference_keys key) {
    this.preference_key = key;
    return this;
  }

  public NowPlayingPreferenceDialog show() {
    this.builder.show();
    return this;
  }

  private int getPreferenceValue() {
    switch (this.preference_key) {
      case MOVIES_SORT:
        return NowPlayingControllerWrapper.getAllMoviesSelectedSortIndex();
      case THEATERS_SORT:
        return NowPlayingControllerWrapper.getAllTheatersSelectedSortIndex();
    }
    return 0;
  }

  private void setPreferenceValue() {
    switch (this.preference_key) {
      case MOVIES_SORT:
        NowPlayingControllerWrapper.setAllMoviesSelectedSortIndex(this.preference_value);
        break;
      case THEATERS_SORT:
        NowPlayingControllerWrapper.setAllTheatersSelectedSortIndex(this.preference_value);
        break;
    }
  }

  public enum Preference_keys {
    MOVIES_SORT, THEATERS_SORT
  }
}
