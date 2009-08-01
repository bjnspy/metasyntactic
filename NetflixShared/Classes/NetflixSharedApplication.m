//
//  NetflixSharedApplication.m
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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


+ (NetflixAccount*) currentNetflixAccount {
  return [delegate currentNetflixAccount];
}


+ (void) reportNetflixMovies:(NSArray*) movies {
  [delegate reportNetflixMovies:movies];
}


+ (void) reportNetflixMovie:(Movie*) movie {
  [delegate reportNetflixMovie:movie];
}

@end
