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

#import "YourRightsAppDelegate.h"

#import "Model.h"
#import "Pulser.h"
#import "SectionViewController.h"
#import "YourRightsNavigationController.h"

@interface YourRightsAppDelegate()
@property (retain) YourRightsNavigationController* navigationController;
@property (retain) Model* model;
@property (retain) Pulser* majorRefreshPulser;
@property (retain) Pulser* minorRefreshPulser;
@end

@implementation YourRightsAppDelegate

static YourRightsAppDelegate* appDelegate = nil;

@synthesize window;
@synthesize navigationController;
@synthesize model;
@synthesize majorRefreshPulser;
@synthesize minorRefreshPulser;

- (void) dealloc {
    self.window = nil;
    self.navigationController = nil;
    self.model = nil;
    self.majorRefreshPulser = nil;
    self.minorRefreshPulser = nil;
    [super dealloc];
}


- (void) applicationDidFinishLaunching:(UIApplication*) application {
    appDelegate = self;
    
    SectionViewController* controller = [[[SectionViewController alloc] init] autorelease];
    self.navigationController = [[[YourRightsNavigationController alloc] initWithRootViewController:controller] autorelease];

    self.majorRefreshPulser = [Pulser pulserWithTarget:navigationController action:@selector(majorRefresh) pulseInterval:5];
    self.minorRefreshPulser = [Pulser pulserWithTarget:navigationController action:@selector(minorRefresh) pulseInterval:5];

    self.model = [[[Model alloc] init] autorelease];

    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
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


@end