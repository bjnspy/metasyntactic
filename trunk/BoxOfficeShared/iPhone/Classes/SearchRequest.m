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

#import "BlurayCache.h"
#import "DVDCache.h"
#import "Model.h"
#import "UpcomingCache.h"

@interface SearchRequest()
@property (retain) NSArray* movies;
@property (retain) NSArray* theaters;
@property (retain) NSArray* upcomingMovies;
@property (retain) NSArray* dvds;
@property (retain) NSArray* bluray;
@property (retain) NetflixAccount* account;
@end


@implementation SearchRequest

@synthesize movies;
@synthesize theaters;
@synthesize upcomingMovies;
@synthesize dvds;
@synthesize bluray;
@synthesize account;

- (void) dealloc {
  self.movies = nil;
  self.theaters = nil;
  self.upcomingMovies = nil;
  self.dvds = nil;
  self.bluray = nil;
  self.account = nil;

  [super dealloc];
}


- (id) initWithId:(NSInteger) requestId_
            value:(NSString*) value_ {
  if ((self = [super initWithId:requestId_ value:value_])) {
    Model* model = [Model model];
    self.movies = model.movies;
    self.theaters = model.theaters;
    self.upcomingMovies = [[UpcomingCache cache] movies];
    self.dvds = [[DVDCache cache] movies];
    self.bluray = [[BlurayCache cache] movies];
    self.account = [[NetflixAccountCache cache] currentAccount];
  }

  return self;
}


+ (SearchRequest*) requestWithId:(NSInteger) requestId
                           value:(NSString*) value {
  return [[[SearchRequest alloc] initWithId:requestId value:value] autorelease];
}

@end
