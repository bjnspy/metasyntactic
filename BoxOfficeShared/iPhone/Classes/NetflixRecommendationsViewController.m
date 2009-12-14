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

#import "NetflixRecommendationsViewController.h"

#import "Model.h"
#import "NetflixGenreRecommendationsViewController.h"

@interface NetflixRecommendationsViewController()
@property (retain) NetflixAccount* account;
@property (retain) NSArray* genres;
@property (retain) MultiDictionary* genreToMovies;
@end


@implementation NetflixRecommendationsViewController

@synthesize account;
@synthesize genres;
@synthesize genreToMovies;

- (void) dealloc {
  self.account = nil;
  self.genres = nil;
  self.genreToMovies = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.title = LocalizedString(@"Recommendations", nil);
  }

  return self;
}


- (NetflixCache*) netflixCache {
  return [NetflixCache cache];
}


- (NetflixFeedCache*) netflixFeedCache {
  return [NetflixFeedCache cache];
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  self.account = [[NetflixAccountCache cache] currentAccount];
  MutableMultiDictionary* dictionary = [MutableMultiDictionary dictionary];

  NSMutableSet* set = [NSMutableSet set];
  Queue* queue = [self.netflixFeedCache queueForKey:[NetflixConstants recommendationKey] account:account];
  for (Movie* movie in queue.movies) {
    if (movie.genres.count > 0) {
      NSString* genre = movie.genres.firstObject;

      [dictionary addObject:movie forKey:genre];
      [set addObject:genre];
    }
  }

  self.genreToMovies = dictionary;
  self.genres = [[set allObjects] sortedArrayUsingSelector:@selector(compare:)];
}


- (void) didReceiveMemoryWarningWorker {
  [super didReceiveMemoryWarningWorker];
  self.genreToMovies = [MultiDictionary dictionary];
  self.genres = [NSArray array];
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  NSString* genre = [genres objectAtIndex:indexPath.row];

  NetflixGenreRecommendationsViewController* controller =
  [[[NetflixGenreRecommendationsViewController alloc] initWithGenre:genre] autorelease];

  [self.navigationController pushViewController:controller animated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 1;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
  return genres.count;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  UITableViewCell* cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];

  NSString* genre = [genres objectAtIndex:indexPath.row];
  NSInteger count = [[genreToMovies objectsForKey:genre] count];
  cell.textLabel.text =
  [NSString stringWithFormat:
   LocalizedString(@"%@ (%@)", nil),
   genre, [NSNumber numberWithInteger:count]];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (genres.count == 0) {
    return [NetflixCache noInformationFound];
  }

  return nil;
}


@end
