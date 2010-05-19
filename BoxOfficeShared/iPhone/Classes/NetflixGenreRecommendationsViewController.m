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

#import "NetflixGenreRecommendationsViewController.h"

@interface NetflixGenreRecommendationsViewController()
@property (retain) NetflixAccount* account;
@property (copy) NSString* genre;
@end


@implementation NetflixGenreRecommendationsViewController

@synthesize account;
@synthesize genre;

- (void) dealloc {
  self.account = nil;
  self.genre = nil;

  [super dealloc];
}


- (id) initWithGenre:(NSString*) genre_ {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.genre = genre_;
    self.title = genre_;
  }

  return self;
}


- (NSArray*) determineMovies {
  self.account = [[NetflixAccountCache cache] currentAccount];
  Queue* queue = [[NetflixFeedCache cache] queueForKey:[NetflixConstants recommendationKey] account:account];

  NSMutableArray* array = [NSMutableArray array];

  for (Movie* movie in queue.movies) {
    NSArray* genres = movie.genres;
    if (genres.count > 0 && [genre isEqual:genres.firstObject]) {
      [array addObject:movie];
    }
  }

  return array;
}

@end
