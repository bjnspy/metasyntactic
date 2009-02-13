package org.metasyntactic;

import android.content.Context;

public interface INowPlaying {
  /** Updates the current tab view. */
  void refresh();

  Context getContext();
}