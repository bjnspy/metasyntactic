package org.metasyntactic;

import android.content.Context;

public interface RefreshableContext {
  /**
   * Updates the current tab view.
   */
  void refresh();
  
  Context getContext();
}