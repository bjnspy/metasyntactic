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

#import "DVDNavigationController.h"

#import "Movie.h"
#import "DVDCache.h"
#import "DVDViewController.h"
#import "NowPlayingModel.h"

@implementation DVDNavigationController

@synthesize dvdViewController;

- (void) dealloc {
    self.dvdViewController = nil;

    [super dealloc];
}


- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super initWithTabBarController:controller]) {
        self.title = NSLocalizedString(@"DVD", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"DVD.png"];
    }

    return self;
}


- (void) loadView {
    [super loadView];
    self.dvdViewController = [[[DVDViewController alloc] initWithNavigationController:self] autorelease];
    [self pushViewController:dvdViewController animated:NO];
}


- (Movie*) movieForTitle:(NSString*) canonicalTitle {
    for (Movie* movie in self.model.dvdCache.allMovies) {
        if ([movie.canonicalTitle isEqual:canonicalTitle]) {
            return movie;
        }
    }

    return [super movieForTitle:canonicalTitle];
}

@end