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

#import "NowPlayingAppDelegate.h"

#import "ApplicationTabBarController.h"
#import "NowPlayingController.h"
#import "NowPlayingModel.h"
#import "Pulser.h"
#import "TappableImageView.h"

@implementation NowPlayingAppDelegate


static NowPlayingAppDelegate* appDelegate = nil;


@synthesize window;
@synthesize tabBarController;
@synthesize fullScreenPosterImageView;
@synthesize originalLocation;
@synthesize controller;
@synthesize model;
@synthesize pulser;

- (void) dealloc {
    self.window = nil;
    self.tabBarController = nil;
    self.fullScreenPosterImageView = nil;
    self.originalLocation = nil;
    self.controller = nil;
    self.model = nil;
    self.pulser = nil;

    [super dealloc];
}


+ (NowPlayingAppDelegate*) appDelegate {
    return appDelegate;
}


- (void) applicationDidFinishLaunching:(UIApplication*) app {
    appDelegate = self;

    self.model = [NowPlayingModel model];
    self.tabBarController = [ApplicationTabBarController controllerWithAppDelegate:self];
    self.pulser = [Pulser pulserWithTarget:tabBarController action:@selector(refresh) pulseInterval:5];

    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

    self.controller = [NowPlayingController controllerWithAppDelegate:self];
}


- (void) applicationWillTerminate:(UIApplication*) application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void) refresh:(NSNumber*) force {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(refresh:) withObject:force waitUntilDone:NO];
        return;
    }

    if (force.boolValue) {
        [pulser forcePulse];
    } else {
        [pulser tryPulse];
    }
}


+ (void) refresh:(BOOL) force {
    [appDelegate refresh:[NSNumber numberWithBool:force]];
}


+ (void) refresh {
    [self refresh:NO];
}


- (void) zoomInImage:(UIImage*) image
        fromLocation:(UIImageView*) originalLocation_ {
    zoomedIn = YES;
    self.originalLocation = originalLocation_;

    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];

    if (fullScreenPosterImageView == nil) {
        self.fullScreenPosterImageView = [[[TappableImageView alloc] initWithImage:image] autorelease];
        [window addSubview:fullScreenPosterImageView];
        fullScreenPosterImageView.contentMode = UIViewContentModeScaleAspectFill;
        fullScreenPosterImageView.delegate = self;
    }

    CGRect smallCoverFrame = [window convertRect:originalLocation.frame fromView:originalLocation];
    fullScreenPosterImageView.image = image;
    fullScreenPosterImageView.frame = smallCoverFrame;
    fullScreenPosterImageView.alpha = 0;

    [window bringSubviewToFront:fullScreenPosterImageView];

    [UIView beginAnimations:nil context:NULL];
    {
        fullScreenPosterImageView.frame = screenFrame;
        fullScreenPosterImageView.alpha = 1;
    }
    [UIView commitAnimations];
}

+ (void) zoomInImage:(UIImage*) image
        fromLocation:(UIImageView*) originalLocation_ {
    [appDelegate zoomInImage:image fromLocation:originalLocation_];
}


- (void) zoomOutImage {
    zoomedIn = NO;
    CGRect smallCoverFrame = [window convertRect:originalLocation.frame fromView:originalLocation];

    // first animate the shrink, then disconnect the large image
    [UIView beginAnimations:nil context:NULL];
    {
        [UIView setAnimationDidStopSelector:@selector(onAfterZoomOut:finished:context:)];
        fullScreenPosterImageView.frame = smallCoverFrame;
        fullScreenPosterImageView.alpha = 0;
    }
    [UIView commitAnimations];
}


- (void) onAfterZoomOut:(NSString*) animationId
               finished:(BOOL) finished
                context:(void*) context {
    [window sendSubviewToBack:fullScreenPosterImageView];
}


- (void) imageView:(TappableImageView*) imageView_
         wasTapped:(NSInteger) tapCount {
    [self zoomOutImage];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return !zoomedIn;
}


+ (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    return [appDelegate shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

@end