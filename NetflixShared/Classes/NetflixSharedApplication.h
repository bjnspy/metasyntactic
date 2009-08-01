//
//  NetflixSharedApplication.h
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NetflixSharedApplication : NSObject {
  
}

+ (void) setSharedApplicationDelegate:(id<NetflixSharedApplicationDelegate>) delegate;

+ (BOOL) netflixEnabled;
+ (BOOL) netflixNotificationsEnabled;
+ (NetflixAccount*) currentNetflixAccount;

+ (void) reportNetflixMovies:(NSArray*) movies;
+ (void) reportNetflixMovie:(Movie*) movie;

@end
