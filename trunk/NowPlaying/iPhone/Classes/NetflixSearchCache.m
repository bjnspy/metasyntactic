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


- (BOOL) hasAccount {
    return model.netflixUserId.length > 0;
}


- (Movie*) lookupMovieWorker:(Movie*) movie {
    OAMutableURLRequest* request = [model.netflixCache createURLRequest:@"http://api.netflix.com/catalog/titles"];

    NSArray* parameters = [NSArray arrayWithObjects:
                           [OARequestParameter parameterWithName:@"term" value:movie.canonicalTitle],
                           [OARequestParameter parameterWithName:@"max_results" value:@"1"], nil];

    [request setParameters:parameters];
    [request prepare];

    XmlElement* element =
    [NetworkUtilities xmlWithContentsOfUrlRequest:request
                                        important:YES];

    [model.netflixCache checkApiResult:element];

    NSMutableArray* movies = [NSMutableArray array];
    NSMutableArray* saved = [NSMutableArray array];
    [model.netflixCache processMovieItemList:element movies:movies saved:saved];

    [movies addObjectsFromArray:saved];

    if (movies.count > 0) {
        Movie* netflixMovie = [movies objectAtIndex:0];
        if ([DifferenceEngine areSimilar:movie.canonicalTitle other:netflixMovie.canonicalTitle]) {
            return netflixMovie;
        }
    }

    return nil;
}


- (NSString*) netflixFile:(Movie*) movie {
    return [[[Application netflixSearchDirectory] stringByAppendingPathComponent:[FileUtilities sanitizeFileName:movie.canonicalTitle]] stringByAppendingPathExtension:@"plist"];
}


- (void) lookupMovieBackgroundEntryPoint:(Movie*) movie {
    NSString* file = [self netflixFile:movie];
    if ([FileUtilities fileExists:file]) {
        return;
    }

    Movie* netflixMovie = [self lookupMovieWorker:movie];
    if (netflixMovie != nil) {
        [FileUtilities writeObject:netflixMovie.dictionary toFile:file];
        [model.netflixCache addSearchResult:netflixMovie];
        [NowPlayingAppDelegate minorRefresh];
    }
}


- (void) lookupNetflixMovieForLocalMovie:(Movie*) movie {
    if ([self hasAccount]) {
        [ThreadingUtilities performSelector:@selector(lookupMovieBackgroundEntryPoint:)
                                   onTarget:self
                   inBackgroundWithArgument:movie
                                       gate:gate
                                    visible:NO];
    }
}


- (void) lookupNetflixMovieForLocalMovies:(NSArray*) movies {
    if ([self hasAccount]) {
        [ThreadingUtilities performSelector:@selector(lookupMoviesBackgroundEntryPoint:)
                                   onTarget:self
                   inBackgroundWithArgument:movies
                                       gate:gate
                                    visible:NO];
    }
}


- (void) lookupMoviesBackgroundEntryPoint:(NSArray*) movies {
    for (Movie* movie in movies) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            [self lookupMovieBackgroundEntryPoint:movie];
        }
        [pool release];
    }
}


- (NSSet*) cachedDirectoriesToClear {
    return [NSSet setWithObject:[Application netflixSearchDirectory]];
}


- (Movie*) netflixMovieForMovie:(Movie*) movie {
    if (movie.isNetflix) {
        return movie;
    }

    NSString* file = [self netflixFile:movie];
    NSDictionary* dictionary = [FileUtilities readObject:file];
    if (dictionary.count == 0) {
        return nil;
    }

    return [Movie movieWithDictionary:dictionary];
}

@end
