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
    [NotificationCenter addNotification:person.name];
  }

  [[PersonPosterCache cache]    processPerson:person force:force];
  [[NetflixCache cache]         processPerson:person force:force];
  [[IMDbCache cache]            processPerson:person force:force];
  [[WikipediaCache cache]       processPerson:person force:force];
  [[RottenTomatoesCache cache]  processPerson:person force:force];

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


- (void) updateImageWorker:(Person*) person {
  [[PersonPosterCache cache] processPerson:person force:NO];
}

@end
