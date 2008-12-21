// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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