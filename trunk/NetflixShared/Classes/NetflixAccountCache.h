//
//  NetflixAccountCache.h
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface NetflixAccountCache : AbstractCache {
@private
  NSArray* accountsData;
}

+ (NetflixAccountCache*) cache;

- (NSArray*) accounts;
- (NetflixAccount*) currentAccount;
- (void) addAccount:(NetflixAccount*) account;
- (void) removeAccount:(NetflixAccount*) account;
- (void) setCurrentAccount:(NetflixAccount*) account;

@end
