// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "AbstractTwitterAccount.h"

#import "AlertUtilities.h"
#import "MetasyntacticSharedApplication.h"
#import "NotificationCenter.h"

@interface AbstractTwitterAccount()
@property (retain) MGTwitterEngine* engine;
@property (copy) NSString* lastCheckCredentialsIdentifier;
@property (retain) NSMutableDictionary* requestsInProgress;
@end


@implementation AbstractTwitterAccount

@synthesize engine;
@synthesize lastCheckCredentialsIdentifier;
@synthesize requestsInProgress;

- (void) dealloc {
  self.engine = nil;
  self.lastCheckCredentialsIdentifier = nil;
  self.requestsInProgress = nil;
  [super dealloc];
}

setting_definition(TWITTER_ENABLED);
setting_definition(TWITTER_USERNAME);
setting_definition(TWITTER_PASSWORD);

- (id) init {
  if ((self = [super init])) {
    self.engine = [MGTwitterEngine twitterEngineWithDelegate:self];
    self.requestsInProgress = [NSMutableDictionary dictionary];
  }

  return self;
}


- (BOOL) twitterReady {
  return self.enabled && self.username.length > 0 && self.password.length > 0;
}


- (void) checkCredentials {
  if (!self.twitterReady) {
    return;
  }

  self.lastCheckCredentialsIdentifier = [engine checkUserCredentials];

  NSString* notification = LocalizedString(@"Logging in to Twitter", nil);
  [requestsInProgress setObject:notification forKey:lastCheckCredentialsIdentifier];

  [NotificationCenter addNotification:notification];
}


- (void) login {
  [engine closeAllConnections];

  BOOL credentialsChanged = ![self.username isEqual:engine.username] || ![self.password isEqual:engine.password];
  [engine setUsername:self.username password:self.password];

  if (credentialsChanged) {
    [self checkCredentials];
  }
}


- (BOOL) enabled {
  return [[NSUserDefaults standardUserDefaults] boolForKey:TWITTER_ENABLED];
}


- (void) setEnabled:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:value forKey:TWITTER_ENABLED];
  [[NSUserDefaults standardUserDefaults] synchronize];

  if (!value) {
    [self setUserName:@"" password:@""];
  }

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


- (NSString*) defaultUpdateSuffix {
  return @"";
}


- (void) sendUpdate:(NSString*) message {
  if (!self.twitterReady) {
    return;
  }

#define MAX_MESSAGE_LENGTH 140

  NSString* suffix = self.defaultUpdateSuffix;

  if (message.length + suffix.length > MAX_MESSAGE_LENGTH) {
    message = [message substringToIndex:MAX_MESSAGE_LENGTH - suffix.length];
  }
  message = [NSString stringWithFormat:@"%@%@", message, suffix];

  NSString* notification = LocalizedString(@"Tweeting", nil);
  [NotificationCenter addNotification:notification];

  NSString* key = [engine sendUpdate:message];

  [requestsInProgress setObject:notification forKey:key];
}


- (void) handleFinishedRequest:(NSString*) connectionIdentifier {
  NSString* message = [requestsInProgress objectForKey:connectionIdentifier];
  [NotificationCenter removeNotification:message];
  [requestsInProgress removeObjectForKey:connectionIdentifier];
}


- (void) requestSucceeded:(NSString*) connectionIdentifier {
  [self handleFinishedRequest:connectionIdentifier];
}


- (void) requestFailed:(NSString*) connectionIdentifier withError:(NSError*) error {
  [self handleFinishedRequest:connectionIdentifier];

  if ([lastCheckCredentialsIdentifier isEqual:connectionIdentifier]) {
    if (error.code == 401) {
      [AlertUtilities showOkAlert:LocalizedString(@"Incorrect Twitter user name or password.", nil)];
    }
  }
}

@end
