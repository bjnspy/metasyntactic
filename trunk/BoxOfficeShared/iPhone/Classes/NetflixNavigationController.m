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

#import "NetflixNavigationController.h"

#import "BoxOfficeStockImages.h"
#import "NetflixViewController.h"

@interface NetflixNavigationController()
@property (retain) NetflixViewController* netflixViewController;
@end


@implementation NetflixNavigationController

@synthesize netflixViewController;

- (void) dealloc {
  self.netflixViewController = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.tabBarItem.image = BoxOfficeStockImage(@"Netflix.png");
    self.title = LocalizedString(@"Netflix", nil);
  }

  return self;
}


- (void) loadView {
  [super loadView];

  if (netflixViewController == nil) {
    self.netflixViewController = [[[NetflixViewController alloc] init] autorelease];
    [self pushViewController:netflixViewController animated:NO];
  }
}

@end
