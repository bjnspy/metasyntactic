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

#import "LookupResult.h"

@interface LookupResult()
@property (retain) NSMutableArray* movies;
@property (retain) NSMutableArray* theaters;
@property (retain) NSMutableDictionary* performances;
@property (retain) NSMutableDictionary* synchronizationInformation;
@end


@implementation LookupResult

@synthesize movies;
@synthesize theaters;
@synthesize performances;
@synthesize synchronizationInformation;

- (void) dealloc {
  self.movies = nil;
  self.theaters = nil;
  self.performances = nil;
  self.synchronizationInformation = nil;

  [super dealloc];
}


- (id) initWithMovies:(NSMutableArray*) movies_
             theaters:(NSMutableArray*) theaters_
         performances:(NSMutableDictionary*) performances_
synchronizationInformation:(NSMutableDictionary*) synchronizationInformation_ {
  if ((self = [super init])) {
    self.movies = movies_;
    self.theaters = theaters_;
    self.performances = performances_;
    self.synchronizationInformation = synchronizationInformation_;
  }

  return self;
}


+ (LookupResult*) resultWithMovies:(NSMutableArray*) movies
                          theaters:(NSMutableArray*) theaters
                      performances:(NSMutableDictionary*) performances
        synchronizationInformation:(NSMutableDictionary*) synchronizationInformation {
  return [[[LookupResult alloc] initWithMovies:movies
                                      theaters:theaters
                                  performances:performances
                    synchronizationInformation:synchronizationInformation] autorelease];
}

@end
