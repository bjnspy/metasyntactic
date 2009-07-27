// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
package org.metasyntactic.activities;

import java.util.Map;

import org.metasyntactic.RefreshableContext;
import org.metasyntactic.services.NowPlayingServiceWrapper;

import android.app.ListActivity;
import android.content.Context;
import android.os.Bundle;

public abstract class AbstractNowPlayingListActivity extends ListActivity implements RefreshableContext {
  private final ActivityCore<AbstractNowPlayingListActivity> core = new ActivityCore<AbstractNowPlayingListActivity>(this);

  protected AbstractNowPlayingListActivity() {
  }

  @Override protected void onCreate(final Bundle bundle) {
    super.onCreate(bundle);
    core.onCreate();
  }

  @Override protected void onResume() {
    super.onResume();
    core.onResume();
  }

  @Override protected void onPause() {
    core.onPause();
    super.onPause();
  }

  @Override protected void onDestroy() {
    core.onDestroy();
    super.onDestroy();
  }

  @Override
  public Map<String, Object> onRetainNonConfigurationInstance() {
    return core.onRetainNonConfigurationInstance();
  }

  @SuppressWarnings({"unchecked"}) @Override public Map<String, Object> getLastNonConfigurationInstance() {
    return (Map<String, Object>)super.getLastNonConfigurationInstance();
  }

  public Context getContext() {
    return core.getContext();
  }

  public NowPlayingServiceWrapper getService() {
    return core.getService();
  }

  public void onCreateAfterServiceConnected() {
  }

  public void onResumeAfterServiceConnected() {
  }

  public void refresh() {
  }
}
