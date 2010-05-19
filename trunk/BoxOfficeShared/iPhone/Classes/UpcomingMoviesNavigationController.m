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

#import "UpcomingMoviesNavigationController.h"

#import "BoxOfficeStockImages.h"
#import "UpcomingCache.h"
#import "UpcomingMoviesViewController.h"

@interface UpcomingMoviesNavigationController()
@property (retain) UpcomingMoviesViewController* upcomingMoviesViewController;
@end


@implementation UpcomingMoviesNavigationController

@synthesize upcomingMoviesViewController;

- (void) dealloc {
  self.upcomingMoviesViewController = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.title = LocalizedString(@"Upcoming", nil);
    self.tabBarItem.image = BoxOfficeStockImage(@"Upcoming.png");
  }

  return self;
}


- (void) loadView {
  [super loadView];

  if (upcomingMoviesViewController == nil) {
    self.upcomingMoviesViewController = [[[UpcomingMoviesViewController alloc] init] autorelease];
    [self pushViewController:upcomingMoviesViewController animated:NO];
  }
}


- (Movie*) movieForTitle:(NSString*) canonicalTitle {
  for (Movie* movie in [[UpcomingCache cache] movies]) {
    if ([movie.canonicalTitle isEqual:canonicalTitle]) {
      return movie;
    }
  }

  return [super movieForTitle:canonicalTitle];
}

@end
