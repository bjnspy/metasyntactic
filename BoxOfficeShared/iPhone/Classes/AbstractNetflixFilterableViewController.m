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

#import "AbstractNetflixFilterableViewController.h"

#import "CommonNavigationController.h"
#import "Model.h"
#import "NetflixCell.h"

@interface AbstractNetflixFilterableViewController()
@property (retain) NSArray* movies;
@property (retain) NSArray* filteredMovies;
@end


@implementation AbstractNetflixFilterableViewController

@synthesize movies;
@synthesize filteredMovies;

- (void) dealloc {
  self.movies = nil;
  self.filteredMovies = nil;
  
  [super dealloc];
}


- (Model*) model {
  return [Model model];
}


- (UIView*) createHeaderView {
  NSArray* items = [NSArray arrayWithObjects:
                    NSLocalizedString(@"All", nil),
                    NSLocalizedString(@"DVD", nil),
                    NSLocalizedString(@"Blu-ray", nil),
                    NSLocalizedString(@"Instant", nil), nil];
  UISegmentedControl* segmentedControl = [[[UISegmentedControl alloc] initWithItems:items] autorelease];
  segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
  segmentedControl.tintColor = self.navigationController.navigationBar.tintColor;
  segmentedControl.selectedSegmentIndex = self.model.netflixFilterSelectedSegmentIndex;
  
  [segmentedControl addTarget:self
                       action:@selector(onFilterChanged:)
             forControlEvents:UIControlEventValueChanged];
  
  UINavigationBar* navBar = [[[UINavigationBar alloc] init] autorelease];
  navBar.tintColor = self.navigationController.navigationBar.tintColor;
  
  UINavigationItem* item = [[[UINavigationItem alloc] init] autorelease];
  item.titleView = segmentedControl;
  [navBar setItems:[NSArray arrayWithObject:item]];
  
  [navBar sizeToFit];
  
  CGRect frame = segmentedControl.frame;
  frame.size.width = 310;
  segmentedControl.frame = frame;
  
  return navBar;
}


- (void) onFilterChanged:(UISegmentedControl*) control {
  [self.model setNetflixFilterSelectedSegmentIndex:control.selectedSegmentIndex];
  [self majorRefresh];
}


- (BOOL) filter:(NSInteger) filter movie:(Movie*) movie {
  if (filter == 0) {
    return YES;
  }
  
  if (filter == 1) {
    return [[self.model.netflixCache formatsForMovie:movie] containsObject:@"DVD"];
  }
  
  if (filter == 2) {
    return [[self.model.netflixCache formatsForMovie:movie] containsObject:@"Blu-ray"];
  }
  
  if (filter == 3) {
    return [[self.model.netflixCache formatsForMovie:movie] containsObject:@"instant"];
  }
  
  return NO;
}


- (NSArray*) determineMovies {
  @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  
  self.tableView.tableHeaderView = [self createHeaderView];
  
  self.tableView.rowHeight = 100;
  
  NSArray* array = [self determineMovies];
  NSMutableArray* filteredArray = [NSMutableArray array];
  
  NSInteger filter = self.model.netflixFilterSelectedSegmentIndex;
  for (Movie* movie in array) {
    if ([self filter:filter movie:movie]) {
      [filteredArray addObject:movie];
    }
  }

  self.movies = array;
  self.filteredMovies = filteredArray;
}


- (void) didReceiveMemoryWarningWorker {
  [super didReceiveMemoryWarningWorker];
  self.movies = [NSArray array];
  self.filteredMovies = [NSArray array];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
  return filteredMovies.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell*) tableView:(UITableView*) tableView_
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  static NSString* reuseIdentifier = @"reuseIdentifier";
  NetflixCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[NetflixCell alloc] initWithReuseIdentifier:reuseIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
  Movie* movie = [filteredMovies objectAtIndex:indexPath.row];
  [cell setMovie:movie owner:self];
  
  return cell;
}


- (CommonNavigationController*) commonNavigationController {
  return (id) self.navigationController;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  Movie* movie = [filteredMovies objectAtIndex:indexPath.row];
  [self.commonNavigationController pushMovieDetails:movie animated:YES];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  if (filteredMovies.count == 0) {
    if (movies.count == 0) {
      return self.model.netflixCache.noInformationFound;
    } else {
      return LocalizedString(@"No information found", nil);
    }
  }
  
  return nil;
}

@end
