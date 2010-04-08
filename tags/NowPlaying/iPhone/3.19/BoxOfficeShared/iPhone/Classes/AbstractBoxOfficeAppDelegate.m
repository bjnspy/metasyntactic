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
#import "Controller.h"
#import "Model.h"
#import "MovieCacheUpdater.h"

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

  if ([Model model].netflixTheming) {
    [StyleSheet enableTheming];
  } else {
    [StyleSheet disableTheming];
  }

  Class rootViewControllerClass = NSClassFromString([[[NSBundle mainBundle] infoDictionary] objectForKey:@"RootViewControllerClass"]);
  self.viewController = [[[rootViewControllerClass alloc] init] autorelease];

  [SplashScreen presentSplashScreen:self];

//  if (NO) {
//    NSNumber* number = [NSNumber numberWithInt:0];
//    [self performSelector:@selector(takeScreenShot:)
//               withObject:number
//               afterDelay:10];
//  }
}


//- (void) takeScreenShot:(NSNumber*) number {
//  UIView* view = self.viewController.view;
//  UIGraphicsBeginImageContext(view.bounds.size); //self.view.window.frame.size
//  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
//  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
//  UIGraphicsEndImageContext();  
//  
//  NSData* data = UIImagePNGRepresentation(image);
//  
//  NSString* name = [NSString stringWithFormat:@"ScreenShot-%@.png", number];
//  NSString* file = [[AbstractApplication cacheDirectory] stringByAppendingPathComponent:name];
//  [FileUtilities writeData:data toFile:file];
//  
//  NSNumber* next = [NSNumber numberWithInt:number.intValue + 1];
//  [self performSelector:@selector(takeScreenShot:)
//             withObject:next
//             afterDelay:10];
//}


- (void) applicationWillTerminate:(UIApplication*) application {
  [[NSUserDefaults standardUserDefaults] synchronize];
  //[[Beacon shared] endBeacon];
}


- (void) onSplashScreenFinished {
  [NotificationCenter attachToViewController:self.viewController];

  // Ok.  We've set up all our global state.  Now get the ball rolling.
  [[Controller controller] start];
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
  [[Model model] saveNavigationStack:controller];
}


- (BOOL) notificationsEnabled {
  return [Model model].notificationsEnabled;
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
  if ([Portability userInterfaceIdiom] == UserInterfaceIdiomPad) {
    return YES;
  } else {
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
  }
}


- (BOOL) largePosterCacheAlwaysEnabled AbstractMethod;


- (BOOL) netflixCacheAlwaysEnabled AbstractMethod;


- (BOOL) netflixEnabled {
  return [Model model].netflixCacheEnabled;
}


- (BOOL) netflixNotificationsEnabled {
  return [Model model].netflixNotificationsEnabled;
}


- (void) onCurrentNetflixAccountSet {
  [[Controller controller] onCurrentNetflixAccountSet];
}


- (void) reportNetflixMovies:(NSArray*) movies {
  [[MovieCacheUpdater updater] addMovies:movies];
}


- (void) reportNetflixMovie:(Movie*) movie {
  [[MovieCacheUpdater updater] addMovie:movie];
}

@end
