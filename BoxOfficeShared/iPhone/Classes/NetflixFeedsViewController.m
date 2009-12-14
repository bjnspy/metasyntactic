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

#import "NetflixFeedsViewController.h"

#import "Model.h"
#import "NetflixQueueViewController.h"


@interface NetflixFeedsViewController()
@property (retain) NetflixAccount* account;
@property (retain) NSArray* feedKeys;
@end


@implementation NetflixFeedsViewController

@synthesize account;
@synthesize feedKeys;

- (void) dealloc {
  self.account = nil;
  self.feedKeys = nil;

  [super dealloc];
}


- (id) initWithFeedKeys:(NSArray*) feedKeys_
                  title:(NSString*) title_ {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.title = title_;
    self.feedKeys = feedKeys_;
  }

  return self;
}


- (NetflixCache*) netflixCache {
  return [NetflixCache cache];
}


- (NetflixFeedCache*) netflixFeedCache {
  return [NetflixFeedCache cache];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 1;
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];

  self.account = [[NetflixAccountCache cache] currentAccount];
}


- (NSArray*) feeds {
  NSArray* feeds = [self.netflixFeedCache feedsForAccount:account];

  NSMutableArray* result = [NSMutableArray array];
  for (Feed* feed in feeds) {
    if ([feedKeys containsObject:feed.key]) {
      [result addObject:feed];
    }
  }
  return result;
}


- (BOOL) hasFeeds {
  return self.feeds.count > 0;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section {
  return self.feeds.count;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (!self.hasFeeds) {
    return [NetflixCache noInformationFound];
  }

  return nil;
}


- (UITableViewCell*) tableView:(UITableView*) tableView cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

  NSArray* feeds = self.feeds;

  Feed* feed = [feeds objectAtIndex:indexPath.row];

  cell.textLabel.adjustsFontSizeToFitWidth = YES;
  cell.textLabel.minimumFontSize = 12;
  cell.textLabel.text = [self.netflixCache titleForKey:feed.key account:account];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}


- (void) tableView:(UITableView*) tableView didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  NSArray* feeds = self.feeds;

  Feed* feed = [feeds objectAtIndex:indexPath.row];
  NetflixQueueViewController* controller = [[[NetflixQueueViewController alloc] initWithFeedKey:feed.key] autorelease];
  [self.navigationController pushViewController:controller animated:YES];
}

@end
