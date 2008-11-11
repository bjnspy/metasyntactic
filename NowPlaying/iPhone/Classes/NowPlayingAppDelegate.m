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

#import "NowPlayingAppDelegate.h"

#import "ApplicationTabBarController.h"
#import "LocationManager.h"
#import "NowPlayingController.h"
#import "NowPlayingModel.h"
#import "Pulser.h"
#import "TappableImageView.h"

@interface NowPlayingAppDelegate()
@property (nonatomic, retain) UIWindow* window;
@property (retain) ApplicationTabBarController* tabBarController;
@property (retain) NowPlayingController* controller;
@property (retain) NowPlayingModel* model;
@property (retain) Pulser* pulser;
@end


@implementation NowPlayingAppDelegate

static NowPlayingAppDelegate* appDelegate = nil;

@synthesize window;
@synthesize tabBarController;
@synthesize controller;
@synthesize model;
@synthesize pulser;

- (void) dealloc {
    self.window = nil;
    self.tabBarController = nil;
    self.controller = nil;
    self.model = nil;
    self.pulser = nil;

    [super dealloc];
}


+ (NowPlayingAppDelegate*) appDelegate {
    return appDelegate;
}


- (void) applicationDidFinishLaunching:(UIApplication*) app {
    appDelegate = self;

    self.model = [NowPlayingModel model];
    self.controller = [NowPlayingController controllerWithAppDelegate:self];
    
    self.tabBarController = [ApplicationTabBarController controllerWithAppDelegate:self];
    self.pulser = [Pulser pulserWithTarget:tabBarController action:@selector(refresh) pulseInterval:5];
    
    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    
    [controller start];
}


- (void) applicationWillTerminate:(UIApplication*) application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) refresh:(NSNumber*) force {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(refresh:) withObject:force waitUntilDone:NO];
        return;
    }

    if (force.boolValue) {
        [pulser forcePulse];
    } else {
        [pulser tryPulse];
    }
}


+ (void) refresh:(BOOL) force {
    [appDelegate refresh:[NSNumber numberWithBool:force]];
}


+ (void) refresh {
    [self refresh:NO];
}

@end