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
#import "Controller.h"
#import "GlobalActivityIndicator.h"
#import "Model.h"
#import "Pulser.h"
#import "TappableImageView.h"
#import "NetflixNavigationController.h"

@interface AppDelegate()
@property (nonatomic, retain) UIWindow* window;
@property (retain) NetflixNavigationController* navigationController;
@property (retain) Controller* controller;
@property (retain) Model* model;
@property (retain) Pulser* majorRefreshPulser;
@property (retain) Pulser* minorRefreshPulser;
@property (retain) UIActivityIndicatorView* globalActivityIndicatorView;
@property (retain) UIView* globalActivityView;
@end


@implementation AppDelegate

static AppDelegate* appDelegate = nil;

@synthesize window;
@synthesize navigationController;
@synthesize controller;
@synthesize model;
@synthesize majorRefreshPulser;
@synthesize minorRefreshPulser;
@synthesize globalActivityIndicatorView;
@synthesize globalActivityView;

- (void) dealloc {
    self.window = nil;
    self.navigationController = nil;
    self.controller = nil;
    self.model = nil;
    self.majorRefreshPulser = nil;
    self.minorRefreshPulser = nil;
    self.globalActivityIndicatorView = nil;
    self.globalActivityView = nil;

    [super dealloc];
}


+ (AppDelegate*) appDelegate {
    return appDelegate;
}


- (void) setupGlobalActivityIndicator {
    self.globalActivityIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] retain];
    CGRect frame = globalActivityIndicatorView.frame;
    frame.size.width += 4;

    self.globalActivityView = [[[UIView alloc] initWithFrame:frame] retain];
    [globalActivityView addSubview:globalActivityIndicatorView];
    
    [GlobalActivityIndicator setTarget:globalActivityIndicatorView
                startIndicatorSelector:@selector(startAnimating)
                 stopIndicatorSelector:@selector(stopAnimating)];
}


- (void) applicationDidFinishLaunching:(UIApplication*) app {
    if (getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
        [AlertUtilities showOkAlert:@"Zombies enabled!"];
    }

    appDelegate = self;

    [self setupGlobalActivityIndicator];

    self.model = [Model model];
    self.controller = [Controller controllerWithAppDelegate:self];

    self.navigationController = [[[NetflixNavigationController alloc] initWithAppDelegate:self] autorelease];
    self.majorRefreshPulser = [Pulser pulserWithTarget:navigationController action:@selector(majorRefresh) pulseInterval:5];
    self.minorRefreshPulser = [Pulser pulserWithTarget:navigationController action:@selector(minorRefresh) pulseInterval:5];

    [window addSubview:navigationController.view];
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


+ (UIView*) globalActivityView {
    return appDelegate.globalActivityView;
}

@end