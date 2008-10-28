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

#import "SearchRequest.h"

#import "NowPlayingModel.h"
#import "UpcomingCache.h"
#import "Utilities.h"

@implementation SearchRequest

@synthesize requestId;
@synthesize value;
@synthesize lowercaseValue;
@synthesize movies;
@synthesize theaters;
@synthesize upcomingMovies;

- (void) dealloc {
    self.requestId = 0;
    self.value = nil;
    self.lowercaseValue = nil;
    self.movies = nil;
    self.theaters = nil;
    self.upcomingMovies = nil;

    [super dealloc];
}


- (id) initWithId:(NSInteger) requestId_
            value:(NSString*) value_
            model:(NowPlayingModel*) model {
    if (self = [super init]) {
        self.requestId = requestId_;
        self.value = value_;
        self.movies = model.movies;
        self.theaters = model.theaters;
        self.upcomingMovies = model.upcomingCache.upcomingMovies;

        self.lowercaseValue = [[Utilities asciiString:value] lowercaseString];
    }

    return self;
}


+ (SearchRequest*) requestWithId:(NSInteger) requestId
                           value:(NSString*) value
                           model:(NowPlayingModel*) model{
    return [[[SearchRequest alloc] initWithId:requestId value:value model:model] autorelease];
}

@end