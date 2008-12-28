//
//  WikipediaCache.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/28/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WikipediaCache.h"

#import "Application.h"
#import "FileUtilities.h"
#import "LinkedSet.h"
#import "Movie.h"
#import "NetworkUtilities.h"
#import "NowPlayingAppDelegate.h"
#import "NowPlayingModel.h"
#import "ThreadingUtilities.h"
#import "Utilities.h"

@interface WikipediaCache()
@property (retain) LinkedSet* prioritizedMovies;
@end


@implementation WikipediaCache

@synthesize prioritizedMovies;

- (void) dealloc {
    self.prioritizedMovies = nil;
    
    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_ {
    if (self = [super initWithModel:model_]) {
        self.prioritizedMovies = [LinkedSet setWithCountLimit:8];
    }
    
    return self;
}


+ (WikipediaCache*) cacheWithModel:(NowPlayingModel*) model {
    return [[[WikipediaCache alloc] initWithModel:model] autorelease];
}


- (NSString*) wikipediaFile:(Movie*) movie {
    NSString* name = [[FileUtilities sanitizeFileName:movie.canonicalTitle] stringByAppendingPathExtension:@"plist"];
    return [[Application imdbDirectory] stringByAppendingPathComponent:name];
}


- (void) update:(NSArray*) movies {
    if (model.userAddress.length == 0) {
        return;
    }
    
    [ThreadingUtilities backgroundSelector:@selector(backgroundEntryPoint:)
                                  onTarget:self
                                  argument:movies
                                      gate:gate
                                   visible:NO];
}


- (void) downloadAddress:(Movie*) movie {
    NSString* path = [self wikipediaFile:movie];
    NSDate* lastLookupDate = [FileUtilities modificationDate:path];
    
    if (lastLookupDate != nil) {
        NSString* value = [FileUtilities readObject:path];
        if (value.length > 0) {
            // we have a real imdb value for this movie
            return;
        }
        
        // we have a sentinel.  only update if it's been long enough
        if (ABS(lastLookupDate.timeIntervalSinceNow) < (3 * ONE_DAY)) {
            return;
        }
    }
    
    NSString* url = [NSString stringWithFormat:@"http://%@.appspot.com/LookupWikipediaListings?q=%@", [Application host], [Utilities stringByAddingPercentEscapes:movie.canonicalTitle]];
    NSString* wikipediaAddress = [NetworkUtilities stringWithContentsOfAddress:url important:NO];
    if (wikipediaAddress == nil) {
        return;
    }
    
    // write down the response (even if it is empty).  An empty value will
    // ensure that we don't update this entry too often.
    [FileUtilities writeObject:wikipediaAddress toFile:path];
    if (wikipediaAddress.length > 0) {
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (Movie*) getNextMovie:(NSMutableArray*) movies {
    Movie* movie;
    while ((movie = [prioritizedMovies removeLastObjectAdded]) != nil) {
        if (![FileUtilities fileExists:[self wikipediaFile:movie]]) {
            return movie;
        }
    }
    
    if (movies.count > 0) {
        movie = [[[movies lastObject] retain] autorelease];
        [movies removeLastObject];
        return movie;
    }
    
    return nil;
}


- (void) backgroundEntryPoint:(NSArray*) movies {
    NSMutableArray* mutableMovies = [NSMutableArray arrayWithArray:movies];
    Movie* movie;
    while ((movie = [self getNextMovie:mutableMovies]) != nil) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self downloadAddress:movie];
        }
        [pool release];
    }
}


- (void) prioritizeMovie:(Movie*) movie {
    [prioritizedMovies addObject:movie];
}


- (NSString*) wikipediaAddressForMovie:(Movie*) movie {
    return [FileUtilities readObject:[self wikipediaFile:movie]];
}

@end