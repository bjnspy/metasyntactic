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

#if 0

#import "NumbersNavigationController.h"

#import "NumbersViewController.h"

@implementation NumbersNavigationController

@synthesize viewController;

- (void) dealloc {
    self.viewController = nil;

    [super dealloc];
}


- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super initWithTabBarController:controller]) {
        self.title = NSLocalizedString(@"Numbers", @"Usually translated as 'Statistics'.  This shows the user data about how well the movie is doing in the boxoffice.");
        self.tabBarItem.image = [UIImage imageNamed:@"Numbers.png"];
    }

    return self;
}


- (void) loadView {
    [super loadView];

    self.viewController = [[[NumbersViewController alloc] initWithNavigationController:self] autorelease];
    [self pushViewController:viewController animated:NO];
}


- (void) navigateToLastViewedPage {
}

@end

#endif