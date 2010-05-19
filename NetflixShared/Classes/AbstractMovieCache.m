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

  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  {
    [self updateMovieDetails:movie force:force];
  }
  [pool release];
}


- (void) processPerson:(Person*) person force:(BOOL) force {
  if ([self checkPerson:person]) {
    return;
  }

  [self updatePersonDetails:person force:force];
}

@end
