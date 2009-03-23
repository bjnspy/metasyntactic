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

#import "DataProviderUpdateDelegate.h"

@interface Controller : NSObject<DataProviderUpdateDelegate> {
@private
    LocationManager* locationManager;

    NSLock* determineLocationLock;
}

@property (readonly, retain) LocationManager* locationManager;

- (void) start;

- (void) setSearchDate:(NSDate*) searchDate;
- (void) setUserAddress:(NSString*) userAddress;
- (void) setSearchRadius:(NSInteger) radius;
- (void) setScoreProviderIndex:(NSInteger) index;

- (void) setAutoUpdateLocation:(BOOL) value;
- (void) setDvdBlurayEnabled:(BOOL) value;
- (void) setUpcomingEnabled:(BOOL) value;
- (void) setNetflixEnabled:(BOOL) value;

- (void) setNetflixKey:(NSString*) key secret:(NSString*) secret userId:(NSString*) userId;

+ (Controller*) controller;

@end