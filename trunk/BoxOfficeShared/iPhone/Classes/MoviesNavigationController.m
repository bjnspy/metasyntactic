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

#import "MoviesNavigationController.h"

#import "AllMoviesViewController.h"
#import "BoxOfficeStockImages.h"
#import "Model.h"

@interface MoviesNavigationController()
@property (retain) AllMoviesViewController* allMoviesViewController;
@end


@implementation MoviesNavigationController

@synthesize allMoviesViewController;

- (void) dealloc {
  self.allMoviesViewController = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.title = LocalizedString(@"Movies", nil);
    self.tabBarItem.image = BoxOfficeStockImage(@"Movies.png");
  }

  return self;
}


- (void) loadView {
  [super loadView];

  if (allMoviesViewController == nil) {
    self.allMoviesViewController = [[[AllMoviesViewController alloc] init] autorelease];
    [self pushViewController:allMoviesViewController animated:NO];
  }
}


- (Movie*) movieForTitle:(NSString*) canonicalTitle {
  for (Movie* movie in [Model model].movies) {
    if ([movie.canonicalTitle isEqual:canonicalTitle]) {
      return movie;
    }
  }

  return nil;
}

@end
