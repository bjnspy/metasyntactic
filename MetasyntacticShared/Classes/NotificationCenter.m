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

#import "Pulser.h"
#import "MetasyntacticSharedApplication.h"

@interface NotificationCenter()
@property (retain) UIViewController* viewController;
@property (retain) UILabel* notificationLabel;
@property (retain) UILabel* blackLabel;
@property (retain) NSMutableArray* notifications;
@property (retain) Pulser* pulser;
@property NSInteger disabledCount;
@end

@implementation NotificationCenter

static NotificationCenter* notificationCenter;

@synthesize viewController;
@synthesize notificationLabel;
@synthesize blackLabel;
@synthesize notifications;
@synthesize pulser;
@synthesize disabledCount;

- (void) dealloc {
    self.viewController = nil;
    self.notificationLabel = nil;
    self.blackLabel = nil;
    self.notifications = nil;
    self.pulser = nil;
    self.disabledCount = 0;

    [super dealloc];
}


+ (NotificationCenter*) notificationCenter {
    if (notificationCenter == nil) {
        notificationCenter = [[NotificationCenter alloc] init];
    }

    return notificationCenter;
}


- (UIView*) view {
    return viewController.view;
}

const NSInteger TAB_BAR_HEIGHT = 47;
const NSInteger LABEL_HEIGHT = 16;
const NSInteger STATUS_BAR_HEIGHT = 20;

- (void) attachToViewController:(UIViewController*) viewController_ {
    self.viewController = viewController_;

    CGRect viewFrame = self.view.frame;

    NSInteger labelHeight = LABEL_HEIGHT;
    NSInteger top = viewFrame.size.height;
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        top -= TAB_BAR_HEIGHT;
    } else {
        labelHeight += 2;
    }
    top -= labelHeight;

    CGRect frame = CGRectMake(0, top, viewFrame.size.width, labelHeight);

    notificationLabel.frame = frame;
    frame.size.height = 1;
    blackLabel.frame = frame;

    [self.view addSubview:notificationLabel];
    [self.view addSubview:blackLabel];
}


+ (void) attachToViewController:(UIViewController*) viewController_ {
    [[self notificationCenter] attachToViewController:viewController_];
}


- (id) init {
    if (self = [super init]) {
        self.notifications = [NSMutableArray array];

        self.notificationLabel = [[[UILabel alloc] init] autorelease];
        self.blackLabel = [[[UILabel alloc] init] autorelease];

        notificationLabel.font = [UIFont boldSystemFontOfSize:12];
        notificationLabel.textAlignment = UITextAlignmentCenter;
        notificationLabel.textColor = [UIColor whiteColor];
        notificationLabel.shadowColor = [UIColor darkGrayColor];
        notificationLabel.shadowOffset = CGSizeMake(0, 1);
        notificationLabel.alpha = 0;
        notificationLabel.text = LocalizedString(@"Updating", nil);
        notificationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        notificationLabel.backgroundColor = [UIColor colorWithRed:46.0/256.0 green:46.0/256.0 blue:46.0/256.0 alpha:1];

        blackLabel.backgroundColor = [UIColor blackColor];
        blackLabel.alpha = 0;
        blackLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

        self.pulser = [Pulser pulserWithTarget:self
                                        action:@selector(update)
                                 pulseInterval:1];
    }

    return self;
}


- (void) showNotifications {
    if (disabledCount == 0 && [MetasyntacticSharedApplication notificationsEnabled]) {
        [self.view bringSubviewToFront:notificationLabel];
        [self.view bringSubviewToFront:blackLabel];

        [UIView beginAnimations:nil context:NULL];
        {
            notificationLabel.alpha = blackLabel.alpha = 1;
        }
        [UIView commitAnimations];
    }
}


- (void) hideNotifications {
    [UIView beginAnimations:nil context:NULL];
    {
        notificationLabel.alpha = blackLabel.alpha = 0;
    }
    [UIView commitAnimations];
}


- (NSString*) computeText {
    NSMutableArray* array = [NSMutableArray array];
    for (NSString* notification in notifications) {
        if (![array containsObject:notification]) {
            [array addObject:notification];
        }
    }

    if (array.count == 0) {
        return nil;
    }

    return [NSString stringWithFormat:LocalizedString(@"Updating: %@", nil), [array componentsJoinedByString:@", "]];
}


- (void) update {
    notificationLabel.text = [self computeText];
    if (notifications.count > 0) {
        [self showNotifications];
    } else {
        [self hideNotifications];
    }
}


- (void) willChangeInterfaceOrientation {
    notificationLabel.alpha = blackLabel.alpha = 0;
}


- (void) didChangeInterfaceOrientation {
    [self update];
}


- (void) addNotifications:(NSArray*) array {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(addNotifications:) withObject:array waitUntilDone:NO];
        return;
    }

    [notifications addObjectsFromArray:array];
    [pulser tryPulse];
}


- (void) removeNotifications:(NSArray*) array {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(removeNotifications:) withObject:array waitUntilDone:NO];
        return;
    }

    [notifications removeObjectsInArray:array];
    [pulser tryPulse];
}


- (void) addNotification:(NSString*) notification {
    [self addNotifications:[NSArray arrayWithObject:notification]];
}


- (void) removeNotification:(NSString*) notification {
    [self removeNotifications:[NSArray arrayWithObject:notification]];
}


- (void) disableNotifications {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(disableNotifications) withObject:nil waitUntilDone:NO];
        return;
    }

    disabledCount++;
    [self hideNotifications];
    [pulser tryPulse];
}


- (void) enableNotifications {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(enableNotifications) withObject:nil waitUntilDone:NO];
        return;
    }

    disabledCount--;
    [pulser tryPulse];
}


+ (void) addNotification:(NSString*) notification {
    [[self notificationCenter] addNotification:notification];
}


+ (void) removeNotification:(NSString*) notification {
    [[self notificationCenter] removeNotification:notification];
}


+ (void) addNotifications:(NSArray*) array {
    [[self notificationCenter] addNotifications:array];
}


+ (void) removeNotifications:(NSArray*) array {
    [[self notificationCenter] removeNotifications:array];
}


+ (void) disableNotifications {
    [[self notificationCenter] disableNotifications];
}


+ (void) enableNotifications {
    [[self notificationCenter] enableNotifications];
}


+ (void) didChangeInterfaceOrientation {
    [[self notificationCenter] didChangeInterfaceOrientation];
}


+ (void) willChangeInterfaceOrientation {
    [[self notificationCenter] willChangeInterfaceOrientation];
}

@end