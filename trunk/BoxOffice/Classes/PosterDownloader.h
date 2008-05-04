//
//  PosterDownloader.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Movie.h"

@interface PosterDownloader : NSObject {
    Movie* movie;
    NSMutableArray* identifiers;
    NSMutableDictionary* titleToPosterUrlMap;
}

@property (retain) Movie* movie;
@property (retain) NSMutableArray* identifiers;
@property (retain) NSMutableDictionary* titleToPosterUrlMap;

+ (NSData*) download:(Movie*) movie;

- (id) initWithMovie:(Movie*) movie;
- (void) dealloc;

- (void) sleep;

- (NSData*) go;
- (void) searchForItems;
- (void) lookupItems;
- (void) lookupItem1:(NSString*) item1
               item2:(NSString*) item2;
- (NSString*) findBestTitle;
- (NSData*) downloadBestPoster:(NSString*) title;

@end
