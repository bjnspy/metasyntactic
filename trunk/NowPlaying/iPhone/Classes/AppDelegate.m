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

#import "AppDelegate.h"

#import "AlertUtilities.h"
#import "ApplicationTabBarController.h"
#import "CacheUpdater.h"
#import "Controller.h"
#import "LocationManager.h"
#import "Model.h"
#import "NotificationCenter.h"
#import "OperationQueue.h"
#import "Pulser.h"
#import "TappableImageView.h"

@interface AppDelegate()
@property (nonatomic, retain) UIWindow* window;
@property (retain) ApplicationTabBarController* tabBarController_;
@property (retain) NotificationCenter* notificationCenter_;
@property (retain) Pulser* majorRefreshPulser_;
@property (retain) Pulser* minorRefreshPulser_;
@property (retain) UIView* globalActivityView_;
@end


@implementation AppDelegate

static AppDelegate* appDelegate = nil;

@synthesize window;
@synthesize tabBarController_;
@synthesize notificationCenter_;
@synthesize majorRefreshPulser_;
@synthesize minorRefreshPulser_;
@synthesize globalActivityView_;

property_wrapper(ApplicationTabBarController*, tabBarController, TabBarController);
property_wrapper(NotificationCenter*, notificationCenter, NotificationCenter);
property_wrapper(Pulser*, minorRefreshPulser, MinorRefreshPulser);
property_wrapper(Pulser*, majorRefreshPulser, MajorRefreshPulser);
property_wrapper(UIView*, globalActivityView, GlobalActivityView)

- (void) dealloc {
    self.window = nil;
    self.tabBarController = nil;
    self.notificationCenter = nil;
    self.majorRefreshPulser = nil;
    self.minorRefreshPulser = nil;
    self.globalActivityView = nil;

    [super dealloc];
}


+ (AppDelegate*) appDelegate {
    return appDelegate;
}


- (void) setupGlobalActivtyIndicator {
    self.globalActivityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
}


- (void) applicationDidFinishLaunching:(UIApplication*) app {
    if (getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
        [AlertUtilities showOkAlert:@"Zombies enabled!"];
    }

    appDelegate = self;

    [self setupGlobalActivtyIndicator];

    [Model model];
    [Controller controller];
    [CacheUpdater cacheUpdater];
    [OperationQueue operationQueue];
    self.tabBarController = [ApplicationTabBarController controller];

    self.majorRefreshPulser = [Pulser pulserWithTarget:self.tabBarController action:@selector(majorRefresh) pulseInterval:5];
    self.minorRefreshPulser = [Pulser pulserWithTarget:self.tabBarController action:@selector(minorRefresh) pulseInterval:5];

    self.notificationCenter = [NotificationCenter centerWithView:self.tabBarController.view];

    [window addSubview:self.tabBarController.view];
    [window makeKeyAndVisible];

    // Ok.  We've set up all our global state.  Now get the ball rolling.
    [[Controller controller] start];
}


- (void) applicationWillTerminate:(UIApplication*) application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) majorRefresh:(NSNumber*) force {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(majorRefresh:) withObject:force waitUntilDone:NO];
        return;
    }

    if (force.boolValue) {
        [self.majorRefreshPulser forcePulse];
    } else {
        [self.majorRefreshPulser tryPulse];
    }
}


+ (void) majorRefresh:(BOOL) force {
    [appDelegate majorRefresh:[NSNumber numberWithBool:force]];
}


+ (void) majorRefresh {
    [self majorRefresh:NO];
}


- (void) minorRefresh {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(minorRefresh) withObject:nil waitUntilDone:NO];
        return;
    }

    [self.minorRefreshPulser tryPulse];
}


+ (void) minorRefresh {
    [appDelegate minorRefresh];
}


+ (UIWindow*) window {
    return appDelegate.window;
}


+ (NotificationCenter*) notificationCenter {
    return appDelegate.notificationCenter;
}


+ (void) addNotification:(NSString*) notification {
    [[self notificationCenter] addNotification:notification];
}


+ (void) addNotifications:(NSArray*) notifications {
    [[self notificationCenter] addNotifications:notifications];
}


+ (void) removeNotification:(NSString*) notification {
    [[self notificationCenter] removeNotification:notification];
}


+ (void) removeNotifications:(NSArray*) notifications {
    [[self notificationCenter] removeNotifications:notifications];
}


- (void) application:(UIApplication*) application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
    [self.notificationCenter willChangeStatusBarOrientation:newStatusBarOrientation];
}


- (void) application:(UIApplication*) application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    [self.notificationCenter didChangeStatusBarOrientation:oldStatusBarOrientation];
}

+ (UIView*) globalActivityView {
    return appDelegate.globalActivityView;
}


- (void) applicationDidReceiveMemoryWarning:(UIApplication*) application {
    [[Model model] didReceiveMemoryWarning];
}

@end