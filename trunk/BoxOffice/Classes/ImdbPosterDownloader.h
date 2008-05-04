//
//  ImdbPosterDownloader.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PosterDownloader.h"

@interface ImdbPosterDownloader : PosterDownloader {
    
}

- (id) initWithMovie:(Movie*) movie;
- (void) dealloc;

- (NSData*) go;

- (NSString*) imdbId;
- (NSString*) imageUrl:(NSString*) imdbId;
- (NSData*) downloadImage:(NSString*) imageUrl;

@end
