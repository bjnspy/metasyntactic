package org.metasyntactic.views;

import android.content.Context;
import android.database.DataSetObserver;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ListAdapter;
import android.widget.ListView;

import java.util.ArrayList;
import java.util.List;

/** @author cyrusn@google.com (Cyrus Najmabadi) */
public class AllMoviesView extends ListView implements ListAdapter {
  public List<String> movies = new ArrayList<String>();

  public AllMoviesView(Context context) {
    super(context);
    setAdapter(this);
  }

  public boolean areAllItemsEnabled() {
    return true;
  }

  public boolean isEnabled(int i) {
    return true;
  }

  public void registerDataSetObserver(DataSetObserver dataSetObserver) {
  }

  public void unregisterDataSetObserver(DataSetObserver dataSetObserver) {
  }

  public Object getItem(int i) {
    return movies.get(i);
  }

  public long getItemId(int i) {
    return 0;
  }

  public boolean hasStableIds() {
    return true;
  }

  public View getView(int i, View view, ViewGroup viewGroup) {
    Button button = new Button(getContext());
    button.setText(movies.get(i));
    return button;
  }

  public int getItemViewType(int i) {
    return 0;
  }

  public int getViewTypeCount() {
    return 1;
  }

  public boolean isEmpty() {
    return getCount() == 0;
  }

  @Override
public int getCount() {
    return movies.size();
  }
}
