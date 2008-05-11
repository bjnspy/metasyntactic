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

+ (NSData*) download:(Movie*) movie;

@end