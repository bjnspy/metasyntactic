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
@end


@implementation AppDelegate

static AppDelegate* appDelegate = nil;

@synthesize window;
@synthesize viewController;

- (void) dealloc {
  self.window = nil;
  self.viewController = nil;

  [super dealloc];
}


+ (AppDelegate*) appDelegate {
  return appDelegate;
}


- (void) applicationDidFinishLaunching:(UIApplication*) app {
  if (getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
    [AlertUtilities showOkAlert:@"Zombies enabled!"];
  }

  [Beacon initAndStartBeaconWithApplicationCode:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"PinchMediaApplicationCode"]
                                useCoreLocation:NO
                                    useOnlyWiFi:NO];

  [MetasyntacticSharedApplication setSharedApplicationDelegate:self];

  appDelegate = self;

  Class rootViewControllerClass = NSClassFromString([[[NSBundle mainBundle] infoDictionary] objectForKey:@"RootViewControllerClass"]);
  self.viewController = [[[rootViewControllerClass alloc] init] autorelease];

  [window addSubview:viewController.view];
  [window makeKeyAndVisible];

  [NotificationCenter attachToViewController:viewController];

  // Ok.  We've set up all our global state.  Now get the ball rolling.
  [[Controller controller] start];
}


- (void) applicationWillTerminate:(UIApplication*) application {
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[Beacon shared] endBeacon];
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


- (void) resetTabs {
  if ([viewController isKindOfClass:[ApplicationTabBarController class]]) {
    [(id) viewController resetTabs];
  }
}


+ (void) resetTabs {
  [appDelegate resetTabs];
}


+ (UIWindow*) window {
  return appDelegate.window;
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
