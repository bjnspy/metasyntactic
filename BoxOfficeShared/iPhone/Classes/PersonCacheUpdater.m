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

#import "PersonCacheUpdater.h"

#import "AmazonCache.h"
#import "BlurayCache.h"
#import "DVDCache.h"
#import "IMDbCache.h"
#import "MetacriticCache.h"
#import "MoviePosterCache.h"
#import "PersonPosterCache.h"
#import "RottenTomatoesCache.h"
#import "ScoreCache.h"
#import "TrailerCache.h"
#import "UpcomingCache.h"
#import "WikipediaCache.h"

@implementation PersonCacheUpdater

static PersonCacheUpdater* updater = nil;

+ (void) initialize {
  if (self == [PersonCacheUpdater class]) {
    updater = [[PersonCacheUpdater alloc] init];
  }
}


+ (PersonCacheUpdater*) updater {
  return updater;
}


- (void) prioritizePerson:(Person*) person now:(BOOL) now {
  [self prioritizeObject:person now:now];
}


- (void) processObject:(Person*) person
                force:(NSNumber*) forceNumber {
  NSLog(@"PersonCacheUpdater:processPerson - %@", person.name);

  BOOL force = forceNumber.boolValue;
  if (force) {
    [ThreadingUtilities backgroundSelector:@selector(updateImageWorker:force:)
                                  onTarget:self
                                withObject:person
                                withObject:forceNumber
                                      gate:nil
                                    daemon:NO];
  }

  if (force) {
    [NotificationCenter addNotification:person.name];
  }

  [[IMDbCache cache]            processPerson:person force:force];
  [[WikipediaCache cache]       processPerson:person force:force];
  [[RottenTomatoesCache cache]  processPerson:person force:force];

  [[NetflixCache cache]         processPerson:person force:force];
  if (!force) {
    [[PersonPosterCache cache]    processPerson:person force:NO];
  }

  [MetasyntacticSharedApplication minorRefresh];

  if (force) {
    [NotificationCenter removeNotification:person.name];
  }
}


- (Operation2*) addSearchPerson:(Person*) person {
  return [self addSearchObject:person];
}


- (void) addPerson:(Person*) person {
  [self addObject:person];
}


- (void) addSearchPeople:(NSArray*) people {
  [self addSearchObjects:people];
}


- (void) addPeople:(NSArray*) people {
  [self addObjects:people];
}


- (void) updateImageWorker:(Person*) person
                     force:(NSNumber*) force {
  [[PersonPosterCache cache] processPerson:person
                                     force:force.boolValue];
}


- (void) updateImageWorker:(Person*) person {
  [self updateImageWorker:person
                    force:[NSNumber numberWithBool:NO]];
}

@end
