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

#import "Controller.h"
#import "Model.h"
#import "SectionViewController.h"
#import "YourRightsNavigationController.h"

@interface AppDelegate()
@property (retain) YourRightsNavigationController* navigationController;
@property (retain) Pulser* majorRefreshPulser;
@property (retain) Pulser* minorRefreshPulser;
@end

@implementation AppDelegate

static AppDelegate* appDelegate = nil;

@synthesize window;
@synthesize navigationController;
@synthesize majorRefreshPulser;
@synthesize minorRefreshPulser;

- (void) dealloc {
    self.window = nil;
    self.navigationController = nil;
    self.majorRefreshPulser = nil;
    self.minorRefreshPulser = nil;
    [super dealloc];
}


- (void) applicationDidFinishLaunching:(UIApplication*) application {
  [MetasyntacticSharedApplication setSharedApplicationDelegate:self];
    appDelegate = self;

    [Model model];
    [Controller controller];
    [OperationQueue operationQueue];
    self.navigationController = [[[YourRightsNavigationController alloc] init] autorelease];

    self.majorRefreshPulser = [Pulser pulserWithTarget:navigationController action:@selector(majorRefresh) pulseInterval:5];
    self.minorRefreshPulser = [Pulser pulserWithTarget:navigationController action:@selector(minorRefresh) pulseInterval:5];

    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];

    [NotificationCenter attachToViewController:navigationController];

    [[Controller controller] start];
}


- (void) majorRefreshWorker:(NSNumber*) force {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(majorRefreshWorker:) withObject:force waitUntilDone:NO];
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


- (NSString*) localizedString:(NSString*) key {
  return NSLocalizedString(key, nil);
}


- (void) saveNavigationStack:(UINavigationController*) controller {
  [[Model model] saveNavigationStack:controller];
}


- (BOOL) notificationsEnabled {
  return YES;
}


- (BOOL) screenRotationEnabled {
  return YES;
}


- (void) applicationDidReceiveMemoryWarning:(UIApplication*) application {
}

@end