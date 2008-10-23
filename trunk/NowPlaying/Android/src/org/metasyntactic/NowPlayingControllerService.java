//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

package org.metasyntactic;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.os.RemoteException;
import org.metasyntactic.caches.scores.ScoreType;
import org.metasyntactic.data.Movie;
import org.metasyntactic.data.Score;
import org.metasyntactic.data.Theater;
import org.metasyntactic.threading.ThreadingUtilities;

import java.util.List;

public class NowPlayingControllerService extends Service {
	{
		Application.setContext(this);
	}

	private final NowPlayingModel model = new NowPlayingModel(this);
	private final Object lock = new Object();


	@Override
	public void onCreate() {
		super.onCreate();

		update();
	}


	private void update() {
		Runnable runnable = new Runnable() {
			public void run() {
				model.update();
			}
		};

		ThreadingUtilities.performOnBackgroundThread(runnable, lock, false/* visible */);
	}


	@Override
	public IBinder onBind(Intent arg0) {
		return binder;
	}

	private final INowPlayingController.Stub binder = new INowPlayingController.Stub() {
		public String getUserLocation() throws RemoteException {
			return model.getUserLocation();
		}


		public void setUserLocation(String userLocation) throws RemoteException {
			model.setUserLocation(userLocation);
			update();
		}


		public int getSearchDistance() throws RemoteException {
			return model.getSearchDistance();
		}


		public void setSearchDistance(int searchDistance) throws RemoteException {
			model.setSearchDistance(searchDistance);
		}


		public int getSelectedTabIndex() throws RemoteException {
			return model.getSelectedTabIndex();
		}


		public void setSelectedTabIndex(int index) throws RemoteException {
			model.setSelectedTabIndex(index);
		}


		public int getAllMoviesSelectedSortIndex() throws RemoteException {
			return model.getAllMoviesSelecetedSortIndex();
		}


		public void setAllMoviesSelectedSortIndex(int index) throws RemoteException {
			model.setAllMoviesSelectedSortIndex(index);
		}


		public int getAllTheatersSelectedSortIndex() throws RemoteException {
			return model.getAllTheatersSelectedSortIndex();
		}


		public void setAllTheatersSelectedSortIndex(int index) throws RemoteException {
			model.setAllTheatersSelectedSortIndex(index);
		}


		public int getUpcomingMoviesSelectedSortIndex() throws RemoteException {
			return model.getUpcomingMoviesSelectedSortIndex();
		}


		public void setUpcomingMoviesSelectedSortIndex(int index) throws RemoteException {
			model.setUpcomingMoviesSelectedSortIndex(index);
    }


		public List<Movie> getMovies() throws RemoteException {
			return model.getMovies();
		}


		public List<Theater> getTheaters() throws RemoteException {
			return model.getTheaters();
		}


		public List<String> getTrailers(Movie movie) throws RemoteException {
			return model.getTrailers(movie);
		}


		public ScoreType getScoreType() throws RemoteException {
			return model.getScoreType();
		}


		public void setScoreType(ScoreType scoreType) throws RemoteException {
			model.setScoreType(scoreType);
			update();
		}


		public Score getScore(Movie movie) throws RemoteException {
			return model.getScore(movie);
		}
	};
}
