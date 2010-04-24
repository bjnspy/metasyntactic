//
//  NetflixLoginView.m
//  NetflixShared
//
//  Created by Cyrus Najmabadi on 4/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NetflixLoginView.h"

#import "NetflixStockImages.h"

@interface NetflixLoginView()
@property (retain) UILabel* messageLabel;
@property (retain) UILabel* statusLabel;
@property (retain) UIActivityIndicatorView* activityIndicator;
@property (retain) UIButton* button;
@end

@implementation NetflixLoginView

@synthesize messageLabel;
@synthesize statusLabel;
@synthesize activityIndicator;
@synthesize button;

- (void) dealloc {
  self.messageLabel = nil;
  self.statusLabel = nil;
  self.activityIndicator = nil;
  self.button = nil;
  
  [super dealloc];
}


- (void) setupMessageText {
  messageLabel.text =
  [NSString stringWithFormat:
   LocalizedString(@"%@ does not store your Netflix username and password.\n\nAn official Netflix.com webpage will be opened so you can authorize this app to access your account.\n\nA Wi-fi connection is recommended the first time you use Netflix.", @"The %@ will be replaced with the program name.  i.e. 'Now Playing'"), [AbstractApplication name]];
  
}


- (void) setupMessage {
  self.messageLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
  messageLabel.backgroundColor = [UIColor clearColor];
  
  [self setupMessageText];
  
  messageLabel.numberOfLines = 0;
  messageLabel.textColor = [UIColor whiteColor];
  
  [self addSubview:messageLabel];
}


- (void) setupStatus {
  self.statusLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
  statusLabel.backgroundColor = [UIColor clearColor];
  statusLabel.text = LocalizedString(@"Requesting authorization", nil);
  statusLabel.textColor = [UIColor whiteColor];
  [statusLabel sizeToFit];
  
  [self addSubview:statusLabel];
}


- (void) setupActivityIndicator {
  self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
  
  [activityIndicator startAnimating];
  
  [self addSubview:activityIndicator];
}


- (void) setupButton {
  self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setTitle:LocalizedString(@"Open and Authorize", nil) forState:UIControlStateNormal];
  [button setTitle:LocalizedString(@"Please wait", nil) forState:UIControlStateDisabled];
  
  [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  
  UIImage* image = [NetflixStockImage(@"BlackButton.png") stretchableImageWithLeftCapWidth:10 topCapHeight:0];
  [button setBackgroundImage:image forState:UIControlStateNormal];
  [button setBackgroundImage:image forState:UIControlStateDisabled];
  
  [button addTarget:controller action:@selector(onContinueTapped:) forControlEvents:UIControlEventTouchUpInside];
  button.enabled = NO;
  
  [self addSubview:button];
}


- (id) initWithFrame:(CGRect)frame viewController:(UIViewController*) _controller {
  if ((self = [super initWithFrame:frame])) {
    controller = _controller;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor blackColor];
    
    [self setupMessage];
    [self setupButton];
    [self setupActivityIndicator];
    [self setupStatus];
  }
  
  return self;
}


- (void) layoutSubviews {
  [super layoutSubviews];
  
  CGFloat width = self.frame.size.width;
  CGFloat height = self.frame.size.height;
  
  if (UIInterfaceOrientationIsLandscape(controller.interfaceOrientation)) {
    messageLabel.text = [messageLabel.text stringByReplacingOccurrencesOfString:@"\n\n" withString:@" "];
  }
  
  {
    CGRect labelRect = CGRectMake(10, 10, width - 20, height);
    messageLabel.frame = labelRect;
    [messageLabel sizeToFit];
  }
  
  {
    CGRect messageFrame = messageLabel.frame;
    CGRect statusFrame = statusLabel.frame;
    
    statusFrame.origin.x = messageFrame.origin.x + 30;
    statusFrame.origin.y = messageFrame.origin.y + messageFrame.size.height + 30;
    statusFrame.size.width = messageFrame.size.width - statusFrame.origin.x;
    statusLabel.frame = statusFrame;
  }
  
  {
    CGRect frame = activityIndicator.frame;
    frame.origin.y = statusLabel.frame.origin.y;
    frame.origin.x = messageLabel.frame.origin.x + 5;
    activityIndicator.frame = frame;
  }
  
  {
    UIImage* image = [NetflixStockImage(@"BlackButton.png") stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    CGRect buttonFrame = button.frame;
    buttonFrame.origin.x = 10;
    buttonFrame.origin.y = activityIndicator.frame.origin.y + 45;
    buttonFrame.size.width = width - 20;
    buttonFrame.size.height = image.size.height;
    button.frame = buttonFrame;
  }
}


- (void) showOpenAndAuthorizeButton {
  button.enabled = YES;
  [activityIndicator stopAnimating];
  statusLabel.text = @"";
}


- (void) showRequestingAccessMessage {
  [activityIndicator startAnimating];
  statusLabel.text = LocalizedString(@"Requesting access", nil);
  button.enabled = NO;
}


- (void) showErrorOccurredMessage {
  [activityIndicator stopAnimating];
  [button removeFromSuperview];
  statusLabel.text = LocalizedString(@"Error occurred", nil);
}


- (void) showSuccessMessage {
  [activityIndicator stopAnimating];
  [button removeFromSuperview];
  statusLabel.text = @"";
  messageLabel.text =
  [NSString stringWithFormat:
   LocalizedString(@"Success! %@ was granted access to your Netflix account. You can now add movies to your queue, see what's new and what's recommended for you, and much more!", nil), [AbstractApplication name]];  
}

@end
