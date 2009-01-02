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

#import "NetflixNavigationController.h"

#import "ColorCache.h"
#import "NetflixViewController.h"

@interface NetflixNavigationController()
@property (retain) NetflixViewController* netflixViewController;
@end


@implementation NetflixNavigationController

@synthesize netflixViewController;

- (void) dealloc {
    self.netflixViewController = nil;
    [super dealloc];
}


- (id) initWithTabBarController:(MetaFlixAppDelegate*) appDelegate {
    if (self = [super initWithAppDelegate:appDelegate]) {
        self.title = NSLocalizedString(@"MetaFlix", nil); //195.175.105
        self.navigationBar.tintColor = [UIColor colorWithRed:195.0/255.0 green:175.0/255.0 blue:105.0/255.0 alpha:1];
    }

    return self;
}


- (void) loadView {
    [super loadView];

    if (netflixViewController == nil) {
        self.netflixViewController = [[[NetflixViewController alloc] initWithNavigationController:self] autorelease];
        [self pushViewController:netflixViewController animated:NO];
    }
    
    self.navigationBar.tintColor = [ColorCache netflixYellow];
}

@end