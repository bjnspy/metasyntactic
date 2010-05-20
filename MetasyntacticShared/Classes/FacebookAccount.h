//
//  FacebookAccount.h
//  MetasyntacticShared
//
//  Created by Cyrus Najmabadi on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface FacebookAccount : NSObject<FBSessionDelegate> {
@private
  FBSession* session;
  FBLoginButton* loginButton;
  NSString* notificationString;
}

@property (readonly, retain) FBSession* session;
@property (readonly, retain) FBLoginButton* loginButton;

- (BOOL) isLoggedIn;

+ (FacebookAccount*) account;

- (BOOL) enabled;
- (void) setEnabled:(BOOL) value;

- (void) login;

@end
