// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "NetflixFeedsViewController.h"

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


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 1;
}


- (void) ensureAccount {
  self.account = [[NetflixAccountCache cache] currentAccount];
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];

  [self ensureAccount];
}


- (NSArray*) feeds {
  [self ensureAccount];
  NSArray* feeds = [[NetflixFeedCache cache] feedsForAccount:account];

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
  cell.textLabel.text = [[NetflixCache cache] titleForKey:feed.key account:account];
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
