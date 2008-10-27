package org.metasyntactic.views;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.graphics.drawable.Drawable;
import android.widget.AdapterView.OnItemSelectedListener;
import org.metasyntactic.NowPlayingActivity;
import org.metasyntactic.NowPlayingControllerWrapper;
import org.metasyntactic.R;

public class NowPlayingPreferenceDialog {

  private AlertDialog.Builder builder;

  private Preference_keys preference_key;

  private int preference_value;

  private NowPlayingActivity mNowPlayingActivityContext;

  private NowPlayingControllerWrapper mController;


  public NowPlayingPreferenceDialog(NowPlayingActivity context) {

    this.mNowPlayingActivityContext = context;
    mController = context.getController();
    builder = new AlertDialog.Builder(context);
    DialogInterface.OnClickListener listener =
        new DialogInterface.OnClickListener() {
          public void onClick(DialogInterface dialog, int whichButton) {
            setPreferenceValue();
            mNowPlayingActivityContext.refresh();
          }


        };
    builder.setPositiveButton(android.R.string.ok, listener)
        .setNegativeButton(android.R.string.cancel, null)
        .setSingleChoiceItems(R.array.entries_movies_sort_preference, 0,
            null);

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


  public NowPlayingPreferenceDialog setInverseBackgroundForced(
      boolean useInverseBackground) {

    builder.setInverseBackgroundForced(useInverseBackground);
    return this;
  }


  public NowPlayingPreferenceDialog setNegativeButton(int textId,
                                                      OnClickListener listener) {
    // TODO Auto-generated method stub
    builder.setNegativeButton(textId, listener);
    return this;
  }


  public NowPlayingPreferenceDialog setOnItemSelectedListener(
      OnItemSelectedListener listener) {
    // TODO Auto-generated method stub
    builder.setOnItemSelectedListener(listener);
    return this;
  }


  private NowPlayingPreferenceDialog setPositiveButton(int textId,
                                                       OnClickListener listener) {
    // TODO Auto-generated method stub


    builder.setPositiveButton(textId, listener);
    return this;
  }


  public NowPlayingPreferenceDialog setEntries(int items) {
    // TODO Auto-generated method stub
    DialogInterface.OnClickListener mListener =
        new DialogInterface.OnClickListener() {
          public void onClick(DialogInterface dialog, int which) {
            // TODO Auto-generated method stub
            preference_value = which;
          }

        };
    preference_value = getPreferenceValue();
    setSingleChoiceItems(items, preference_value, mListener);
    return this;
  }


  private NowPlayingPreferenceDialog setSingleChoiceItems(int items,
                                                          int checkedItem, OnClickListener listener) {
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

        return mController.getAllMoviesSelectedSortIndex();
      case THEATERS_SORT:

        return mController.getAllTheatersSelectedSortIndex();

    }
    return 0;

  }


  private void setPreferenceValue() {

    switch (preference_key) {

      case MOVIES_SORT:
        mController.setAllMoviesSelectedSortIndex(preference_value);
        break;
      case THEATERS_SORT:
        mController.setAllTheatersSelectedSortIndex(preference_value);

    }

  }


  public enum Preference_keys {
    MOVIES_SORT, THEATERS_SORT
  }


}
