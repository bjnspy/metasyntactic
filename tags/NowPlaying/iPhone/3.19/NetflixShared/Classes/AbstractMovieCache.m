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

#import "AbstractMovieCache.h"

#import "Movie.h"
#import "Person.h"

@interface AbstractMovieCache()
@property (retain) NSMutableSet* updatedMovies;
@property (retain) NSMutableSet* updatedPeople;
@end


@implementation AbstractMovieCache

@synthesize updatedMovies;
@synthesize updatedPeople;

- (void) dealloc {
  self.updatedMovies = nil;
  self.updatedPeople = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.updatedMovies = [NSMutableSet set];
    self.updatedPeople = [NSMutableSet set];
  }

  return self;
}


- (void) didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  [self clearUpdatedMovies];
  [self clearUpdatedPeople];
}


- (void) clearUpdatedMovies {
  [dataGate lock];
  {
    [updatedMovies removeAllObjects];
  }
  [dataGate unlock];
}


- (void) clearUpdatedPeople {
  [dataGate lock];
  {
    [updatedPeople removeAllObjects];
  }
  [dataGate unlock];
}


- (BOOL) checkIdentifier:(NSString*) identifier set:(NSMutableSet*) set {
  BOOL result;
  [dataGate lock];
  {
    if (![set containsObject:identifier]) {
      [set addObject:identifier];
      result = NO;
    } else {
      result = YES;
    }
  }
  [dataGate unlock];
  return result;
}


- (BOOL) checkMovie:(Movie*) movie {
  return [self checkIdentifier:movie.identifier set:updatedMovies];
}


- (BOOL) checkPerson:(Person*) person {
  return [self checkIdentifier:person.identifier set:updatedPeople];
}


- (void) updateMovieDetails:(Movie*) movie
                      force:(BOOL) force AbstractMethod;


- (void) updatePersonDetails:(Person*) person
                      force:(BOOL) force AbstractMethod;


- (void) processMovie:(Movie*) movie force:(BOOL) force {
  if ([self checkMovie:movie]) {
    return;
  }

  [self updateMovieDetails:movie force:force];
}


- (void) processPerson:(Person*) person force:(BOOL) force {
  if ([self checkPerson:person]) {
    return;
  }

  [self updatePersonDetails:person force:force];
}

@end
