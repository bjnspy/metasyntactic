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

#import "WebViewController.h"

#import "AbstractNavigationController.h"
#import "AlertUtilities.h"
#import "AppDelegate.h"
#import "Application.h"
#import "Model.h"
#import "NotificationCenter.h"
#import "ViewControllerUtilities.h"

#define NAVIGATE_BACK_ITEM 1
#define NAVIGATE_FORWARD_ITEM 3

@interface WebViewController()
@property (retain) UIWebView* webView_;
@property (retain) UIActivityIndicatorView* activityView_;
@property (retain) UILabel* label_;
@property (copy) NSString* address_;
@property BOOL showSafariButton_;
@property BOOL errorReported_;
@end


@implementation WebViewController

@synthesize webView_;
@synthesize activityView_;
@synthesize label_;
@synthesize address_;
@synthesize showSafariButton_;
@synthesize errorReported_;

property_wrapper(UIWebView*, webView, WebView);
property_wrapper(UIActivityIndicatorView*, activityView, ActivityView);
property_wrapper(UILabel*, label, Label);
property_wrapper(NSString*, address, Address);
property_wrapper(BOOL, showSafariButton, ShowSafariButton);
property_wrapper(BOOL, errorReported, ErrorReported);

- (void) dealloc {
    self.webView = nil;
    self.activityView = nil;
    self.label = nil;
    self.address = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                            address:(NSString*) address__
                   showSafariButton:(BOOL) showSafariButton__ {
    if (self = [super initWithNavigationController:navigationController_]) {
        self.address = address__;
        self.showSafariButton = showSafariButton__;
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (void) setupTitleView {
    self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [self.activityView startAnimating];

    CGRect frame = self.activityView.frame;
    frame.origin.y += 2;
    self.activityView.frame = frame;

    self.label = [ViewControllerUtilities viewControllerTitleLabel];
    self.label.text = NSLocalizedString(@"Loading", nil);
    [self.label sizeToFit];

    frame = self.label.frame;
    frame.origin.x += (self.activityView.frame.size.width + 5);
    self.label.frame = frame;

    frame = CGRectMake(0, 0, self.label.frame.size.width + self.activityView.frame.size.width + 5, self.label.frame.size.height);
    UIView* view = [[[UIView alloc] initWithFrame:frame] autorelease];
    [view addSubview:self.activityView];
    [view addSubview:self.label];

    self.navigationItem.titleView = view;
}


- (void) setupWebView {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.webView = [[[UIWebView alloc] initWithFrame:frame] autorelease];
    self.webView.delegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
}


- (void) setupToolbarItems {
    NSMutableArray* items = [NSMutableArray array];

    [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];

    UIBarButtonItem* navigateBackItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigate-Back.png"]
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:self
                                                                         action:@selector(onNavigateBackTapped:)] autorelease];
    [items addObject:navigateBackItem];

    [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];

    UIBarButtonItem* navigateForwardItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Navigate-Forward.png"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onNavigateForwardTapped:)] autorelease];
    [items addObject:navigateForwardItem];

    [items addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease]];

    [self setToolbarItems:items animated:YES];
}


- (void) loadView {
    [super loadView];

    [self setupWebView];
    [self.view addSubview:self.webView];

    if (self.showSafariButton) {
        self.navigationItem.rightBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Safari", nil)
                                          style:UIBarButtonItemStyleDone
                                         target:self
                                         action:@selector(open:)] autorelease];
    }

    [self setupTitleView];
    [self setupToolbarItems];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.address]]];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }

    return self.model.screenRotationEnabled;
}


- (void) open:(id) sender {
    NSString* url = self.webView.request.URL.absoluteString;
    if (url.length == 0) {
        url = self.address;
    }

    [Application openBrowser:url];
}


- (void) clearTitle {
    [UIView beginAnimations:nil context:NULL];
    {
        self.label.alpha = 0;
        self.activityView.alpha = 0;
    }
    [UIView commitAnimations];
}


- (void) updateToolBarItems {
    UIBarButtonItem* navigateBackItem = [self.abstractNavigationController.toolbar.items objectAtIndex:NAVIGATE_BACK_ITEM];
    UIBarButtonItem* navigateForwardItem = [self.abstractNavigationController.toolbar.items objectAtIndex:NAVIGATE_FORWARD_ITEM];

    navigateBackItem.enabled = self.webView.canGoBack;
    navigateForwardItem.enabled = self.webView.canGoForward;

    BOOL hidden = !navigateBackItem.enabled && !navigateForwardItem.enabled;

    [self.abstractNavigationController setToolbarHidden:hidden animated:YES];
}


- (void) onNavigateBackTapped:(id) sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }

    [self updateToolBarItems];
}


- (void) onNavigateForwardTapped:(id) sender {
    if (self.webView.canGoForward) {
        [self.webView goForward];
    }

    [self updateToolBarItems];
}


- (void) webViewDidFinishLoad:(UIWebView*) webView_ {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearTitle) object:nil];
    [self performSelector:@selector(clearTitle) withObject:nil afterDelay:4];

    [self updateToolBarItems];
}


- (void) webView:(UIWebView*) view didFailLoadWithError:(NSError*) error {
    [self webViewDidFinishLoad:view];

    if (self.errorReported) {
        return;
    }

    if (error.domain == NSURLErrorDomain && error.code == -1009) {
        NSString* title = NSLocalizedString(@"Cannot Open Page", nil);
        NSString* message =
        [NSString stringWithFormat:NSLocalizedString(@"%@ cannot open the page because it is not connected to the Internet.", nil), [Application name]];

        [AlertUtilities showOkAlert:message withTitle:title];
        self.errorReported = YES;
    }
}


- (void) webViewDidStartLoad:(UIWebView*) webView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearTitle) object:nil];

    self.label.alpha = 1;
    self.activityView.alpha = 1;

    [self updateToolBarItems];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.abstractNavigationController.toolbar.barStyle = UIBarStyleBlack;
    self.abstractNavigationController.toolbar.translucent = YES;
}


- (void) viewWillDisappear:(BOOL) animated {
    [super viewWillDisappear:animated];
    self.webView.delegate = nil;
    [self.abstractNavigationController setToolbarHidden:YES animated:NO];
}


- (BOOL)                 webView:(UIWebView*) webView
      shouldStartLoadWithRequest:(NSURLRequest*) request
                  navigationType:(UIWebViewNavigationType) navigationType {
    if ([[NSURLRequest class] respondsToSelector:@selector(setAllowsAnyHTTPSCertificate:forHost:)]) {
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:request.URL.host];
    }

    if ([request.URL.absoluteString hasPrefix:@"nowplaying://popviewcontroller"]) {
        [self.abstractNavigationController popViewControllerAnimated:YES];
        return NO;
    }

    return YES;
}

@end