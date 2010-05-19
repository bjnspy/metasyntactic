// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
