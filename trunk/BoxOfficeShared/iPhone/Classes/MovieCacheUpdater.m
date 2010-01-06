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

#import "MovieCacheUpdater.h"

#import "AmazonCache.h"
#import "BlurayCache.h"
#import "DVDCache.h"
#import "IMDbCache.h"
#import "MetacriticCache.h"
#import "MoviePosterCache.h"
#import "RottenTomatoesCache.h"
#import "ScoreCache.h"
#import "TrailerCache.h"
#import "UpcomingCache.h"
#import "WikipediaCache.h"

@implementation MovieCacheUpdater

static MovieCacheUpdater* updater = nil;

+ (void) initialize {
  if (self == [MovieCacheUpdater class]) {
    updater = [[MovieCacheUpdater alloc] init];
  }
}


- (id) init {
  if ((self = [super init])) {
  }

  return self;
}


+ (MovieCacheUpdater*) updater {
  return updater;
}


- (void) prioritizeMovie:(Movie*) movie now:(BOOL) now {
  [self prioritizeObject:movie now:now];
}

- (void) addSearchMovies:(NSArray*) movies {
  [self addSearchObjects:movies];
}


- (void) addMovie:(Movie*) movie {
  [self addObject:movie];
}


- (void) addMovies:(NSArray*) movies {
  [self addObjects:movies];
}


- (void) processObject:(Movie*) movie
                force:(NSNumber*) forceNumber {
  NSLog(@"CacheUpdater:processMovie - %@", movie.canonicalTitle);

  BOOL force = forceNumber.boolValue;
  if (force) {
    [NotificationCenter addNotification:movie.canonicalTitle];
  }

  [[MoviePosterCache cache]     processMovie:movie force:force];
  [[NetflixCache cache]         processMovie:movie force:force];
  [[UpcomingCache cache]        processMovie:movie force:force];
  [[DVDCache cache]             processMovie:movie force:force];
  [[BlurayCache cache]          processMovie:movie force:force];
  [[ScoreCache cache]           processMovie:movie force:force];
  [[TrailerCache cache]         processMovie:movie force:force];
  [[IMDbCache cache]            processMovie:movie force:force];
  [[AmazonCache cache]          processMovie:movie force:force];
  [[WikipediaCache cache]       processMovie:movie force:force];
  [[RottenTomatoesCache cache]  processMovie:movie force:force];
  [[MetacriticCache cache]      processMovie:movie force:force];

  [MetasyntacticSharedApplication minorRefresh];

  if (force) {
    [NotificationCenter removeNotification:movie.canonicalTitle];
  }
}


- (Operation2*) addSearchMovie:(Movie*) movie {
  return [self addSearchObject:movie];
}


- (void) updateImageWorker:(Movie*) movie {
  [[MoviePosterCache cache] processMovie:movie force:NO];
}

@end
