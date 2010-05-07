// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "NetflixLoginViewController.h"

#import "NetflixAccount.h"
#import "NetflixAccountCache.h"
#import "NetflixAuthentication.h"
#import "NetflixCache.h"
#import "NetflixLoginView.h"
#import "NetflixNetworking.h"
#import "NetflixSharedApplication.h"
#import "NetflixStockImages.h"
#import "NetflixUserCache.h"

@interface NetflixLoginViewController()
@property (retain) NetflixLoginView* loginView;
@property (retain) OAToken* authorizationToken;
@end


@implementation NetflixLoginViewController

@synthesize loginView;
@synthesize authorizationToken;

- (void) dealloc {
  self.loginView = nil;
  self.authorizationToken = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super initWithNibName:nil bundle:nil])) {
  }
  return self;
}


- (void) loadView {
  [super loadView];
  CGRect frame = self.view.frame;
  frame.origin.x = frame.origin.y = 0;
  self.loginView = [[[NetflixLoginView alloc] initWithFrame:frame viewController:self] autorelease];

  [self.view addSubview:loginView];
  self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view.autoresizesSubviews = YES;
  self.view.backgroundColor = [UIColor blackColor];

  [[OperationQueue operationQueue] performSelector:@selector(requestAuthorizationToken)
                                          onTarget:self
                                              gate:nil
                                          priority:Now];
}


- (void) rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
  [super rotateToInterfaceOrientation:interfaceOrientation duration:duration];

  [UIView beginAnimations:nil context:NULL];
  {
    [UIView setAnimationDuration:duration];
    [loginView layoutSubviews];
  }
  [UIView commitAnimations];
}


- (void) requestAuthorizationTokenWorker {
  OAConsumer* consumer = [OAConsumer consumerWithKey:[NetflixAuthentication key]
                                              secret:[NetflixAuthentication secret]];

  NSURL *url = [NSURL URLWithString:@"http://api.netflix.com/oauth/request_token"];

  OAMutableURLRequest *request = [OAMutableURLRequest requestWithURL:url
                                                            consumer:consumer
                                                               token:nil   // we don't have a Token yet
                                                               realm:nil
                                                           timestamp:[NetflixNetworking netflixTimestamp]];

  [request setHTTPMethod:@"POST"];

  [OADataFetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(requestAuthorizationToken:didFinishWithData:)
                      didFailSelector:@selector(requestAuthorizationToken:didFailWithError:)];
}


- (void) requestAuthorizationToken {
  NSString* notification = [LocalizedString(@"Requesting authorization", nil) lowercaseString];
  [NotificationCenter addNotification:notification];
  {
    [self requestAuthorizationTokenWorker];
  }
  [NotificationCenter removeNotification:notification];
}


- (void) requestAuthorizationToken:(OAServiceTicket*) ticket
                 didFinishWithData:(NSData*) data {
  if (ticket.succeeded) {
    NSString* responseBody = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
    OAToken* token = [OAToken tokenWithHTTPResponseBody:responseBody];
    [self performSelectorOnMainThread:@selector(reportAuthorizationToken:) withObject:token waitUntilDone:NO];
  } else {
    [self performSelectorOnMainThread:@selector(reportError:) withObject:nil waitUntilDone:NO];
  }
}


- (void) requestAuthorizationToken:(OAServiceTicket*) ticket
                  didFailWithError:(NSError*) error {
  [self performSelectorOnMainThread:@selector(reportError:)
                         withObject:error
                      waitUntilDone:NO];
}


- (void) reportError:(NSError*) error {
  NSAssert([NSThread isMainThread], nil);
  [[NetflixCache cache] setLastError:error];
  NSString* message =
  [NSString stringWithFormat:
   @"%@\n\n%@\n%@",
   LocalizedString(@"Error occurred talking to Netflix. Please try again later.", nil),
   error,
   error.userInfo];
  [AlertUtilities showOkAlert:message];

  [loginView showErrorOccurredMessage];
}


- (void) reportAuthorizationToken:(OAToken*) token {
  NSAssert([NSThread isMainThread], nil);
  self.authorizationToken = token;

  [loginView showOpenAndAuthorizeButton];
}


- (void) onContinueTapped:(id) sender {
  NSString* accessUrl =
  [NSString stringWithFormat:@"https://api-user.netflix.com/oauth/login?oauth_token=%@&oauth_consumer_key=%@&application_name=%@&oauth_callback=iphone://popviewcontroller",
   authorizationToken.key,
   [NetflixAuthentication key],
   [NetflixAuthentication applicationName]];

  [(id) self.navigationController pushBrowser:accessUrl showSafariButton:NO animated:YES];
  didShowBrowser = YES;
}


- (void) viewDidAppear:(BOOL) animated {
  if (!didShowBrowser) {
    return;
  }

  // we're coming back after showing the user the the access page
  [loginView showRequestingAccessMessage];

  [[OperationQueue operationQueue] performSelector:@selector(requestAccessToken)
                                          onTarget:self
                                              gate:nil
                                          priority:Now];
}


- (void) requestAccessTokenWorker {
  OAConsumer* consumer = [OAConsumer consumerWithKey:[NetflixAuthentication key]
                                              secret:[NetflixAuthentication secret]];

  NSURL *url = [NSURL URLWithString:@"http://api.netflix.com/oauth/access_token"];

  OAMutableURLRequest *request = [OAMutableURLRequest requestWithURL:url
                                                            consumer:consumer
                                                               token:authorizationToken
                                                               realm:nil
                                                           timestamp:[NetflixNetworking netflixTimestamp]]; // use the default method, HMAC-SHA1

  [request setHTTPMethod:@"POST"];

  [OADataFetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(requestAccessToken:didFinishWithData:)
                      didFailSelector:@selector(requestAccessToken:didFailWithError:)];
}


- (void) requestAccessToken {
  NSString* notification = [LocalizedString(@"Requesting access", nil) lowercaseString];
  [NotificationCenter addNotification:notification];
  {
    [self requestAccessTokenWorker];
  }
  [NotificationCenter removeNotification:notification];
}


- (void) requestAccessToken:(OAServiceTicket*) ticket
          didFinishWithData:(NSData*) data {
  if (ticket.succeeded) {
    NSString* responseBody = [[[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding] autorelease];
    OAToken* accessToken = [OAToken tokenWithHTTPResponseBody:responseBody];

    if (accessToken.key.length > 0 && accessToken.secret.length > 0) {
      NetflixAccount* account = [NetflixAccount accountWithKey:accessToken.key
                                                        secret:accessToken.secret
                                                        userId:[accessToken.fields objectForKey:@"user_id"]];

      // Download information about the user before we proceed.
      [[NetflixUserCache cache] downloadUserInformation:account];

      [self performSelectorOnMainThread:@selector(reportAccount:) withObject:account waitUntilDone:NO];
      return;
    }
  }

  [self performSelectorOnMainThread:@selector(reportError:) withObject:nil waitUntilDone:NO];
}


- (void) requestAccessToken:(OAServiceTicket*) ticket
           didFailWithError:(NSError*) error {
  [self performSelectorOnMainThread:@selector(reportError:) withObject:error waitUntilDone:NO];
}


- (void) reportAccount:(NetflixAccount*) account {
  NSAssert([NSThread isMainThread], nil);
  [loginView showSuccessMessage];

  [[NetflixAccountCache cache] addAccount:account];
}

@end
