//
//  WebViewController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

#import "Application.h"
#import "ViewControllerUtilities.h"

#define NAVIGATE_BACK_ITEM 1
#define NAVIGATE_FORWARD_ITEM 3

@interface WebViewController()
    @property (assign) AbstractNavigationController* navigationController;
    @property (retain) UIWebView* webView;
    @property (retain) UIToolbar* toolbar;
    @property (retain) UIActivityIndicatorView* activityView;
    @property (retain) UILabel* label;
    @property (copy) NSString* address;
@end


@implementation WebViewController

@synthesize navigationController;
@synthesize webView;
@synthesize toolbar;
@synthesize activityView;
@synthesize label;
@synthesize address;

- (void) dealloc {
    self.navigationController = nil;
    self.address = nil;

    self.webView = nil;
    self.toolbar = nil;
    self.activityView = nil;
    self.label = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_
                            address:(NSString*) address_
                   showSafariButton:(BOOL) showSafariButton_ {
    if (self = [super init]) {
        self.navigationController = navigationController_;
        self.address = address_;
        showSafariButton = showSafariButton_;
    }

    return self;
}


- (void) setupTitleView {
    self.activityView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [activityView startAnimating];

    CGRect frame = activityView.frame;
    frame.origin.y += 2;
    activityView.frame = frame;

    self.label = [ViewControllerUtilities viewControllerTitleLabel];
    label.text = NSLocalizedString(@"Loading", nil);
    [label sizeToFit];

    frame = label.frame;
    frame.origin.x += (activityView.frame.size.width + 5);
    label.frame = frame;

    frame = CGRectMake(0, 0, label.frame.size.width + activityView.frame.size.width + 5, label.frame.size.height);
    UIView* view = [[[UIView alloc] initWithFrame:frame] autorelease];
    [view addSubview:activityView];
    [view addSubview:label];

    self.navigationItem.titleView = view;
}


- (void) setupWebView {
    CGRect webframe = self.view.frame;
    webframe.origin.x = 0;
    webframe.origin.y = 0;

    CGRect toolbarFrame;
    CGRectDivide(webframe, &toolbarFrame, &webframe, toolbar.frame.size.height, CGRectMaxYEdge);

    self.webView = [[[UIWebView alloc] initWithFrame:webframe] autorelease];
    webView.delegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
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

    [toolbar setItems:items animated:YES];
}


- (void) setupToolbar {
    CGRect webframe = self.view.frame;
    webframe.origin.x = 0;
    webframe.origin.y = 0;

    CGRect toolbarFrame;
    CGRectDivide(webframe, &toolbarFrame, &webframe, 42, CGRectMaxYEdge);

    self.toolbar = [[[UIToolbar alloc] initWithFrame:toolbarFrame] autorelease];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;

    [self setupToolbarItems];
}


- (void) loadView {
    [super loadView];

    if (showSafariButton) {
        self.navigationItem.rightBarButtonItem = 
        [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Safari", nil)
                                          style:UIBarButtonItemStyleDone
                                         target:self
                                         action:@selector(open:)] autorelease];
    }

    [self setupTitleView];
    [self setupToolbar];
    [self setupWebView];

    [self.view addSubview:toolbar];
    [self.view addSubview:webView];

    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:address]]];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


- (void) open:(id) sender {
    NSString* url = webView.request.URL.absoluteString;
    if (url.length == 0) {
        url = address;
    }

    [Application openBrowser:url];
}


- (void) clearTitle {
    [UIView beginAnimations:nil context:NULL];
    {
        label.alpha = 0;
        activityView.alpha = 0;
    }
    [UIView commitAnimations];
}


- (void) updateToolBarItems {
    UIBarButtonItem* navigateBackItem = [toolbar.items objectAtIndex:NAVIGATE_BACK_ITEM];
    UIBarButtonItem* navigateForwardItem = [toolbar.items objectAtIndex:NAVIGATE_FORWARD_ITEM];

    navigateBackItem.enabled = webView.canGoBack;
    navigateForwardItem.enabled = webView.canGoForward;
}


- (void) onNavigateBackTapped:(id) sender {
    if (webView.canGoBack) {
        [webView goBack];
    }

    [self updateToolBarItems];
}


- (void) onNavigateForwardTapped:(id) sender {
    if (webView.canGoForward) {
        [webView goForward];
    }

    [self updateToolBarItems];
}


- (void) webViewDidFinishLoad:(UIWebView*) webView_ {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearTitle) object:nil];
    [self performSelector:@selector(clearTitle) withObject:nil afterDelay:4];

    [self updateToolBarItems];
}


- (void) webView:(UIWebView*) webView_ didFailLoadWithError:(NSError*) error {
    [self webViewDidFinishLoad:webView_];
}


- (void) webViewDidStartLoad:(UIWebView*) webView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(clearTitle) object:nil];

    label.alpha = 1;
    activityView.alpha = 1;

    [self updateToolBarItems];
}


- (void) viewWillDisappear:(BOOL) animated {
    webView.delegate = nil;
}


- (BOOL)                 webView:(UIWebView*) webView
      shouldStartLoadWithRequest:(NSURLRequest*) request
                  navigationType:(UIWebViewNavigationType) navigationType {
    if ([[NSURLRequest class] respondsToSelector:@selector(setAllowsAnyHTTPSCertificate:forHost:)]) {
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:request.URL.host];
    }

    return YES;
}


@end
