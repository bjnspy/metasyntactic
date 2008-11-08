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

#import "LookupResult.h"

@implementation LookupResult

@synthesize movies;
@synthesize theaters;
@synthesize performances;
@synthesize synchronizationData;

- (void) dealloc {
    self.movies = nil;
    self.theaters = nil;
    self.performances = nil;
    self.synchronizationData = nil;

    [super dealloc];
}


- (id) initWithMovies:(NSMutableArray*) movies_
             theaters:(NSMutableArray*) theaters_
         performances:(NSMutableDictionary*) performances_
 synchronizationData:(NSMutableDictionary*) synchronizationData_ {
    if (self = [super init]) {
        self.movies = movies_;
        self.theaters = theaters_;
        self.performances = performances_;
        self.synchronizationData = synchronizationData_;
    }

    return self;
}


+ (LookupResult*) resultWithMovies:(NSMutableArray*) movies
                          theaters:(NSMutableArray*) theaters
                      performances:(NSMutableDictionary*) performances
              synchronizationData:(NSMutableDictionary*) synchronizationData {
    return [[[LookupResult alloc] initWithMovies:movies
                                        theaters:theaters
                                    performances:performances
                            synchronizationData:synchronizationData] autorelease];
}


@end