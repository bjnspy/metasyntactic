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

@interface SearchResult()
@property (retain) NSArray* movies;
@property (retain) NSArray* theaters;
@property (retain) NSArray* upcomingMovies;
@property (retain) NSArray* dvds;
@property (retain) NSArray* bluray;
@property (retain) NSArray* people;
@end


@implementation SearchResult

@synthesize movies;
@synthesize theaters;
@synthesize upcomingMovies;
@synthesize dvds;
@synthesize bluray;
@synthesize people;

- (void) dealloc {
    self.movies = nil;
    self.theaters = nil;
    self.upcomingMovies = nil;
    self.dvds = nil;
    self.bluray = nil;
    self.people = nil;

    [super dealloc];
}


- (id) initWithId:(NSInteger) requestId_
            value:(NSString*) value_
           movies:(NSArray*) movies_
         theaters:(NSArray*) theaters_
   upcomingMovies:(NSArray*) upcomingMovies_
             dvds:(NSArray*) dvds_
           bluray:(NSArray*) bluray_
           people:(NSArray*) people_ {
  if ((self = [super initWithId:requestId_ value:value_])) {
        self.movies = movies_;
        self.theaters = theaters_;
        self.upcomingMovies = upcomingMovies_;
        self.dvds = dvds_;
        self.bluray = bluray_;
        self.people = people_;
    }

    return self;
}


+ (SearchResult*) resultWithId:(NSInteger) requestId
                         value:(NSString*) value
                        movies:(NSArray*) movies
                      theaters:(NSArray*) theaters
                upcomingMovies:(NSArray*) upcomingMovies
                          dvds:(NSArray*) dvds
                        bluray:(NSArray*) bluray
                        people:(NSArray*) people {
    return [[[SearchResult alloc] initWithId:requestId
                                       value:value
                                      movies:movies
                                    theaters:theaters
                              upcomingMovies:upcomingMovies
                                        dvds:dvds
                                      bluray:bluray
                                      people:people] autorelease];
}

@end
