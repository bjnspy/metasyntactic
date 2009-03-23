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

#import "AlertUtilities.h"
#import "AppDelegate.h"
#import "Application.h"
#import "GlobalActivityIndicator.h"
#import "NetflixNavigationController.h"
#import "Model.h"
#import "OperationQueue.h"

@interface NetflixLoginViewController()
@property (assign) NetflixNavigationController* navigationController;
@property (retain) UILabel* messageLabel;
@property (retain) UILabel* statusLabel;
@property (retain) UIActivityIndicatorView* activityIndicator;
@property (retain) UIButton* button;
@property (retain) OAToken* authorizationToken;
@end


@implementation NetflixLoginViewController

@synthesize navigationController;
@synthesize messageLabel;
@synthesize statusLabel;
@synthesize activityIndicator;
@synthesize button;
@synthesize authorizationToken;

- (void) dealloc {
    self.navigationController = nil;
    self.messageLabel = nil;
    self.statusLabel = nil;
    self.activityIndicator = nil;
    self.button = nil;
    self.authorizationToken = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(NetflixNavigationController*) navigationController_ {
    if (self = [super init]) {
        self.navigationController = navigationController_;
    }
    return self;
}


- (Model*) model {
    return navigationController.model;
}


- (Controller*) controller {
    return navigationController.controller;
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[AppDelegate globalActivityView]] autorelease];
}


- (void) setupMessage {
    self.messageLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.text =
    [NSString stringWithFormat:
     NSLocalizedString(@"%@ does not store your Netflix username and password.\n\nWe will open a Netflix webpage for you to authorize this app on your account.\n\nA Wi-fi connection is recommended the first time you use Netflix on %@.", nil), [Application name], [Application name]];

    messageLabel.numberOfLines = 0;
    messageLabel.textColor = [UIColor whiteColor];

    CGRect labelRect = CGRectMake(10, 10, self.view.frame.size.width - 20, self.view.frame.size.height);
    messageLabel.frame = labelRect;
    [messageLabel sizeToFit];

    [self.view addSubview:messageLabel];
}


- (void) setupStatus {
    self.statusLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.text = NSLocalizedString(@"Requesting authorization", nil);
    statusLabel.textColor = [UIColor whiteColor];
    [statusLabel sizeToFit];

    CGRect messageFrame = messageLabel.frame;
    CGRect statusFrame = statusLabel.frame;

    statusFrame.origin.x = messageFrame.origin.x + 30;
    statusFrame.origin.y = messageFrame.origin.y + messageFrame.size.height + 30;
    statusFrame.size.width = messageFrame.size.width - statusFrame.origin.x;
    statusLabel.frame = statusFrame;

    [self.view addSubview:statusLabel];
}


- (void) setupActivityIndicator {
    self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    CGRect frame = activityIndicator.frame;
    frame.origin.y = statusLabel.frame.origin.y;
    frame.origin.x = messageLabel.frame.origin.x + 5;
    activityIndicator.frame = frame;
    [activityIndicator startAnimating];

    [self.view addSubview:activityIndicator];
}


- (void) setupButton {
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:NSLocalizedString(@"Open and Authorize", nil) forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"Please wait...", nil) forState:UIControlStateDisabled];

    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    UIImage* image = [[UIImage imageNamed:@"BlackButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateDisabled];

    CGRect frame = self.view.frame;
    CGRect buttonFrame = button.frame;
    buttonFrame.origin.x = 10;
    buttonFrame.origin.y = 300;
    buttonFrame.size.width = frame.size.width - 20;
    buttonFrame.size.height = image.size.height;
    button.frame = buttonFrame;

    [button addTarget:self action:@selector(onContinueTapped:) forControlEvents:UIControlEventTouchUpInside];
    button.enabled = NO;

    [self.view addSubview:button];
}


- (void) loadView {
    [super loadView];

    self.view.backgroundColor = [UIColor blackColor];

    [self setupMessage];
    [self setupStatus];
    [self setupActivityIndicator];
    [self setupButton];

    [[AppDelegate operationQueue] performSelector:@selector(requestAuthorizationToken)
                                  onTarget:self
                                      gate:nil
                                   priority:High];
}


- (void) requestAuthorizationTokenWorker {
    OAConsumer* consumer = [OAConsumer consumerWithKey:[Application netflixKey]
                                                secret:[Application netflixSecret]];

    NSURL *url = [NSURL URLWithString:@"http://api.netflix.com/oauth/request_token"];

    OAMutableURLRequest *request = [OAMutableURLRequest requestWithURL:url
                                                              consumer:consumer
                                                                 token:nil   // we don't have a Token yet
                                                                 realm:nil];

    [request setHTTPMethod:@"POST"];

    [OADataFetcher fetchDataWithRequest:request
                               delegate:self
                      didFinishSelector:@selector(requestAuthorizationToken:didFinishWithData:)
                        didFailSelector:@selector(requestAuthorizationToken:didFailWithError:)];
}


- (void) requestAuthorizationToken {
    NSString* notification = NSLocalizedString(@"requesting authorization", nil);
    [AppDelegate addNotification:notification];
    {
        [self requestAuthorizationTokenWorker];
    }
    [AppDelegate removeNotification:notification];
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
    [AlertUtilities showOkAlert:NSLocalizedString(@"Error occurred talking to Netflix. Please try again later.", nil)];

    [activityIndicator stopAnimating];
    [button removeFromSuperview];
    statusLabel.text = NSLocalizedString(@"Error occurred", nil);
}


- (void) reportAuthorizationToken:(OAToken*) token {
    NSAssert([NSThread isMainThread], nil);
    self.authorizationToken = token;

    button.enabled = YES;
    [activityIndicator stopAnimating];
    statusLabel.text = @"";
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return NO;
}


- (void) onContinueTapped:(id) sender {
    NSString* accessUrl =
    [NSString stringWithFormat:@"https://api-user.netflix.com/oauth/login?oauth_token=%@&oauth_consumer_key=%@&application_name=%@&oauth_callback=nowplaying://popviewcontroller",
     authorizationToken.key,
     [Application netflixKey],
     [Application netflixApplicationName]];

    [navigationController pushBrowser:accessUrl showSafariButton:NO animated:YES];
    didShowBrowser = YES;
}


- (void) viewDidAppear:(BOOL) animated {
    if (!didShowBrowser) {
        return;
    }

    // we're coming back after showing the user the the access page

    [activityIndicator startAnimating];
    statusLabel.text = NSLocalizedString(@"Requesting access", nil);
    button.enabled = NO;

    [[AppDelegate operationQueue] performSelector:@selector(requestAccessToken)
                                         onTarget:self
                                             gate:nil
                                         priority:High];
}


- (void) requestAccessTokenWorker {
    OAConsumer* consumer = [OAConsumer consumerWithKey:[Application netflixKey]
                                                secret:[Application netflixSecret]];

    NSURL *url = [NSURL URLWithString:@"http://api.netflix.com/oauth/access_token"];

    OAMutableURLRequest *request = [OAMutableURLRequest requestWithURL:url
                                                              consumer:consumer
                                                                 token:authorizationToken
                                                                 realm:nil]; // use the default method, HMAC-SHA1

    [request setHTTPMethod:@"POST"];

    [OADataFetcher fetchDataWithRequest:request
                               delegate:self
                      didFinishSelector:@selector(requestAccessToken:didFinishWithData:)
                        didFailSelector:@selector(requestAccessToken:didFailWithError:)];
}


- (void) requestAccessToken {
    NSString* notification = NSLocalizedString(@"requesting access", nil);
    [AppDelegate addNotification:notification];
    {
        [self requestAccessTokenWorker];
    }
    [AppDelegate removeNotification:notification];
}


- (void) requestAccessToken:(OAServiceTicket*) ticket
          didFinishWithData:(NSData*) data {
    if (ticket.succeeded) {
        NSString* responseBody = [[[NSString alloc] initWithData:data
                                                        encoding:NSUTF8StringEncoding] autorelease];
        OAToken* accessToken = [OAToken tokenWithHTTPResponseBody:responseBody];
        [self performSelectorOnMainThread:@selector(reportAccessToken:) withObject:accessToken waitUntilDone:NO];
    } else {
        [self performSelectorOnMainThread:@selector(reportError:) withObject:nil waitUntilDone:NO];
    }
}


- (void) requestAccessToken:(OAServiceTicket*) ticket
           didFailWithError:(NSError*) error {
    [self performSelectorOnMainThread:@selector(reportError:) withObject:error waitUntilDone:NO];
}


- (void) reportAccessToken:(OAToken*) token {
    NSAssert([NSThread isMainThread], nil);
    [activityIndicator stopAnimating];
    [button removeFromSuperview];
    statusLabel.text = @"";
    messageLabel.text =
    [NSString stringWithFormat:
     NSLocalizedString(@"Success! %@ was granted access to your Netflix account. You can now add movies to your queue, see what's new and what's recommended for you, and much more!", nil), [Application name]];

    [self.controller setNetflixKey:token.key secret:token.secret userId:[token.fields objectForKey:@"user_id"]];
}

@end