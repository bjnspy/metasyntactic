//
//  ImdbPosterDownloader.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/4/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "PosterDownloader.h"

@interface ImdbPosterDownloader : PosterDownloader {
}

+ (NSData*) download:(Movie*) movie;

@end