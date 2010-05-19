// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "Store.h"

#import "DeviceStore.h"
#import "Donation.h"
#import "SimulatorStore.h"

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
