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

#import "NotificationCenter.h"

#import "GlobalActivityIndicator.h"
#import "Pulser.h"

@interface NotificationCenter()
@property (retain) UIView* view_;
@property (retain) UILabel* notificationLabel_;
@property (retain) UILabel* blackLabel_;
@property (retain) NSMutableArray* notifications_;
@property (retain) Pulser* pulser_;
@property NSInteger disabledCount_;
@end

@implementation NotificationCenter

@synthesize view_;
@synthesize notificationLabel_;
@synthesize blackLabel_;
@synthesize notifications_;
@synthesize pulser_;
@synthesize disabledCount_;

property_wrapper(UIView*, view, View);
property_wrapper(UILabel*, notificationLabel, NotificationLabel);
property_wrapper(UILabel*, blackLabel, BlackLabel);
property_wrapper(NSMutableArray*, notifications, Notifications);
property_wrapper(Pulser*, pulser, Pulser);
property_wrapper(NSInteger, disabledCount, DisabledCount);

- (void) dealloc {
    self.view = nil;
    self.notificationLabel = nil;
    self.blackLabel = nil;
    self.notifications = nil;
    self.pulser = nil;
    self.disabledCount = 0;

    [super dealloc];
}


- (void) addToView {
    [self.view addSubview:self.notificationLabel];
    [self.view addSubview:self.blackLabel];
}


- (id) initWithView:(UIView*) view__ {
    if (self = [super init]) {
        self.view = view__;

        self.notifications = [NSMutableArray array];

        self.notificationLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 417, 320, 16)] autorelease];
        self.notificationLabel.font = [UIFont boldSystemFontOfSize:12];
        self.notificationLabel.textAlignment = UITextAlignmentCenter;
        self.notificationLabel.textColor = [UIColor whiteColor];
        self.notificationLabel.shadowColor = [UIColor darkGrayColor];
        self.notificationLabel.shadowOffset = CGSizeMake(0, 1);
        self.notificationLabel.alpha = 0;
        self.notificationLabel.backgroundColor = [UIColor colorWithRed:46.0/256.0 green:46.0/256.0 blue:46.0/256.0 alpha:1];
        self.notificationLabel.text = NSLocalizedString(@"Updating", nil);

        self.blackLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 417, 320, 1)] autorelease];
        self.blackLabel.backgroundColor = [UIColor blackColor];

        self.pulser = [Pulser pulserWithTarget:self
                                        action:@selector(update)
                                 pulseInterval:1];
/*
        [GlobalActivityIndicator setTarget:self
                    startIndicatorSelector:@selector(showNotification)
                     stopIndicatorSelector:@selector(hideNotification)];
 */

        [self addToView];
    }

    return self;
}


+ (NotificationCenter*) centerWithView:(UIView*) view {
    return [[[NotificationCenter alloc] initWithView:view] autorelease];
}


- (void) showNotification {
    if (self.disabledCount == 0 && [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
        [UIView beginAnimations:nil context:NULL];
        {
            self.notificationLabel.alpha = self.blackLabel.alpha = 1;
        }
        [UIView commitAnimations];
    }
}


- (void) hideNotification {
    [UIView beginAnimations:nil context:NULL];
    {
        self.notificationLabel.alpha = self.blackLabel.alpha = 0;
    }
    [UIView commitAnimations];
}


- (NSString*) computeText {
    NSMutableArray* array = [NSMutableArray array];
    for (NSString* notification in self.notifications) {
        if (![array containsObject:notification]) {
            [array addObject:notification];
        }
    }

    if (array.count == 0) {
        return nil;
    }

    return [NSString stringWithFormat:NSLocalizedString(@"Updating: %@", nil), [array componentsJoinedByString:@", "]];
}


- (void) update {
    self.notificationLabel.text = [self computeText];
    if (self.notifications.count > 0) {
        [self showNotification];
    } else {
        [self hideNotification];
    }
}


- (void) willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation {
    self.notificationLabel.alpha = self.blackLabel.alpha = 0;
}


- (void) didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(update)
               withObject:nil
               afterDelay:1];
}

- (void) addNotification:(NSString*) notification {
    [self addNotifications:[NSArray arrayWithObject:notification]];
}


- (void) removeNotification:(NSString*) notification {
    [self removeNotifications:[NSArray arrayWithObject:notification]];
}


- (void) addNotifications:(NSArray*) array {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(addNotifications:) withObject:array waitUntilDone:NO];
        return;
    }

    [self.notifications addObjectsFromArray:array];
    [self.pulser tryPulse];
}


- (void) removeNotifications:(NSArray*) array {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(removeNotifications:) withObject:array waitUntilDone:NO];
        return;
    }

    [self.notifications removeObjectsInArray:array];
    [self.pulser tryPulse];
}


- (void) disableNotifications {
    self.disabledCount++;
    [self hideNotification];
    [self.pulser tryPulse];
}


- (void) enableNotifications {
    self.disabledCount--;
    [self.pulser tryPulse];
}

@end