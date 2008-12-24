//
//  NetflixMoveMovieDelegate.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@protocol NetflixMoveMovieDelegate

- (void) moveSucceededForMovie:(Movie*) movie;
- (void) moveFailedWithError:(NSString*) error;

@end