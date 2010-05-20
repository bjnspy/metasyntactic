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

#import "FacebookAccount.h"

#import "FacebookAuthentication.h"
#import "MetasyntacticSharedApplication.h"
#import "NotificationCenter.h"

@interface FacebookAccount()
@property (retain) FBSession* session;
@property (retain) FBLoginButton* loginButton;
@property (copy) NSString* notificationString;
@end

@implementation FacebookAccount

@synthesize session;
@synthesize loginButton;
@synthesize notificationString;

- (void) dealloc {
  self.session = nil;
  self.loginButton = nil;
  self.notificationString = nil;

  [super dealloc];
}

setting_definition(FACEBOOK_ENABLED);

static FacebookAccount* account;

+ (void) initialize {
  if (self == [FacebookAccount class]) {
    account = [[FacebookAccount alloc] init];
  }
}


+ (FacebookAccount*) account {
  return account;
}


- (id) init {
  if ((self = [super init])) {
    self.notificationString = LocalizedString(@"Logging in to Facebook", nil);
  }

  return self;
}


- (void) login {
  self.session = nil;
  [FBSession setSession:nil];

  if (self.enabled) {
    //[NotificationCenter addNotification:notificationString];
    //self.isLoggingIn = YES;
    self.session =
    [FBSession sessionForApplication:[FacebookAuthentication apiKey]
                              secret:[FacebookAuthentication applicationSecret]
                            delegate:self];
    [FBSession setSession:session];

    self.loginButton = [[[FBLoginButton alloc] init] autorelease];
    //loginButton.style = FBLoginButtonStyleWide;
    loginButton.session = session;
  }
}


- (BOOL) enabled {
  return [[NSUserDefaults standardUserDefaults] boolForKey:FACEBOOK_ENABLED];
}


- (void) setEnabled:(BOOL) value {
  [[NSUserDefaults standardUserDefaults] setBool:value forKey:FACEBOOK_ENABLED];
  [[NSUserDefaults standardUserDefaults] synchronize];

  if (!value) {
    [session cancelLogin];
    [session logout];
  }

  [self login];
}


- (void)session:(FBSession*)session didLogin:(FBUID)uid {
}


- (BOOL) isLoggedIn {
  return session.isConnected;
}

@end
