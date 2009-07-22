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
@property (retain) UIViewController* viewController;
@end

@implementation AppDelegate

@synthesize window;
@synthesize viewController;

- (void) dealloc {
  self.window = nil;
  self.viewController = nil;
  [super dealloc];
}


- (void) applicationDidFinishLaunching:(UIApplication*) application {
  [MetasyntacticSharedApplication setSharedApplicationDelegate:self];

  self.viewController = [[[YourRightsNavigationController alloc] init] autorelease];

  [SplashScreen presentSplashScreen:self];
}


- (void) onSplashScreenFinished {
  [NotificationCenter attachToViewController:viewController];

  [[Controller controller] start];
}


- (void) majorRefresh {
  if ([viewController respondsToSelector:@selector(majorRefresh)]) {
    [(id)viewController majorRefresh];
  }
}


- (void) minorRefresh {
  if ([viewController respondsToSelector:@selector(minorRefresh)]) {
    [(id)viewController minorRefresh];
  }
}


- (NSString*) localizedString:(NSString*) key {
  return NSLocalizedString(key, nil);
}


- (void) saveNavigationStack:(UINavigationController*) controller {
}


- (BOOL) notificationsEnabled {
  return YES;
}


- (BOOL) screenRotationEnabled {
  return YES;
}

@end
