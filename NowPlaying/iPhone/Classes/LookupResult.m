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

@interface LookupResult()
@property (retain) Location* location;
@property (retain) NSMutableArray* movies;
@property (retain) NSMutableArray* theaters;
@property (retain) NSMutableDictionary* performances;
@property (retain) NSMutableDictionary* synchronizationInformation;
@end

@implementation LookupResult

@synthesize location;
@synthesize movies;
@synthesize theaters;
@synthesize performances;
@synthesize synchronizationInformation;

- (void) dealloc {
    self.location = nil;
    self.movies = nil;
    self.theaters = nil;
    self.performances = nil;
    self.synchronizationInformation = nil;

    [super dealloc];
}


- (id) initWithLocation:(Location*) location_
                 movies:(NSMutableArray*) movies_
               theaters:(NSMutableArray*) theaters_
           performances:(NSMutableDictionary*) performances_
    synchronizationInformation:(NSMutableDictionary*) synchronizationInformation_ {
    if (self = [super init]) {
        self.location = location_;
        self.movies = movies_;
        self.theaters = theaters_;
        self.performances = performances_;
        self.synchronizationInformation = synchronizationInformation_;
    }

    return self;
}


+ (LookupResult*) resultWithLocation:(Location*) location
                              movies:(NSMutableArray*) movies
                            theaters:(NSMutableArray*) theaters
                        performances:(NSMutableDictionary*) performances
          synchronizationInformation:(NSMutableDictionary*) synchronizationInformation {
    return [[[LookupResult alloc] initWithLocation:location
                                            movies:movies
                                          theaters:theaters
                                      performances:performances
                        synchronizationInformation:synchronizationInformation] autorelease];
}


@end