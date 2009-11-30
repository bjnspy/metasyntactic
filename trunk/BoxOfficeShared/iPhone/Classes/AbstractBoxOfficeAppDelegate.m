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

#import "AbstractBoxOfficeAppDelegate.h"

#import "BoxOfficeSharedApplication.h"
#import "CacheUpdater.h"
#import "Controller.h"
#import "Model.h"

@interface AbstractBoxOfficeAppDelegate()
@property (retain) UIViewController* viewController;
@end

@implementation AbstractBoxOfficeAppDelegate

@synthesize viewController;

- (void) dealloc {
  self.viewController = nil;

  [super dealloc];
}


- (void) applicationDidFinishLaunching:(UIApplication*) app {
  if (getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
    [AlertUtilities showOkAlert:@"Zombies enabled!"];
  }

  [BoxOfficeSharedApplication setSharedApplicationDelegate:self];

  Class rootViewControllerClass = NSClassFromString([[[NSBundle mainBundle] infoDictionary] objectForKey:@"RootViewControllerClass"]);
  self.viewController = [[[rootViewControllerClass alloc] init] autorelease];

  [SplashScreen presentSplashScreen:self];
}


- (void) applicationWillTerminate:(UIApplication*) application {
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[Beacon shared] endBeacon];
}


- (Model*) model {
  return [Model model];
}


- (Controller*) controller {
  return [Controller controller];
}


- (void) onSplashScreenFinished {
  [NotificationCenter attachToViewController:self.viewController];

  // Ok.  We've set up all our global state.  Now get the ball rolling.
  [self.controller start];
}


- (void) majorRefresh {
  if ([self.viewController respondsToSelector:@selector(majorRefresh)]) {
    [(id)self.viewController majorRefresh];
  }
}


- (void) minorRefresh {
  if ([self.viewController respondsToSelector:@selector(minorRefresh)]) {
    [(id)self.viewController minorRefresh];
  }
}


- (void) resetTabs {
  if ([self.viewController respondsToSelector:@selector(resetTabs)]) {
    [(id)self.viewController resetTabs];
  }
}


- (NSString*) localizedString:(NSString*) key {
  return [LocalizableStringsCache localizedString:key];
}


- (void) saveNavigationStack:(UINavigationController*) controller {
  [self.model saveNavigationStack:controller];
}


- (BOOL) notificationsEnabled {
  return self.model.notificationsEnabled;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
  return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


- (BOOL) largePosterCacheAlwaysEnabled AbstractMethod;


- (BOOL) netflixCacheAlwaysEnabled AbstractMethod;


- (BOOL) netflixEnabled {
  return self.model.netflixCacheEnabled;
}


- (BOOL) netflixNotificationsEnabled {
  return self.model.netflixNotificationsEnabled;
}


- (NetflixAccount*) currentNetflixAccount {
  return self.model.currentNetflixAccount;
}


- (NSArray*) netflixAccounts {
  return self.model.netflixAccounts;
}


- (void) setCurrentNetflixAccount:(NetflixAccount*) account {
  [self.controller setCurrentNetflixAccount:account];
}


- (void) addNetflixAccount:(NetflixAccount*) account {
  [self.controller addNetflixAccount:account];
}


- (NetflixCache*) netflixCache {
  return [MutableNetflixCache cache];
}


- (NetflixUser*) netflixUserForAccount:(NetflixAccount*) account {
  return [[NetflixAccountCache cache] userForAccount:account];
}


- (void) removeNetflixAccount:(NetflixAccount*) account {
  [self.controller removeNetflixAccount:account];
}


- (void) reportNetflixMovies:(NSArray*) movies {
  [[CacheUpdater cacheUpdater] addMovies:movies];
}


- (void) reportNetflixMovie:(Movie*) movie {
  [[CacheUpdater cacheUpdater] addMovie:movie];
}

@end
