// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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

  if (NO) {
    NSNumber* number = [NSNumber numberWithInt:0];
    [self performSelector:@selector(takeScreenShot:)
               withObject:number
               afterDelay:10];
  }
}


- (void) takeScreenShot:(NSNumber*) number {
  UIView* view = self.viewController.view;
  UIGraphicsBeginImageContext(view.bounds.size); //self.view.window.frame.size
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  NSData* data = UIImagePNGRepresentation(image);

  NSString* name = [NSString stringWithFormat:@"ScreenShot-%@.png", number];
  NSString* file = [[AbstractApplication cacheDirectory] stringByAppendingPathComponent:name];
  [FileUtilities writeData:data toFile:file];

  NSNumber* next = [NSNumber numberWithInt:number.intValue + 1];
  [self performSelector:@selector(takeScreenShot:)
             withObject:next
             afterDelay:10];
}


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


- (BOOL) trailerCacheAlwaysEnabled AbstractMethod;


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
