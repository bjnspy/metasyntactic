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

#import "NetflixRecommendationsViewController.h"

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


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  self.account = [[NetflixAccountCache cache] currentAccount];
  MutableMultiDictionary* dictionary = [MutableMultiDictionary dictionary];

  NSMutableSet* set = [NSMutableSet set];
  Queue* queue = [[NetflixFeedCache cache] queueForKey:[NetflixConstants recommendationKey] account:account];
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
