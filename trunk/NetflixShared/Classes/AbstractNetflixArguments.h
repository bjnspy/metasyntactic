//
//  AbstractNetscapeArguments.h
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 10/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@interface AbstractNetflixArguments : NSObject {
@protected
  NetflixAccount* account;
}

@property (readonly, retain) NetflixAccount* account;

/* @protected */
- (id) initWithAccount:(NetflixAccount*) account;

@end
