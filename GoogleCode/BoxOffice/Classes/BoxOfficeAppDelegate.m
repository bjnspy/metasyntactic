// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "BoxOfficeAppDelegate.h"

#import "ApplicationTabBarController.h"
#import "BoxOfficeController.h"
#import "BoxOfficeModel.h"
#import "NotificationCenter.h"

@implementation BoxOfficeAppDelegate

@synthesize window;
@synthesize controller;
@synthesize model;
@synthesize tabBarController;
@synthesize notificationCenter;

- (void) dealloc {
    self.window = nil;
    self.controller = nil;
    self.model = nil;
    self.tabBarController = nil;
    self.notificationCenter = nil;
    [super dealloc];
}


- (void) applicationDidFinishLaunching:(UIApplication*) app {
    self.notificationCenter = [NotificationCenter centerWithWindow:window];
    self.model = [BoxOfficeModel modelWithCenter:notificationCenter];
    self.tabBarController = [ApplicationTabBarController controllerWithAppDelegate:self];

    [window addSubview:tabBarController.view];
    [window makeKeyAndVisible];
    [self.notificationCenter addToWindow];

    self.controller = [BoxOfficeController controllerWithAppDelegate:self];
    [self.tabBarController refresh];
}


- (void) applicationWillTerminate:(UIApplication*) application {
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
