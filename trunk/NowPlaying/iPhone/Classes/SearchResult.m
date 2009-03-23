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
@property NSInteger requestId_;
@property (copy) NSString* value_;
@property (retain) NSArray* movies_;
@property (retain) NSArray* theaters_;
@property (retain) NSArray* upcomingMovies_;
@property (retain) NSArray* dvds_;
@property (retain) NSArray* bluray_;
@end


@implementation SearchResult

@synthesize requestId_;
@synthesize value_;
@synthesize movies_;
@synthesize theaters_;
@synthesize upcomingMovies_;
@synthesize dvds_;
@synthesize bluray_;

property_wrapper(NSInteger, requestId, RequestId);
property_wrapper(NSString*, value, Value);
property_wrapper(NSArray*, movies, Movies);
property_wrapper(NSArray*, theaters, Theaters);
property_wrapper(NSArray*, upcomingMovies, UpcomingMovies);
property_wrapper(NSArray*, dvds, Dvds);
property_wrapper(NSArray*, bluray, Bluray);

- (void) dealloc {
    self.requestId = 0;
    self.value = nil;
    self.movies = nil;
    self.theaters = nil;
    self.upcomingMovies = nil;
    self.dvds = nil;
    self.bluray = nil;

    [super dealloc];
}


- (id) initWithId:(NSInteger) requestId__
            value:(NSString*) value__
           movies:(NSArray*) movies__
         theaters:(NSArray*) theaters__
   upcomingMovies:(NSArray*) upcomingMovies__
             dvds:(NSArray*) dvds__
           bluray:(NSArray*) bluray__ {
    if (self = [super init]) {
        self.requestId = requestId__;
        self.value = value__;
        self.movies = movies__;
        self.theaters = theaters__;
        self.upcomingMovies = upcomingMovies__;
        self.dvds = dvds__;
        self.bluray = bluray__;
    }

    return self;
}


+ (SearchResult*) resultWithId:(NSInteger) requestId
                         value:(NSString*) value
                        movies:(NSArray*) movies
                      theaters:(NSArray*) theaters
                upcomingMovies:(NSArray*) upcomingMovies
                          dvds:(NSArray*) dvds
                        bluray:(NSArray*) bluray {
    return [[[SearchResult alloc] initWithId:requestId
                                       value:value
                                      movies:movies
                                    theaters:theaters
                              upcomingMovies:upcomingMovies
                                        dvds:dvds
                                      bluray:bluray] autorelease];
}

@end