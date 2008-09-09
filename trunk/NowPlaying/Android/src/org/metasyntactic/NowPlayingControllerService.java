package org.metasyntactic;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.os.RemoteException;

public class NowPlayingControllerService extends Service {
  private final NowPlayingModel model = new NowPlayingModel();

  @Override
  public void onCreate() {
    super.onCreate();

    model.update();
  }

  private final INowPlayingController.Stub binder = new INowPlayingController.Stub() {
    public void setUserLocation(String userLocation) throws RemoteException {
      NowPlayingControllerService.this.setUserLocation(userLocation);
    }
  };

  @Override
  public IBinder onBind(Intent arg0) {
    return binder;
  }

  public void setUserLocation(String userLocation) throws RemoteException {
  }
}
