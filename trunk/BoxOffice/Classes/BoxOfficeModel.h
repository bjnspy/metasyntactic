//
//  BoxOfficeModel.h
//  BoxOfficeApplication
//
//  Created by Cyrus Najmabadi on 4/26/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface BoxOfficeModel : NSObject {
}

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

@end
