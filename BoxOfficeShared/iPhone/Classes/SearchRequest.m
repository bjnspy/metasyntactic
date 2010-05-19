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
