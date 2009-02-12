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
#import "Model.h"
#import "SearchRequest.h"
#import "SearchResult.h"

@implementation NetflixSearchEngine

- (void) dealloc {
    [super dealloc];
}


- (id) initWithModel:(Model*) model_
            delegate:(id<SearchEngineDelegate>) delegate_ {
    if (self = [super initWithModel:model_ delegate:delegate_]) {
    }

    return self;
}


+ (NetflixSearchEngine*) engineWithModel:(Model*) model
                         delegate:(id<SearchEngineDelegate>) delegate {
    return [[[NetflixSearchEngine alloc] initWithModel:model delegate:delegate] autorelease];
}


- (void) search {
    NSArray* movies = [model.netflixCache movieSearch:currentlyExecutingRequest.lowercaseValue];
    if ([self abortEarly]) { return; }
    NSArray* people = [model.netflixCache peopleSearch:currentlyExecutingRequest.lowercaseValue];
    if ([self abortEarly]) { return; }

    [self reportMovies:movies people:people];
}

@end