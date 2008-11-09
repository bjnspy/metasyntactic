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

@interface SettingsViewController : UITableViewController<CLLocationManagerDelegate> {
@private
    SettingsNavigationController* navigationController;
    CLLocationManager* locationManager;

    NSLock* gate;

    // a non-null value means we are actively searching.
    ActivityIndicator* activityIndicator;
}

- (id) initWithNavigationController:(SettingsNavigationController*) navigationController;

- (void) refresh;
- (NowPlayingModel*) model;
- (NowPlayingController*) controller;

- (void) locationManager:(CLLocationManager*) manager
     didUpdateToLocation:(CLLocation*) newLocation
            fromLocation:(CLLocation*) oldLocation;

- (void)locationManager:(CLLocationManager*) manager
       didFailWithError:(NSError*) error;

@end