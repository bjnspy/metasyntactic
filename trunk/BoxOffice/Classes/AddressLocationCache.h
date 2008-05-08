//
//  TheaterLocationCache.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Location.h"

@interface AddressLocationCache : NSObject {
    NSLock* gate;
}

@property (retain) NSLock* gate;

+ (AddressLocationCache*) cache;

- (void) update:(NSArray*) addresses;

- (Location*) locationForAddress:(NSString*) address;

@end
