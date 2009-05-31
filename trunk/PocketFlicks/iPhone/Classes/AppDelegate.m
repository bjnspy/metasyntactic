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

#import "ApplicationTabBarController.h"
#import "CacheUpdater.h"
#import "Controller.h"
#import "Model.h"
#import "NetflixNavigationController.h"

@interface AppDelegate()
@property (nonatomic, retain) UIWindow* window;
@property (retain) UIViewController* viewController;
@property (retain) Pulser* majorRefreshPulser;
@property (retain) Pulser* minorRefreshPulser;
@end


@implementation AppDelegate

static AppDelegate* appDelegate = nil;

@synthesize window;
@synthesize viewController;
@synthesize majorRefreshPulser;
@synthesize minorRefreshPulser;

- (void) dealloc {
    self.window = nil;
    self.viewController = nil;
    self.majorRefreshPulser = nil;
    self.minorRefreshPulser = nil;

    [super dealloc];
}


+ (AppDelegate*) appDelegate {
    return appDelegate;
}


- (void) applicationDidFinishLaunching:(UIApplication*) app {
    if (getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
        [AlertUtilities showOkAlert:@"Zombies enabled!"];
    }

  [MetasyntacticSharedApplication setSharedApplicationDelegate:self];

    appDelegate = self;

    [Model model];
    [Controller controller];
    [CacheUpdater cacheUpdater];
    [OperationQueue operationQueue];
    self.viewController = [[[NetflixNavigationController alloc] init] autorelease];

    self.majorRefreshPulser = [Pulser pulserWithTarget:viewController action:@selector(majorRefresh) pulseInterval:5];
    self.minorRefreshPulser = [Pulser pulserWithTarget:viewController action:@selector(minorRefresh) pulseInterval:5];

    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    [NotificationCenter attachToViewController:viewController];

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
        [majorRefreshPulser forcePulse];
    } else {
        [majorRefreshPulser tryPulse];
    }
}


- (void) majorRefresh:(BOOL) force {
    [self majorRefreshWorker:[NSNumber numberWithBool:force]];
}


- (void) majorRefresh {
    [self majorRefresh:NO];
}


- (void) minorRefresh {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(minorRefresh) withObject:nil waitUntilDone:NO];
        return;
    }

    [minorRefreshPulser tryPulse];
}


+ (void) minorRefresh {
    [appDelegate minorRefresh];
}


+ (void) majorRefresh {
  [appDelegate majorRefresh];
}


+ (void) majorRefresh:(BOOL) force {
  [appDelegate majorRefresh:force];
}


- (void) resetTabs {
}


+ (void) resetTabs {
    [appDelegate resetTabs];
}


+ (UIWindow*) window {
    return appDelegate.window;
}


- (void) applicationDidReceiveMemoryWarning:(UIApplication*) application {
    [[Model model] didReceiveMemoryWarning];
}


- (NSString*) localizedString:(NSString*) key {
  return [LocalizableStringsCache localizedString:key];
}


- (void) saveNavigationStack:(UINavigationController*) controller {
  [[Model model] saveNavigationStack:controller];
}


- (BOOL) notificationsEnabled {
  return [[Model model] notificationsEnabled];
}


- (BOOL) screenRotationEnabled {
  return [[Model model] screenRotationEnabled];
}

@end