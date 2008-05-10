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
}

@property (retain) Movie* movie;

+ (NSData*) download:(Movie*) movie;

- (id) initWithMovie:(Movie*) movie;

@end
