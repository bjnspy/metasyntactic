// Copyright (C) 2008 Cyrus Najmabadi
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

#import "NowPlayingAppDelegate.h"

#import "ApplicationTabBarController.h"
#import "NowPlayingController.h"
#import "NowPlayingModel.h"

@implementation NowPlayingAppDelegate

@synthesize window;
@synthesize controller;
@synthesize model;
@synthesize tabBarController;

- (void) dealloc {
    self.window = nil;
    self.controller = nil;
    self.model = nil;
    self.tabBarController = nil;

    [super dealloc];
}


- (void) applicationDidFinishLaunching:(UIApplication*) app {
    self.model = [NowPlayingModel model];
    self.tabBarController = [ApplicationTabBarController controllerWithAppDelegate:self];

    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];

    self.controller = [NowPlayingController controllerWithAppDelegate:self];
    [tabBarController refresh];
}


- (void) applicationWillTerminate:(UIApplication*) application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end