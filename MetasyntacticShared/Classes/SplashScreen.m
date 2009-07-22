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

#import "SplashScreen.h"

#import "FileUtilities.h"
#import "SplashScreenDelegate.h"

@interface SplashScreen()
@property (retain) NSArray* imagePaths;
@end

@implementation SplashScreen

@synthesize imagePaths;

- (void) dealloc {
  self.imagePaths = nil;
  [super dealloc];
}


- (id) initWithDelegate:(id<SplashScreenDelegate>) delegate_ {
  if ((self = [super init])) {
    delegate = delegate_;
    self.wantsFullScreenLayout = YES;
  }
  return self;
}


- (void) dismiss {
  UIViewController* rootViewController = [delegate viewController];
  rootViewController.view.alpha = 0;

  UIWindow* window = [[UIApplication sharedApplication] keyWindow];
  [window addSubview:rootViewController.view];

  [UIView beginAnimations:nil context:NULL];
  {
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onFadeComplete:finished:context:)];

    rootViewController.view.alpha = 1;
  }
  [UIView commitAnimations];
}


- (void) onFadeComplete:(NSString *)animationID
               finished:(NSNumber *)finished
                context:(UIView*) previousView {
  [self.view removeFromSuperview];
  [delegate onSplashScreenFinished];
  [self autorelease];
}


- (void) loadImage:(NSNumber*) value {
  NSInteger index = [value intValue];
  if (index >= imagePaths.count) {
    [self dismiss];
    return;
  }

  NSString* path = [imagePaths objectAtIndex:index];

  UIImage* image = [UIImage imageWithContentsOfFile:path];
  UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];

  imageView.alpha = 0;
  [self.view addSubview:imageView];

  NSInteger pause;
  if (index == 0) {
    pause = 0;
    imageView.alpha = 1;
  } else {
    pause = 1;
    [UIView beginAnimations:nil context:NULL];
    {
      imageView.alpha = 1;
    }
    [UIView commitAnimations];
  }

  [self performSelector:@selector(loadImage:)
             withObject:[NSNumber numberWithInt:index + 1]
             afterDelay:pause];
}


- (NSString*) bundlePath:(NSString*) file {
  return [[NSBundle mainBundle] pathForResource:file ofType:nil];
}


- (void) loadView {
  [super loadView];

  NSMutableArray* paths = [NSMutableArray array];
  NSString* defaultPath = [self bundlePath:@"Default.png"];
  if ([FileUtilities fileExists:defaultPath]) {
    [paths addObject:defaultPath];
  }
  for (NSInteger i = 0; ; i++) {
    NSString* name = [NSString stringWithFormat:@"SplashScreen-%d.png", i];
    NSString* path = [self bundlePath:name];
    if (![FileUtilities fileExists:path]) {
      break;
    }
    [paths addObject:path];
  }
  self.imagePaths = paths;
}


- (void) viewDidAppear:(BOOL) animated {
  [super viewDidAppear:animated];
  [self loadImage:[NSNumber numberWithInt:0]];
}


+ (void) presentSplashScreen:(id<SplashScreenDelegate>) delegate {
  // Will autorelease this in onFadeComplete
  SplashScreen* controller = [[SplashScreen alloc] initWithDelegate:delegate];

  UIWindow* window = [[UIApplication sharedApplication] keyWindow];
  [window addSubview:controller.view];
  [window makeKeyAndVisible];
}

@end
