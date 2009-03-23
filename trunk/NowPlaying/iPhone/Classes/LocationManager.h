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

@interface LocationManager : NSObject<CLLocationManagerDelegate> {
@private
    Controller* controller_;
    NSLock* gate_;
    CLLocationManager* locationManager_;

    UINavigationItem* navigationItem_;
    UIBarButtonItem* buttonItem_;

    BOOL running_;
    BOOL firstTime_;
    BOOL userInvoked_;
}

+ (LocationManager*) managerWithController:(Controller*) controller;

- (void) autoUpdateLocation;

- (void) addLocationSpinner:(UINavigationItem*) navigationItem;

@end