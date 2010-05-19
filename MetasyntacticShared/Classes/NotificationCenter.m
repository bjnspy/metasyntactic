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

#import "NotificationCenter.h"

#import "MetasyntacticSharedApplication.h"
#import "Pulser.h"
#import "UIColor+Utilities.h"

@interface NotificationCenter()
@property (retain) UIViewController* viewController;
@property (retain) UILabel* notificationLabel;
@property (retain) UILabel* trimLabel;
@property (retain) NSMutableArray* notifications;
@property (retain) Pulser* pulser;
@property NSInteger disabledCount;
@end

@implementation NotificationCenter

static NotificationCenter* notificationCenter;

+ (void) initialize {
  if (self == [NotificationCenter class]) {
    notificationCenter = [[NotificationCenter alloc] init];
  }
}

@synthesize viewController;
@synthesize notificationLabel;
@synthesize trimLabel;
@synthesize notifications;
@synthesize pulser;
@synthesize disabledCount;

- (void) dealloc {
  self.viewController = nil;
  self.notificationLabel = nil;
  self.trimLabel = nil;
  self.notifications = nil;
  self.pulser = nil;
  self.disabledCount = 0;

  [super dealloc];
}


+ (NotificationCenter*) notificationCenter {
  return notificationCenter;
}


- (UIView*) view {
  return viewController.view;
}

const NSInteger LABEL_HEIGHT = 16;
const NSInteger STATUS_BAR_HEIGHT = 20;

- (void) attachToViewController:(UIViewController*) viewController_
                backgroundColor:(UIColor*) backgroundColor
                      trimColor:(UIColor*) trimColor
                      textColor:(UIColor*) textColor
                    labelOffset:(NSInteger) labelOffset  {
  self.viewController = viewController_;

  notificationLabel.textColor = textColor;
  notificationLabel.backgroundColor = backgroundColor;
  trimLabel.backgroundColor = trimColor;

  CGRect viewFrame = self.view.frame;

  NSInteger labelHeight = LABEL_HEIGHT;
  NSInteger top = viewFrame.size.height;
  if ([viewController isKindOfClass:[UITabBarController class]]) {
    top -= ([[(id)viewController tabBar] frame].size.height - 2);
  } else {
    labelHeight += 2;
  }
  top -= labelHeight;
  top -= labelOffset;

  CGRect frame = CGRectMake(0, top, viewFrame.size.width, labelHeight);

  notificationLabel.frame = frame;
  frame.size.height = 1;
  trimLabel.frame = frame;

  [self.view addSubview:notificationLabel];
  [self.view addSubview:trimLabel];

  [self.view bringSubviewToFront:notificationLabel];
  [self.view bringSubviewToFront:trimLabel];
}


+ (void) attachToViewController:(UIViewController*) viewController_
                backgroundColor:(UIColor*) backgroundColor
                      trimColor:(UIColor*) trimColor
                      textColor:(UIColor*) textColor
                    labelOffset:(NSInteger) labelOffset {
  [[self notificationCenter] attachToViewController:viewController_
                                    backgroundColor:backgroundColor
                                          trimColor:trimColor
                                          textColor:textColor
                                        labelOffset:labelOffset];
}


+ (void) attachToViewController:(UIViewController*) viewController_ {
  [self attachToViewController:viewController_
               backgroundColor:RGBUIColor(46, 46, 46)
                     trimColor:[UIColor blackColor]
                     textColor:[UIColor whiteColor]
                   labelOffset:0];
}


- (id) init {
  if ((self = [super init])) {
    self.notifications = [NSMutableArray array];

    self.notificationLabel = [[[UILabel alloc] init] autorelease];
    self.trimLabel = [[[UILabel alloc] init] autorelease];

    notificationLabel.font = [UIFont boldSystemFontOfSize:12];
    notificationLabel.textAlignment = UITextAlignmentCenter;
    notificationLabel.shadowColor = [UIColor darkGrayColor];
    notificationLabel.shadowOffset = CGSizeMake(0, 1);
    notificationLabel.alpha = 0;
    notificationLabel.text = LocalizedString(@"Updating", nil);
    notificationLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    trimLabel.alpha = 0;
    trimLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    self.pulser = [Pulser pulserWithTarget:self
                                    action:@selector(update)
                             pulseInterval:1];
  }

  return self;
}


- (void) showNotifications {
  if (disabledCount == 0 && [MetasyntacticSharedApplication notificationsEnabled]) {
    [self.view bringSubviewToFront:notificationLabel];
    [self.view bringSubviewToFront:trimLabel];

    [UIView beginAnimations:nil context:NULL];
    {
      notificationLabel.alpha = trimLabel.alpha = 1;
    }
    [UIView commitAnimations];
  }
}


- (void) hideNotifications {
  [UIView beginAnimations:nil context:NULL];
  {
    notificationLabel.alpha = trimLabel.alpha = 0;
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
  notificationLabel.alpha = trimLabel.alpha = 0;
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

  for (NSString* string in array) {
    NSInteger index = [notifications indexOfObject:string];
    if (index != NSNotFound) {
      [notifications removeObjectAtIndex:index];
    }
  }
  [pulser tryPulse];
}


- (void) addNotification:(NSString*) notification {
  if (notification.length == 0) {
    return;
  }

  [self addNotifications:[NSArray arrayWithObject:notification]];
}


- (void) removeNotification:(NSString*) notification {
  if (notification.length == 0) {
    return;
  }

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
