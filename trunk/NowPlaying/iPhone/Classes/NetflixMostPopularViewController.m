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

#import "Model.h"
#import "MutableNetflixCache.h"
#import "NetflixMostPopularMoviesViewController.h"
#import "OperationQueue.h"


@interface NetflixMostPopularViewController()
@property (retain) NSDictionary* titleToCount;
@end


@implementation NetflixMostPopularViewController

@synthesize titleToCount;

- (void) dealloc {
    self.titleToCount = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.title = NSLocalizedString(@"Most Popular", nil);
    }

    return self;
}


- (Model*) model {
    return [Model model];
}


- (void) initializeData {
    NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
    for (NSString* title in [NetflixCache mostPopularTitles]) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        {
            NSInteger count = [self.model.netflixCache movieCountForRSSTitle:title];
            if (count > 0) {
                [dictionary setObject:[NSNumber numberWithInt:count] forKey:title];
            }
        }
        [pool release];
    }
    self.titleToCount = dictionary;
}


- (void) minorRefreshWorker {
}


- (void) majorRefreshWorker {
    [self initializeData];
    [self reloadTableViewData];
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
#ifdef IPHONE_OS_VERSION_3
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
#else
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
#endif

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

#ifdef IPHONE_OS_VERSION_3
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.minimumFontSize = 12;
#endif
    }

    NSString* title = [[NetflixCache mostPopularTitles] objectAtIndex:indexPath.section];
    NSNumber* count = [titleToCount objectForKey:title];

#ifdef IPHONE_OS_VERSION_3
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ (%@)", nil), title, count];
#else
    cell.text = [NSString stringWithFormat:NSLocalizedString(@"%@ (%@)", nil), title, count];
#endif

    return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSString* title = [[NetflixCache mostPopularTitles] objectAtIndex:indexPath.section];

    NetflixMostPopularMoviesViewController* controller = [[[NetflixMostPopularMoviesViewController alloc] initWithCategory:title] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0 && titleToCount.count == 0) {
        if ([[OperationQueue operationQueue] hasPriorityOperations]) {
            return NSLocalizedString(@"Downloading data", nil);
        }

        return self.model.netflixCache.noInformationFound;
    }

    return nil;
}

@end