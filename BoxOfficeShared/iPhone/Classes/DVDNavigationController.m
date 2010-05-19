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

#import "DVDNavigationController.h"

#import "BoxOfficeStockImages.h"
#import "DVDCache.h"
#import "DVDViewController.h"
#import "Model.h"

@interface DVDNavigationController()
@property (retain) DVDViewController* dvdViewController;
@end


@implementation DVDNavigationController

@synthesize dvdViewController;

- (void) dealloc {
  self.dvdViewController = nil;

  [super dealloc];
}


- (void) setupTitle {
  if ([Model model].dvdMoviesShowOnlyBluray) {
    self.title = LocalizedString(@"Blu-ray", nil);
  } else {
    self.title = LocalizedString(@"DVD", nil);
  }
}


- (id) init {
  if ((self = [super init])) {
    self.tabBarItem.image = BoxOfficeStockImage(@"DVD.png");
    [self setupTitle];
  }

  return self;
}


- (void) loadView {
  [super loadView];

  if (dvdViewController == nil) {
    self.dvdViewController = [[[DVDViewController alloc] init] autorelease];
    [self pushViewController:dvdViewController animated:NO];
  }
}


- (Movie*) movieForTitle:(NSString*) canonicalTitle {
  for (Movie* movie in [[DVDCache cache] movies]) {
    if ([movie.canonicalTitle isEqual:canonicalTitle]) {
      return movie;
    }
  }

  return [super movieForTitle:canonicalTitle];
}


- (void) majorRefresh {
  [self setupTitle];
  [super majorRefresh];
}

@end
