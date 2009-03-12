package org.metasyntactic;

import android.content.Context;
import org.metasyntactic.services.NowPlayingServiceWrapper;

public interface RefreshableContext {
  /**
   * Updates the current tab view.
   */
  void refresh();

  Context getContext();
  NowPlayingServiceWrapper getService();
}