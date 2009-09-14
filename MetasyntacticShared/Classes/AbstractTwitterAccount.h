//
//  TwitterAccount.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 9/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AbstractTwitterAccount : NSObject<MGTwitterEngineDelegate> {
@private
  MGTwitterEngine* engine;
  NSError* lastError;
  NSString* lastCheckCredentialsIdentifier;
}

- (void) login;

- (BOOL) enabled;
- (void) setEnabled:(BOOL) enabled;

- (NSString*) username;
- (NSString*) password;

- (void) setUserName:(NSString*) username password:(NSString*) password;

- (void) sendUpdate:(NSString*) message;

@end
