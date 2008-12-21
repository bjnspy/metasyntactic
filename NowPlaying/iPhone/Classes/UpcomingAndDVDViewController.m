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
#import "NowPlayingModel.h"
#import "TappableLabel.h"
#import "UpcomingCache.h"

@interface UpcomingMoviesAndDVDViewController()
@end


@implementation UpcomingMoviesAndDVDViewController

- (void) dealloc {
    [super dealloc];
}


- (NSArray*) movies {
    NSMutableArray* result = [NSMutableArray array];

    if (self.model.dvdMoviesShowDVDs) {
        [result addObjectsFromArray:self.model.dvdCache.movies];
    }

    if (self.model.dvdMoviesShowBluray) {
        [result addObjectsFromArray:self.model.blurayCache.movies];
    }

    [result addObjectsFromArray:self.model.upcomingCache.movies];

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
    static NSString* reuseIdentifier = @"UpcomingAndDVDCellIdentifier";
    id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                               reuseIdentifier:reuseIdentifier
                                         model:self.model] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}

@end