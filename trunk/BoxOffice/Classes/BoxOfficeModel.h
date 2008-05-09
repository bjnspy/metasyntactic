//
//  BoxOfficeModel.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PosterCache.h"
#import "AddressLocationCache.h"

@interface BoxOfficeModel : NSObject {
    PosterCache* posterCache;
    AddressLocationCache* addressLocationCache;
}

@property (retain) PosterCache* posterCache;
@property (retain) AddressLocationCache* addressLocationCache;

- (id) init;
- (void) dealloc;

- (NSString*) zipcode;
- (void) setZipcode:(NSString*) zipcode;

- (NSInteger) searchRadius;
- (void) setSearchRadius:(NSInteger) searchRadius;

- (NSArray*) movies;
- (void) setMovies:(NSArray*) movies;

- (NSArray*) theaters;
- (void) setTheaters:(NSArray*) theaters;

- (UIImage*) posterForMovie:(Movie*) movie;
- (Location*) locationForAddress:(NSString*) address;
- (Location*) locationForZipcode:(NSString*) zipcode;

@end
