//
//  BlurayCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "BlurayCache.h"

#import "Application.h"
#import "DateUtilities.h"
#import "DVD.h"
#import "FileUtilities.h"
#import "LargePosterCache.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "PointerSet.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"
#import "XmlElement.h"

@implementation BlurayCache

- (void) dealloc {
    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
    }
    
    return self;
}


+ (BlurayCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[BlurayCache alloc] initWithModel:model] autorelease];
}


- (NSString*) serverAddress {
    return [NSString stringWithFormat:@"http://%@.appspot.com/LookupDVDListings?q=bluray", [Application host]];
}


- (NSString*) directory {
    return [Application blurayDirectory];
}

@end