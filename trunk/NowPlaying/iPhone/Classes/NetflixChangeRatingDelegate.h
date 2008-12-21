//
//  NetflixChangeRatingDelegate.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/20/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@protocol NetflixChangeRatingDelegate

- (void) changeSucceeded;
- (void) changeFailedWithError:(NSString*) error;

@end