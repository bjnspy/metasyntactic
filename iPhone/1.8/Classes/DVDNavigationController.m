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

#import "DVDCache.h"
#import "DVDViewController.h"
#import "Model.h"
#import "Movie.h"

@interface DVDNavigationController()
@property (retain) DVDViewController* dvdViewController;
@end


@implementation DVDNavigationController

@synthesize dvdViewController;

- (void) dealloc {
    self.dvdViewController = nil;

    [super dealloc];
}


- (Model*) model {
    return [Model model];
}


- (void) setupTitle {
    if (self.model.dvdMoviesShowOnlyBluray) {
        self.title = LocalizedString(@"Blu-ray", nil);
    } else {
        self.title = LocalizedString(@"DVD", nil);
    }
}


- (id) init {
    if ((self = [super init])) {
        self.tabBarItem.image = [UIImage imageNamed:@"DVD.png"];
        [self setupTitle];
    }

    return self;
}


- (void) loadView {
    [super loadView];

    if (dvdViewController == nil) {
        self.dvdViewController = [[[DVDViewController alloc] init] autorelease];
        [self pushViewController:dvdViewController animated:NO];
    }
}


- (Movie*) movieForTitle:(NSString*) canonicalTitle {
    for (Movie* movie in self.model.dvdCache.movies) {
        if ([movie.canonicalTitle isEqual:canonicalTitle]) {
            return movie;
        }
    }

    return [super movieForTitle:canonicalTitle];
}


- (void) majorRefresh {
    [self setupTitle];
    [super majorRefresh];
}

@end
