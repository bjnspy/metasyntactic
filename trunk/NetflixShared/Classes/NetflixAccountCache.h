//
//  NetflixAccountCache.h
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NetflixAccountCache : NSObject {

}

+ (NetflixAccountCache*) cache;

- (NetflixUser*) downloadUserInformation:(NetflixAccount*) account;
- (NetflixUser*) userForAccount:(NetflixAccount*) account;

@end
