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

#import "GlobalActivityIndicator.h"
#import "NotificationCenter.h"

@interface NotificationCenter()
@property (retain) UIView* view;
@property (retain) UILabel* notificationLabel;
@property (retain) UILabel* blackLabel;
@end

@implementation NotificationCenter

@synthesize view;
@synthesize notificationLabel;
@synthesize blackLabel;

- (void) dealloc {
    self.view = nil;
    self.notificationLabel = nil;
    self.blackLabel = nil;

    [super dealloc];
}


- (void) addToView {
    [view addSubview:notificationLabel];
    [view addSubview:blackLabel];
}


- (id) initWithView:(UIView*) view_ {
    if (self = [super init]) {
        self.view = view_;

        self.notificationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 397, 320, 16)] autorelease];
        notificationLabel.font = [UIFont boldSystemFontOfSize:12];
        notificationLabel.textAlignment = UITextAlignmentCenter;
        notificationLabel.textColor = [UIColor whiteColor];
        notificationLabel.shadowColor = [UIColor darkGrayColor];
        notificationLabel.shadowOffset = CGSizeMake(0, 1);
        notificationLabel.alpha = 0;
        notificationLabel.backgroundColor = [UIColor colorWithRed:46.0/256.0 green:46.0/256.0 blue:46.0/256.0 alpha:1];
        notificationLabel.text = NSLocalizedString(@"Updating", nil);

        self.blackLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 397, 320, 1)] autorelease];
        blackLabel.backgroundColor = [UIColor blackColor];

        [GlobalActivityIndicator setTarget:self
                    startIndicatorSelector:@selector(showNotification)
                     stopIndicatorSelector:@selector(hideNotification)];

        [self addToView];
    }

    return self;
}


+ (NotificationCenter*) centerWithView:(UIView*) view {
    return [[[NotificationCenter alloc] initWithView:view] autorelease];
}


- (void) showNotification {
    [UIView beginAnimations:nil context:NULL];
    {
        notificationLabel.alpha = blackLabel.alpha = 1;
    }
    [UIView commitAnimations];
}


- (void) hideNotification {
    [UIView beginAnimations:nil context:NULL];
    {
        notificationLabel.alpha = blackLabel.alpha = 0;
    }
    [UIView commitAnimations];
}


- (void) willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation {
    notificationLabel.alpha = blackLabel.alpha = 0;
    [blackLabel removeFromSuperview];
    [notificationLabel removeFromSuperview];
}


- (void) didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(showLabels) withObject:nil afterDelay:1];
}


- (void) showLabels {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        [self addToView];
        [self showNotification];
    }
}

@end