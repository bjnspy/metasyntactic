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

#import "SearchResult.h"

@implementation SearchResult

@synthesize requestId;
@synthesize value;
@synthesize movies;
@synthesize theaters;
@synthesize upcomingMovies;
@synthesize dvds;

- (void) dealloc {
    self.requestId = 0;
    self.value = nil;
    self.movies = nil;
    self.theaters = nil;
    self.upcomingMovies = nil;
    self.dvds = nil;

    [super dealloc];
}


- (id) initWithId:(NSInteger) requestId_
            value:(NSString*) value_
           movies:(NSArray*) movies_
         theaters:(NSArray*) theaters_
   upcomingMovies:(NSArray*) upcomingMovies_
             dvds:(NSArray*) dvds_ {
    if (self = [super init]) {
        self.requestId = requestId_;
        self.value = value_;
        self.movies = movies_;
        self.theaters = theaters_;
        self.upcomingMovies = upcomingMovies_;
        self.dvds = dvds_;
    }

    return self;
}


+ (SearchResult*) resultWithId:(NSInteger) requestId
                         value:(NSString*) value
                        movies:(NSArray*) movies
                      theaters:(NSArray*) theaters
                upcomingMovies:(NSArray*) upcomingMovies 
                          dvds:(NSArray*) dvds {
    return [[[SearchResult alloc] initWithId:requestId
                                       value:value
                                      movies:movies
                                    theaters:theaters
                              upcomingMovies:upcomingMovies
                                        dvds:dvds] autorelease];
}


@end