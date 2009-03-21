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

#import "NetflixMostPopularViewController.h"

#import "AbstractNavigationController.h"
#import "AppDelegate.h"
#import "GlobalActivityIndicator.h"
#import "Model.h"
#import "MutableNetflixCache.h"
#import "NetflixMostPopularMoviesViewController.h"

@interface NetflixMostPopularViewController()
@property (retain) NSDictionary* titleToCount;
@end


@implementation NetflixMostPopularViewController

@synthesize titleToCount;

- (void) dealloc {
    self.titleToCount = nil;

    [super dealloc];
}


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController_ {
    if (self = [super initWithStyle:UITableViewStylePlain navigationController:navigationController_]) {
        self.title = NSLocalizedString(@"Most Popular", nil);
    }

    return self;
}


- (void) initializeData {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for (NSString* title in [NetflixCache mostPopularTitles]) {
        NSInteger count = [self.model.netflixCache movieCountForRSSTitle:title];
        if (count > 0) {
            [dictionary setObject:[NSNumber numberWithInt:count] forKey:title];
        }
    }
    self.titleToCount = dictionary;
}


- (void) majorRefresh {
    [self initializeData];
    [self reloadTableViewData];
}


- (void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[AppDelegate globalActivityView]] autorelease];
    [self majorRefresh];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation {
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        return YES;
    }

    return self.model.screenRotationEnabled;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return MAX([[NetflixCache mostPopularTitles] count], 1);
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    NSString* title = [[NetflixCache mostPopularTitles] objectAtIndex:section];
    NSNumber* count = [titleToCount objectForKey:title];

    return count == nil ? 0 : 1;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString* reuseIdentifier = @"reuseIdentifier";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumFontSize = 12;
    }

    NSString* title = [[NetflixCache mostPopularTitles] objectAtIndex:indexPath.section];
    NSNumber* count = [titleToCount objectForKey:title];

    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ (%@)", nil), title, count];
    return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* title = [[NetflixCache mostPopularTitles] objectAtIndex:indexPath.section];

    NetflixMostPopularMoviesViewController* controller = [[[NetflixMostPopularMoviesViewController alloc] initWithNavigationController:navigationController category:title] autorelease];
    [navigationController pushViewController:controller animated:YES];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0 && titleToCount.count == 0) {
        if ([GlobalActivityIndicator hasBackgroundTasks]) {
            return NSLocalizedString(@"Downloading data", nil);
        }

        return self.model.netflixCache.noInformationFound;
    }

    return nil;
}

@end