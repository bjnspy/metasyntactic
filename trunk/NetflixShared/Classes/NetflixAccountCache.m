//
//  NetflixAccountCache.m
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 11/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetflixAccountCache.h"

#import "NetflixAccount.h"
#import "NetflixSharedApplication.h"

@interface NetflixAccountCache()
@property (retain) NSArray* accountsData;
@end

@implementation NetflixAccountCache

static NetflixAccountCache* cache;

static NSString* NETFLIX_ACCOUNTS               = @"netflixAccounts";
static NSString* NETFLIX_CURRENT_ACCOUNT_INDEX  = @"netflixCurrentAccountIndex";

+ (void) initialize {
  if (self == [NetflixAccountCache class]) {
    cache = [[NetflixAccountCache alloc] init];
  }
}


+ (NetflixAccountCache*) cache {
  return cache;
}

@synthesize accountsData;

- (void) dealloc {
  self.accountsData = nil;
  [super dealloc];
}


- (void) synchronize {
  [[NSUserDefaults standardUserDefaults] synchronize];
}


- (NSArray*) loadAccounts {
  NSArray* result = [[NSUserDefaults standardUserDefaults] objectForKey:NETFLIX_ACCOUNTS];
  if (result.count == 0) {
    return [NSArray array];
  }
  
  return [NetflixAccount decodeArray:result];
}


- (NSArray*) accounts {
  if (accountsData == nil) {
    self.accountsData = [self loadAccounts];
  }
  
  // return through pointer so that it is retain/autoreleased
  return self.accountsData;
}


- (void) setAccounts:(NSArray*) accounts {
  self.accountsData = accounts;
  [[NSUserDefaults standardUserDefaults] setObject:[NetflixAccount encodeArray:accounts]
                                            forKey:NETFLIX_ACCOUNTS];
  [self synchronize];
}


- (NetflixAccount*) currentAccount {
  NSArray* accounts = self.accounts;
  NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:NETFLIX_CURRENT_ACCOUNT_INDEX];
  if (index < 0 || index >= accounts.count) {
    return nil;
  }
  return [[[accounts objectAtIndex:index] retain] autorelease];
}


- (void) setCurrentAccount:(NetflixAccount*) account {
  if (account == nil) {
    return;
  }
  
  NSArray* accounts = self.accounts;
  NSInteger index = [accounts indexOfObject:account];
  if (index >= 0 && index < accounts.count) {
    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:NETFLIX_CURRENT_ACCOUNT_INDEX];
    [self synchronize];
  }

  [NetflixSharedApplication onCurrentNetflixAccountSet];
}


- (void) addAccount:(NetflixAccount*) account {
  if (account == nil) {
    return;
  }
  
  NSMutableArray* accounts = [NSMutableArray arrayWithArray:self.accounts];
  if (![accounts containsObject:account]) {
    [accounts addObject:account];
  }
  [self setAccounts:accounts];

  if (accounts.count == 1) {
    [self setCurrentAccount:account];
  }
}


- (void) removeAccount:(NetflixAccount*) account {
  if (account == nil) {
    return;
  }
  
  // Hold onto the account, even when it's deleted 
  [[account retain] autorelease];
  
  NetflixAccount* currentAccount = self.currentAccount;
  
  NSMutableArray* accounts = [NSMutableArray arrayWithArray:self.accounts];
  [accounts removeObject:account];
  [self setAccounts:accounts];
  
  if ([account isEqual:currentAccount]) {
    if (accounts.count > 0) {
      // they removed the active account.  switch the active account to the first account.
      [self setCurrentAccount:accounts.firstObject];
    }
  } else {
    // reset the current account unless the index changed
    [self setCurrentAccount:currentAccount];
  }
}

@end
