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

#import "YourRightsNavigationController.h"

#import "RootViewController.h"
#import "SectionViewController.h"
#import "YourRightsAppDelegate.h"

@interface YourRightsNavigationController()
@property (assign) YourRightsAppDelegate* appDelegate;
@property (retain) SectionViewController* viewController;
@end

@implementation YourRightsNavigationController

@synthesize appDelegate;
@synthesize viewController;

- (void) dealloc {
    self.appDelegate = nil;
    self.viewController = nil;

    [super dealloc];
}


- (id) initWithAppDelegate:(YourRightsAppDelegate*) appDelegate_ {
    if (self = [super init]) {
        self.appDelegate = appDelegate_;
        self.viewController = [[[SectionViewController alloc] initWithNavigationController:self] autorelease];
        [self pushViewController:viewController animated:NO];
    }

    return self;
}


- (Model*) model {
    return appDelegate.model;
}


- (void) refresh:(SEL) selector {
    for (id controller in self.viewControllers) {
        if ([controller respondsToSelector:selector]) {
            [controller performSelector:selector];
        }
    }
}


- (void) majorRefresh {
    [self refresh:@selector(majorRefresh)];
}


- (void) minorRefresh {
    [self refresh:@selector(minorRefresh)];
}

@end
