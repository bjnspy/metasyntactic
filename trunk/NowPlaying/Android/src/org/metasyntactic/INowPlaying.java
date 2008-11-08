package org.metasyntactic;


import android.content.Context;

public interface INowPlaying {


  /** Updates the current tab view. */
  public void refresh();


  public Context getContext();


  public NowPlayingControllerWrapper getController();

}
