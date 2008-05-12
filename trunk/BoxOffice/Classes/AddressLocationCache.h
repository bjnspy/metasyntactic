//
//  TheaterLocationCache.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Location.h"

@class BoxOfficeModel;

@interface AddressLocationCache : NSObject {
	BoxOfficeModel* model;
    NSLock* gate;
}

@property (assign) BoxOfficeModel* model;
@property (retain) NSLock* gate;

+ (AddressLocationCache*) cacheWithModel:(BoxOfficeModel*) model;

- (void) updateAddresses:(NSArray*) addresses;
- (void) updateZipcode:(NSString*) zipcode;

- (Location*) locationForAddress:(NSString*) address;
- (Location*) locationForZipcode:(NSString*) zipcode;

@end
