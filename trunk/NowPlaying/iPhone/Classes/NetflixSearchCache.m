//
//  NetflixSearchCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/22/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixSearchCache.h"

#import "Application.h"
#import "DifferenceEngine.h"
#import "FileUtilities.h"
#import "Movie.h"
#import "NetflixCache.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "ThreadingUtilities.h"

@implementation NetflixSearchCache

- (void) dealloc {
    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
    }

    return self;
}


+ (NetflixSearchCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[NetflixSearchCache alloc] initWithModel:model] autorelease];
}

@end
