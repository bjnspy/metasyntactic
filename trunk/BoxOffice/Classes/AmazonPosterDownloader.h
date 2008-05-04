//
//  AmazonPosterDownloader.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PosterDownloader.h"

@interface AmazonPosterDownloader : PosterDownloader {
    NSMutableArray* identifiers;
    NSMutableDictionary* titleToPosterUrlMap;
}

@property (retain) NSMutableArray* identifiers;
@property (retain) NSMutableDictionary* titleToPosterUrlMap;

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
