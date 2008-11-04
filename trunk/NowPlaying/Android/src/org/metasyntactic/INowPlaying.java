package org.metasyntactic;



import org.metasyntactic.data.Movie;

import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;

import android.app.TabActivity;
import android.content.Context;

public interface INowPlaying  {

   

    /** Updates the current tab view. */
    public void refresh();

    public Context getContext();

    public NowPlayingControllerWrapper getController();   

}
