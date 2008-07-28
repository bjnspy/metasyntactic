//
//  DataProvider.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookupResult.h"
#import "Movie.h"
#import "Theater.h"

@protocol DataProvider
- (void) invalidateDiskCache;
- (void) lookup;

- (void) setStale;
- (NSDate*) lastLookupDate;

- (NSArray*) movies;
- (NSArray*) theaters;
- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater;
@end
