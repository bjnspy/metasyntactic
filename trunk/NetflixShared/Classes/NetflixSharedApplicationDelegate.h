//
//  NetflixSharedApplicationDelegate.h
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 8/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@protocol NetflixSharedApplicationDelegate<MetasyntacticSharedApplicationDelegate>
- (BOOL) netflixEnabled;
- (BOOL) netflixNotificationsEnabled;
- (NetflixAccount*) currentNetflixAccount;
- (void) reportNetflixMovies:(NSArray*) movies;
- (void) reportNetflixMovie:(Movie*) movie;
@end
