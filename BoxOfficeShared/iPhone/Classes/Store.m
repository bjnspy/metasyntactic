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

#import "Store.h"

#import "Application.h"
#import "DeviceStore.h"
#import "Donation.h"
#import "Model.h"
#import "SimulatorStore.h"
#import "UnlockRequest.h"

@implementation Store

+ (AbstractStore*) store {
#if TARGET_IPHONE_SIMULATOR
  return [SimulatorStore simulatorStore];
#else
  return [DeviceStore deviceStore];
#endif
}


+ (NSArray*) donationsArray {
  return [NSArray arrayWithObjects:
          [Donation donationWithItunesIdentifier:@"org.metasyntactic.BoxOffice.Donation1"],
          [Donation donationWithItunesIdentifier:@"org.metasyntactic.BoxOffice.Donation2"],
          [Donation donationWithItunesIdentifier:@"org.metasyntactic.BoxOffice.Donation3"],
          [Donation donationWithItunesIdentifier:@"org.metasyntactic.BoxOffice.Donation4"],
          [Donation donationWithItunesIdentifier:@"org.metasyntactic.BoxOffice.Donation5"], nil];
}

@end
