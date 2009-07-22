//
//  BoxOfficeAppDelegate.m
//  BoxOfficeShared
//
//  Created by Cyrus Najmabadi on 7/22/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BoxOfficeAppDelegate.h"

#import "BoxOfficeSharedApplication.h"
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
  
  [Beacon initAndStartBeaconWithApplicationCode:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"PinchMediaApplicationCode"]
                                useCoreLocation:NO
                                    useOnlyWiFi:NO];
  
  [BoxOfficeSharedApplication setSharedApplicationDelegate:self];
  
  Class rootViewControllerClass = NSClassFromString([[[NSBundle mainBundle] infoDictionary] objectForKey:@"RootViewControllerClass"]);
  self.viewController = [[[rootViewControllerClass alloc] init] autorelease];
  
  [SplashScreen presentSplashScreen:self];
}


- (void) applicationWillTerminate:(UIApplication*) application {
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[Beacon shared] endBeacon];
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
  return [[Model model] notificationsEnabled];
}


- (BOOL) screenRotationEnabled {
  return [[Model model] screenRotationEnabled];
}


- (BOOL) largePosterCacheAlwaysEnabled {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (BOOL) netflixCacheAlwaysEnabled {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}

@end
