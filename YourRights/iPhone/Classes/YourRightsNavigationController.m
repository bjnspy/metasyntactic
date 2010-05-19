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

#import "YourRightsNavigationController.h"

#import "AppDelegate.h"
#import "SectionViewController.h"

@interface YourRightsNavigationController()
@end

@implementation YourRightsNavigationController

- (id) init {
  if ((self = [super init])) {
    SectionViewController* controller = [[[SectionViewController alloc] init] autorelease];
    [self pushViewController:controller animated:NO];
  }

  return self;
}

@end
