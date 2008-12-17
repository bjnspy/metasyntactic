//
//  NetflixModifyQueueDelegate.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@protocol NetflixModifyQueueDelegate

- (void) moveSucceededForMovie:(Movie*) movie inQueue:(Queue*) queue fromFeed:(Feed*) feed;
- (void) moveFailedWithError:(NSError*) error forMovie:(Movie*) movie inQueue:(Queue*) queue fromFeed:(Feed*) feed;

- (void) modifySucceededInQueue:(Queue*) queue fromFeed:(Feed*) feed;
- (void) modifyFailedWithError:(NSError*) error inQueue:(Queue*) queue fromFeed:(Feed*) feed;

@end