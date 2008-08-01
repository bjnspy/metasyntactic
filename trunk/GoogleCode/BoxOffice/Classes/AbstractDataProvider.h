//
//  AbstractDataProvider.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 7/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookupResult.h"
#import "Movie.h"
#import "Theater.h"
#import "BoxOfficeModel.h"

@interface AbstractDataProvider : NSObject {
    BoxOfficeModel* model;
    NSArray* moviesData;
    NSArray* theatersData;
    
    NSMutableDictionary* performances;
}

@property (retain) BoxOfficeModel* model;
@property (retain) NSArray* moviesData;
@property (retain) NSArray* theatersData;
@property (retain) NSMutableDictionary* performances;

- (id) initWithModel:(BoxOfficeModel*) model;

- (NSString*) providerFolder;
- (void) invalidateDiskCache;

- (NSArray*) movies;
- (NSArray*) theaters;
- (NSArray*) moviePerformances:(Movie*) movie forTheater:(Theater*) theater;

- (void) setStale;
- (NSDate*) lastLookupDate;

- (void) lookup;
- (LookupResult*) lookupWorker;

@end
