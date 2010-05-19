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

#import "PocketFlicksNavigationController.h"

#import "Application.h"
#import "PocketFlicksViewController.h"

@interface PocketFlicksNavigationController()
@property (retain) PocketFlicksViewController* pocketFlicksViewController;
@end


@implementation PocketFlicksNavigationController

@synthesize pocketFlicksViewController;

- (void) dealloc {
  self.pocketFlicksViewController = nil;
  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    self.title = [Application name];
  }

  return self;
}


- (void) loadView {
  [super loadView];

  if (pocketFlicksViewController == nil) {
    self.pocketFlicksViewController = [[[PocketFlicksViewController alloc] init] autorelease];
    [self pushViewController:pocketFlicksViewController animated:NO];
  }
}

@end
