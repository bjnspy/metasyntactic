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
#import "LocationManager.h"
#import "Controller.h"
#import "Model.h"
#import "Pulser.h"
#import "TappableImageView.h"

@interface AppDelegate()
@property (nonatomic, retain) UIWindow* window;
@property (retain) ApplicationTabBarController* tabBarController;
@property (retain) Controller* controller;
@property (retain) Model* model;
@property (retain) Pulser* majorRefreshPulser;
@property (retain) Pulser* minorRefreshPulser;
@end


@implementation AppDelegate

static AppDelegate* appDelegate = nil;

@synthesize window;
@synthesize tabBarController;
@synthesize controller;
@synthesize model;
@synthesize majorRefreshPulser;
@synthesize minorRefreshPulser;

- (void) dealloc {
    self.window = nil;
    self.tabBarController = nil;
    self.controller = nil;
    self.model = nil;
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

    appDelegate = self;

    self.model = [Model model];
    self.controller = [Controller controllerWithAppDelegate:self];

    self.tabBarController = [ApplicationTabBarController controllerWithAppDelegate:self];
    self.majorRefreshPulser = [Pulser pulserWithTarget:tabBarController action:@selector(majorRefresh) pulseInterval:5];
    self.minorRefreshPulser = [Pulser pulserWithTarget:tabBarController action:@selector(minorRefresh) pulseInterval:5];

    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

    [controller start];
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

    [minorRefreshPulser tryPulse];
}


+ (void) minorRefresh {
    [appDelegate minorRefresh];
}


+ (UIWindow*) window {
    return appDelegate.window;
}

@end