//
//  TwitterAccount.m
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 9/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractTwitterAccount.h"

#import "AlertUtilities.h"

@interface AbstractTwitterAccount()
@property (retain) MGTwitterEngine* engine;
@property (retain) NSError* lastError;
@property (copy) NSString* lastCheckCredentialsIdentifier;
@end


@implementation AbstractTwitterAccount

@synthesize engine;
@synthesize lastError;
@synthesize lastCheckCredentialsIdentifier;

- (void) dealloc {
  self.engine = nil;
  self.lastError = nil;
  self.lastCheckCredentialsIdentifier = nil;
  [super dealloc];
}

setting_definition(TWITTER_ENABLED);
setting_definition(TWITTER_USERNAME);
setting_definition(TWITTER_PASSWORD);

- (id) init {
  if ((self = [super init])) {
    self.engine = [MGTwitterEngine twitterEngineWithDelegate:self];
  }
  
  return self;
}


- (void) login {
  [engine closeAllConnections];
  [engine setUsername:self.username password:self.password];
  
  if (self.username.length > 0 && self.password.length > 0) {
    self.lastCheckCredentialsIdentifier = [engine checkUserCredentials];
  }
}


- (BOOL) enabled {
  return [[NSUserDefaults standardUserDefaults] boolForKey:TWITTER_ENABLED];
}


- (void) setEnabled:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:value forKey:TWITTER_ENABLED];
  [[NSUserDefaults standardUserDefaults] synchronize];

  [self login];
}


- (NSString*) username {
  return [[NSUserDefaults standardUserDefaults] objectForKey:TWITTER_USERNAME];
}


- (NSString*) password {
  return [[NSUserDefaults standardUserDefaults] objectForKey:TWITTER_PASSWORD];
}


- (void) setUserName:(NSString*) username password:(NSString*) password {
  [[NSUserDefaults standardUserDefaults] setObject:username forKey:TWITTER_USERNAME];
  [[NSUserDefaults standardUserDefaults] setObject:password forKey:TWITTER_PASSWORD];
  [[NSUserDefaults standardUserDefaults] synchronize];

  [self login];
}


- (BOOL) twitterReady {
  return self.enabled && self.username.length > 0 && self.password.length > 0;
}


- (void) sendUpdate:(NSString*) message {
  if (!self.twitterReady) {
    return;
  }

  NSString* jmpLink = @" http://j.mp/4rWgqy";
  
  if (message.length + jmpLink.length > 140) {
    message = [message substringToIndex:140 - jmpLink.length];
  }
  message = [NSString stringWithFormat:@"%@%@", message, jmpLink];
  
  [engine sendUpdate:message];
}


- (void) requestSucceeded:(NSString*) connectionIdentifier {
}


- (void) requestFailed:(NSString*) connectionIdentifier withError:(NSError*) error {
  if ([lastCheckCredentialsIdentifier isEqual:connectionIdentifier]) {
    if (error.code == 401) {
      [AlertUtilities showOkAlert:NSLocalizedString(@"Incorrect Twitter user name or password.", nil)];
    }
  }
}

@end
