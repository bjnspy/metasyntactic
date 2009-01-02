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

#import "UpcomingAndDVDViewController.h"

#import "BlurayCache.h"
#import "DateUtilities.h"
#import "DVDCache.h"
#import "DVDCell.h"
#import "DVDFilterViewController.h"
#import "DVDNavigationController.h"
#import "IdentitySet.h"
#import "NowPlayingModel.h"
#import "TappableLabel.h"
#import "UpcomingCache.h"
#import "UpcomingAndDVDFilterViewController.h"
#import "UpcomingMovieCell.h"

@interface UpcomingMoviesAndDVDViewController()
@property (retain) IdentitySet* dvds;
@property (retain) IdentitySet* upcomingMovies;
@end


@implementation UpcomingMoviesAndDVDViewController

@synthesize dvds;
@synthesize upcomingMovies;

- (void) dealloc {
    self.dvds = nil;
    self.upcomingMovies = nil;

    [super dealloc];
}


- (NSArray*) movies {
    NSMutableArray* result = [NSMutableArray array];
    self.dvds = [IdentitySet set];
    self.upcomingMovies = [IdentitySet set];

    if (self.model.dvdMoviesShowDVDs) {
        [result addObjectsFromArray:self.model.dvdCache.movies];
        [dvds addObjectsFromArray:self.model.dvdCache.movies];
    }

    if (self.model.dvdMoviesShowBluray) {
        [result addObjectsFromArray:self.model.blurayCache.movies];
        [dvds addObjectsFromArray:self.model.blurayCache.movies];
    }

    if (self.model.upcomingAndDVDShowUpcoming) {
        [result addObjectsFromArray:self.model.upcomingCache.movies];
        [upcomingMovies addObjectsFromArray:self.model.upcomingCache.movies];
    }

    return result;
}


- (id) initWithNavigationController:(AbstractNavigationController*) controller {
    if (self = [super initWithNavigationController:controller]) {
    }

    return self;
}


- (void) setupTitle {
    self.title = NSLocalizedString(@"Coming Soon", nil);
}


- (UITableViewCell*) createCell:(Movie*) movie {
    id cell = nil;
    if ([dvds containsObject:movie]) {
        static NSString* reuseIdentifier = @"DVDCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[DVDCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                   reuseIdentifier:reuseIdentifier
                                             model:self.model] autorelease];
        }
    } else {
        static NSString* reuseIdentifier = @"UpcomingCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (cell == nil) {
            cell = [[[UpcomingMovieCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                                   reuseIdentifier:reuseIdentifier
                                             model:self.model] autorelease];
        }
    }

    [cell setMovie:movie owner:self];
    return cell;
}


- (UIViewController*) createFilterViewController {
    return [[[UpcomingAndDVDFilterViewController alloc] initWithNavigationController:navigationController] autorelease];
}

@end