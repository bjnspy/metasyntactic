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

#import "UpcomingMoviesNavigationController.h"

#import "Model.h"
#import "Movie.h"
#import "UpcomingCache.h"
#import "UpcomingMoviesViewController.h"

@interface UpcomingMoviesNavigationController()
@property (retain) UpcomingMoviesViewController* upcomingMoviesViewController;
@end


@implementation UpcomingMoviesNavigationController

@synthesize upcomingMoviesViewController;

- (void) dealloc {
    self.upcomingMoviesViewController = nil;

    [super dealloc];
}


- (id) initWithTabBarController:(ApplicationTabBarController*) controller {
    if (self = [super initWithTabBarController:controller]) {
        self.title = NSLocalizedString(@"Upcoming", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"Upcoming.png"];
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (void) loadView {
    [super loadView];

    if (upcomingMoviesViewController == nil) {
        self.upcomingMoviesViewController = [[[UpcomingMoviesViewController alloc] initWithNavigationController:self] autorelease];
        [self pushViewController:upcomingMoviesViewController animated:NO];
    }
}


- (Movie*) movieForTitle:(NSString*) canonicalTitle {
    for (Movie* movie in self.model.upcomingCache.movies) {
        if ([movie.canonicalTitle isEqual:canonicalTitle]) {
            return movie;
        }
    }

    return [super movieForTitle:canonicalTitle];
}

@end