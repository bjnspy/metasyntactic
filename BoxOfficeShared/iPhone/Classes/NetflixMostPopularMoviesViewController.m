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

#import "NetflixMostPopularMoviesViewController.h"

@interface NetflixMostPopularMoviesViewController()
@property (copy) NSString* category;
@end


@implementation NetflixMostPopularMoviesViewController

@synthesize category;

- (void) dealloc {
  self.category = nil;

  [super dealloc];
}


- (id) initWithCategory:(NSString*) category_ {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.category = category_;
    self.title = category_;
  }

  return self;
}


- (NSArray*) determineMovies {
  return [[NetflixRssCache cache] moviesForRSSTitle:category];
}

@end
