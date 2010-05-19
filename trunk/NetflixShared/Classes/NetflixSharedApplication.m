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

#import "NetflixSharedApplication.h"

#import "NetflixSharedApplicationDelegate.h"

@implementation NetflixSharedApplication

static id<NetflixSharedApplicationDelegate> delegate = nil;

+ (void) setSharedApplicationDelegate:(id<NetflixSharedApplicationDelegate>) delegate_ {
  delegate = delegate_;
}


+ (BOOL) netflixEnabled {
  return [delegate netflixEnabled];
}


+ (BOOL) netflixNotificationsEnabled {
  return [delegate netflixNotificationsEnabled];
}


+ (void) onCurrentNetflixAccountSet {
  [delegate onCurrentNetflixAccountSet];
}


+ (void) reportNetflixMovies:(NSArray*) movies {
  [delegate reportNetflixMovies:movies];
}


+ (void) reportNetflixMovie:(Movie*) movie {
  [delegate reportNetflixMovie:movie];
}

@end
