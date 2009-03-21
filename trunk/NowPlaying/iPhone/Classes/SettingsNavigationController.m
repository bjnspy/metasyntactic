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
/*
#import "SettingsNavigationController.h"

#import "SettingsViewController.h"

@interface SettingsNavigationController()
@property (retain) SettingsViewController* viewController;
@end


@implementation SettingsNavigationController

@synthesize viewController;

- (void) dealloc {
    self.viewController = nil;

    [super dealloc];
}


- (void) setViewTitle {
    self.title = NSLocalizedString(@"Settings", nil);
}


- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super initWithTabBarController:controller]) {
        self.tabBarItem.image = [UIImage imageNamed:@"More.png"];
        [self setViewTitle];
    }

    return self;
}


- (void) loadView {
    [super loadView];

    if (viewController == nil) {
        self.viewController = [[[SettingsViewController alloc] initWithNavigationController:self] autorelease];
        [self pushViewController:viewController animated:NO];
    }

    [self setViewTitle];
}


- (void) navigateToLastViewedPage {
}

@end
*/