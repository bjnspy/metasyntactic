//
//  TheaterLocationCache.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Location.h"

@class BoxOfficeModel;

@interface AddressLocationCache : NSObject {
    NSLock* gate;
}

@property (retain) NSLock* gate;

+ (AddressLocationCache*) cache;

- (void) updateAddresses:(NSArray*) addresses;
- (void) updateZipcode:(NSString*) zipcode;

- (Location*) locationForAddress:(NSString*) address;
- (Location*) locationForZipcode:(NSString*) zipcode;

@end
