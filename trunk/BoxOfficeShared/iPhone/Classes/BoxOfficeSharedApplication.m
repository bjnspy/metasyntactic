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

#import "BoxOfficeSharedApplication.h"

#import "BoxOfficeSharedApplicationDelegate.h"

@implementation BoxOfficeSharedApplication

static id<BoxOfficeSharedApplicationDelegate> delegate = nil;

+ (void) setSharedApplicationDelegate:(id<BoxOfficeSharedApplicationDelegate>) delegate_ {
  [MetasyntacticSharedApplication setSharedApplicationDelegate:delegate_];
  [NetflixSharedApplication setSharedApplicationDelegate:delegate_];
  delegate = delegate_;
}


+ (void) resetTabs {
  [delegate resetTabs];
}


+ (BOOL) largePosterCacheAlwaysEnabled {
  return [delegate largePosterCacheAlwaysEnabled];
}


+ (BOOL) netflixCacheAlwaysEnabled {
  return [delegate netflixCacheAlwaysEnabled];
}


+ (BOOL) trailerCacheAlwaysEnabled {
  return [delegate trailerCacheAlwaysEnabled];
}

@end
