package org.metasyntactic;

import android.app.Activity;
import android.graphics.PixelFormat;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.widget.MediaController;
import android.widget.Toast;
import android.widget.VideoView;

public class VideoViewActivity extends Activity {
    /**
     * TODO: Set the path variable to a streaming video URL or a local media
     * file path.
     */
    private String path;
    private VideoView mVideoView;

    @Override
    public void onCreate(Bundle icicle) {
        super.onCreate(icicle);
        setContentView(R.layout.videoview);
        path = getIntent().getExtras().getString("trailer_url");
        mVideoView = (VideoView) findViewById(R.id.surface_view);
        mVideoView.setVideoURI(Uri.parse(path));
        //  mVideoView.setVideoPath(path);
        mVideoView.setMediaController(new MediaController(this));
        mVideoView.requestFocus();
        mVideoView.start();
    }
}
