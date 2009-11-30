//
//  NetflixAccountCache.h
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 11/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NetflixUserCache : NSObject {

}

+ (NetflixUserCache*) cache;

- (NetflixUser*) downloadUserInformation:(NetflixAccount*) account;
- (NetflixUser*) userForAccount:(NetflixAccount*) account;

@end
