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


- (id) init {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.title = LocalizedString(@"Most Popular", nil);
  }

  return self;
}


- (NetflixRssCache*) netflixRssCache {
  return [NetflixRssCache cache];
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  NSMutableDictionary* dictionary = [NSMutableDictionary dictionary];
  for (NSString* title in [NetflixRssCache mostPopularTitles]) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    {
      NSInteger count = [self.netflixRssCache movieCountForRSSTitle:title];
      if (count > 0) {
        [dictionary setObject:[NSNumber numberWithInteger:count] forKey:title];
      }
    }
    [pool release];
  }
  self.titleToCount = dictionary;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return MAX([[NetflixRssCache mostPopularTitles] count], 1);
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
  NSString* title = [[NetflixRssCache mostPopularTitles] objectAtIndex:section];
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

  NSString* title = [[NetflixRssCache mostPopularTitles] objectAtIndex:indexPath.section];
  NSNumber* count = [titleToCount objectForKey:title];

  cell.textLabel.text = [NSString stringWithFormat:LocalizedString(@"%@ (%@)", nil), title, count];

  return cell;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  NSString* title = [[NetflixRssCache mostPopularTitles] objectAtIndex:indexPath.section];

  NetflixMostPopularMoviesViewController* controller = [[[NetflixMostPopularMoviesViewController alloc] initWithCategory:title] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (section == 0 && titleToCount.count == 0) {
    if ([[OperationQueue operationQueue] hasPriorityOperations]) {
      return LocalizedString(@"Downloading data", nil);
    }

    return [NetflixCache noInformationFound];
  }

  return nil;
}

@end
