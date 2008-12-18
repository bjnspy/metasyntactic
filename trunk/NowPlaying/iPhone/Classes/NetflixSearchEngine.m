//
//  NetflixSearchEngine.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixSearchEngine.h"

#import "NetflixCache.h"
#import "NetworkUtilities.h"
#import "NowPlayingModel.h"
#import "SearchRequest.h"
#import "SearchResult.h"

@implementation NetflixSearchEngine

- (void) dealloc {    
    [super dealloc];
}


- (id) initWithModel:(NowPlayingModel*) model_
            delegate:(id<SearchEngineDelegate>) delegate_ {
    if (self = [super initWithModel:model_ delegate:delegate_]) {
    }
    
    return self;
}


+ (NetflixSearchEngine*) engineWithModel:(NowPlayingModel*) model
                         delegate:(id<SearchEngineDelegate>) delegate {
    return [[[NetflixSearchEngine alloc] initWithModel:model delegate:delegate] autorelease];
}


- (void) search {
    NSArray* movies = nil;
    /*
    NSArray* theaters = nil;
    NSArray* upcomingMovies = nil;
    NSArray* dvds = nil;
    NSArray* bluray = nil;
     */
    
    OAMutableURLRequest* request = [model.netflixCache createURLRequest:@"http://api.netflix.com/catalog/titles/autocomplete"];
    
    NSArray* parameters = [NSArray arrayWithObjects:
                           [OARequestParameter parameterWithName:@"term" value:currentlyExecutingRequest.lowercaseValue], nil];
    
    [request setParameters:parameters];
    [request prepare];
    
    NSString* result = [NetworkUtilities stringWithContentsOfUrlRequest:request
                                                              important:YES];
    
    NSLog(@"%@", result);
    [self reportResult:movies
              theaters:nil
        upcomingMovies:nil
                  dvds:nil
                bluray:nil];
}

@end