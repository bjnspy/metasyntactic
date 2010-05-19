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

#import "AppDelegate.h"

#import "Controller.h"
#import "Model.h"
#import "SectionViewController.h"
#import "YourRightsNavigationController.h"

@interface AppDelegate()
@property (retain) IBOutlet UIWindow *window;
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

@end
