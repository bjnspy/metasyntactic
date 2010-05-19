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

#import "SearchResult.h"

@interface SearchResult()
@property (retain) NSArray* movies;
@property (retain) NSArray* theaters;
@property (retain) NSArray* upcomingMovies;
@property (retain) NSArray* dvds;
@property (retain) NSArray* bluray;
@property (retain) NSArray* people;
@end


@implementation SearchResult

@synthesize movies;
@synthesize theaters;
@synthesize upcomingMovies;
@synthesize dvds;
@synthesize bluray;
@synthesize people;

- (void) dealloc {
  self.movies = nil;
  self.theaters = nil;
  self.upcomingMovies = nil;
  self.dvds = nil;
  self.bluray = nil;
  self.people = nil;

  [super dealloc];
}


- (id) initWithId:(NSInteger) requestId_
            value:(NSString*) value_
           movies:(NSArray*) movies_
         theaters:(NSArray*) theaters_
   upcomingMovies:(NSArray*) upcomingMovies_
             dvds:(NSArray*) dvds_
           bluray:(NSArray*) bluray_
           people:(NSArray*) people_ {
  if ((self = [super initWithId:requestId_ value:value_])) {
    self.movies = movies_;
    self.theaters = theaters_;
    self.upcomingMovies = upcomingMovies_;
    self.dvds = dvds_;
    self.bluray = bluray_;
    self.people = people_;
  }

  return self;
}


+ (SearchResult*) resultWithId:(NSInteger) requestId
                         value:(NSString*) value
                        movies:(NSArray*) movies
                      theaters:(NSArray*) theaters
                upcomingMovies:(NSArray*) upcomingMovies
                          dvds:(NSArray*) dvds
                        bluray:(NSArray*) bluray
                        people:(NSArray*) people {
  return [[[SearchResult alloc] initWithId:requestId
                                     value:value
                                    movies:movies
                                  theaters:theaters
                            upcomingMovies:upcomingMovies
                                      dvds:dvds
                                    bluray:bluray
                                    people:people] autorelease];
}

@end
