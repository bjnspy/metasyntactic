//
//  NetflixAddMovieDelegate.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@protocol NetflixAddMovieDelegate

- (void) addSucceededForMovie:(Movie*) movie;
- (void) addFailedWithError:(NSString*) error;

@end