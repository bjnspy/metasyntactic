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

#import "AbstractMovieListViewController.h"

#import "BookmarkCache.h"
#import "LocalSearchDisplayController.h"
#import "Model.h"
#import "MoviesNavigationController.h"

@interface AbstractMovieListViewController()
@property (retain) UISearchBar* searchBar;
@property (retain) UISegmentedControl* segmentedControl;
@property (retain) NSArray* sectionTitles;
@property (retain) MultiDictionary* sectionTitleToContentsMap;
@property (retain) NSArray* indexTitles;
@end


@implementation AbstractMovieListViewController

@synthesize searchBar;
@synthesize segmentedControl;
@synthesize sectionTitles;
@synthesize sectionTitleToContentsMap;
@synthesize indexTitles;

- (void) dealloc {
  self.searchBar = nil;
  self.segmentedControl = nil;
  self.sectionTitles = nil;
  self.sectionTitleToContentsMap = nil;
  self.indexTitles = nil;

  [super dealloc];
}


- (NSArray*) movies AbstractMethod;


- (BOOL) sortingByTitle AbstractMethod;


- (BOOL) sortingByReleaseDate AbstractMethod;


- (BOOL) sortingByScore AbstractMethod;;


- (BOOL) sortingByFavorite AbstractMethod;


- (void) onSortOrderChanged:(id) sender AbstractMethod;


- (UITableViewCell*) createCell:(Movie*) movie AbstractMethod;


- (NSInteger(*)(id,id,void*)) sortByReleaseDateFunction AbstractMethod;


- (UISegmentedControl*) createSegmentedControl AbstractMethod;


- (void) removeUnusedSectionTitles {
  NSMutableArray* array = [NSMutableArray arrayWithArray:sectionTitles];

  for (NSInteger i = array.count - 1; i >= 0; --i) {
    NSString* title = [array objectAtIndex:i];

    if ([[sectionTitleToContentsMap objectsForKey:title] count] == 0) {
      [array removeObjectAtIndex:i];
    }
  }

  self.sectionTitles = array;
}


- (unichar) firstCharacter:(NSString*) string {
  unichar c1 = toupper([string characterAtIndex:0]);
  if (c1 < 'A' || c1 > 'Z') {
    // remove an accent if it exists.
    NSString* asciiString = [StringUtilities asciiString:string];
    unichar c2 = toupper([asciiString characterAtIndex:0]);
    if (c2 >= 'A' && c2 <= 'Z') {
      return c2;
    }
  }

  return c1;
}


- (void) sortMoviesByTitle {
  NSArray* sortedMovies = [self.movies sortedArrayUsingFunction:compareMoviesByTitle context:nil];

  MutableMultiDictionary* map = [MutableMultiDictionary dictionary];

  for (Movie* movie in sortedMovies) {
    NSString* title = movie.displayTitle;
    unichar firstChar = [self firstCharacter:title];

    if ([LocaleUtilities isJapanese]) {
      if (CFCharacterSetIsCharacterMember(CFCharacterSetGetPredefined(kCFCharacterSetLetter), firstChar)) {
        NSString* sectionTitle = [[[NSString alloc] initWithCharacters:&firstChar length:1] autorelease];
        [map addObject:movie forKey:sectionTitle];
      } else {
        [map addObject:movie forKey:@"#"];
      }
    } else {
      if (firstChar >= 'A' && firstChar <= 'Z') {
        NSString* sectionTitle = [NSString stringWithFormat:@"%c", firstChar];
        [map addObject:movie forKey:sectionTitle];
      } else {
        [map addObject:movie forKey:@"#"];
      }
    }
  }

  if ([LocaleUtilities isJapanese]) {
    NSMutableArray* array = [NSMutableArray arrayWithArray:sectionTitleToContentsMap.allKeys];
    [array sortUsingSelector:@selector(compare:)];
    [array insertObject:[StringUtilities starString] atIndex:0];

    self.sectionTitles = array;
  } else {
    self.sectionTitles = self.indexTitles;
  }

  self.sectionTitleToContentsMap = map;
}


- (void) sortMoviesByScore {
  NSArray* sortedMovies = [self.movies sortedArrayUsingFunction:compareMoviesByScore context:[Model model]];

  NSString* moviesString = LocalizedString(@"Movies", nil);

  self.sectionTitles = [NSMutableArray arrayWithObject:moviesString];
  MutableMultiDictionary* map = [MutableMultiDictionary dictionary];

  for (Movie* movie in sortedMovies) {
    [map addObject:movie forKey:moviesString];
  }

  self.sectionTitleToContentsMap = map;
}


- (void) sortMoviesByReleaseDate {
  NSArray* sortedMovies = [self.movies sortedArrayUsingFunction:self.sortByReleaseDateFunction context:[Model model]];

  NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
  [formatter setDateStyle:kCFDateFormatterMediumStyle];
  [formatter setTimeStyle:kCFDateFormatterNoStyle];

  NSDate* today = [DateUtilities today];

  NSString* starString = [StringUtilities starString];

  NSMutableArray* array = [NSMutableArray array];
  MutableMultiDictionary* map = [MutableMultiDictionary dictionary];

  for (Movie* movie in sortedMovies) {
    NSString* title = LocalizedString(@"Unknown Release Date", nil);
    NSDate* releaseDate = [[Model model] releaseDateForMovie:movie];

    if (releaseDate != nil) {
      if ([releaseDate compare:today] == NSOrderedDescending) {
        title = [DateUtilities formatFullDate:releaseDate];
      } else {
        title = [DateUtilities timeSinceNow:releaseDate];
      }
    }

    [map addObject:movie forKey:title];

    if (![array containsObject:title]) {
      [array addObject:title];
    }
  }
  self.sectionTitles = array;

  for (NSString* key in map.allKeys) {
    if (![starString isEqual:key]) {
      NSMutableArray* values = [map mutableObjectsForKey:key];
      [values sortUsingFunction:compareMoviesByScore context:[Model model]];
    }
  }

  self.sectionTitleToContentsMap = map;
}


- (void) sortMoviesByFavorite {
  NSArray* sortedMovies = [self.movies sortedArrayUsingFunction:compareMoviesByTitle context:nil];

  MutableMultiDictionary* map = [MutableMultiDictionary dictionary];

  for (Movie* movie in sortedMovies) {
    if ([[BookmarkCache cache] isBookmarked:movie]) {
      [map addObject:movie forKey:[StringUtilities starString]];
    }
  }

  self.sectionTitles = [NSArray arrayWithObject:[StringUtilities starString]];
  self.sectionTitleToContentsMap = map;
}


- (void) setupIndexTitles {
  if ([LocaleUtilities isJapanese]) {
    self.indexTitles = nil;
  } else {
    self.indexTitles = [NSArray arrayWithObjects:
                        @"#", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H",
                        @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q",
                        @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
  }
}


- (void) sortMovies {
  [self setupIndexTitles];
  self.sectionTitles = [NSMutableArray array];

  if (self.sortingByTitle) {
    [self sortMoviesByTitle];
  } else if (self.sortingByReleaseDate) {
    [self sortMoviesByReleaseDate];
  } else if (self.sortingByScore) {
    [self sortMoviesByScore];
  } else if (self.sortingByFavorite) {
    [self sortMoviesByFavorite];
  }

  [self removeUnusedSectionTitles];

  if (sectionTitles.count == 0) {
    if (self.sortingByFavorite) {
      self.sectionTitles = [NSArray arrayWithObject:LocalizedString(@"No bookmarked movies", nil)];
    } else {
      self.sectionTitles = [NSArray arrayWithObject:[Model model].noInformationFound];
    }
  }
}


- (id) init {
  if ((self = [self initWithStyle:UITableViewStylePlain])) {
  }

  return self;
}


- (void) initializeInfoButton {
  self.navigationItem.leftBarButtonItem = [self createInfoButton:@selector(showInfo)];
}


- (void) initializeSearchDisplay {
  self.searchBar = [[[UISearchBar alloc] init] autorelease];
  [searchBar sizeToFit];
  self.tableView.tableHeaderView = searchBar;

  self.searchDisplayController = [[[LocalSearchDisplayController alloc] initWithSearchBar:searchBar
                                                                       contentsController:self] autorelease];
}


- (void) loadView {
  [super loadView];

  [self initializeSearchDisplay];
  [self initializeInfoButton];

  self.segmentedControl = [self createSegmentedControl];
  self.navigationItem.titleView = segmentedControl;
}


- (void) didReceiveMemoryWarningWorker {
  [super didReceiveMemoryWarningWorker];
  self.sectionTitles = nil;
  self.sectionTitleToContentsMap = nil;
  self.indexTitles = nil;
  self.segmentedControl = nil;
}


- (BOOL) tryScrollToCurrentDate {
  if (self.sortingByReleaseDate) {
    if (scrollToCurrentDateOnRefresh) {
      scrollToCurrentDateOnRefresh = NO;

      NSArray* movies = [self.movies sortedArrayUsingFunction:self.sortByReleaseDateFunction context:[Model model]];
      NSDate* today = [DateUtilities today];

      NSDate* date = nil;
      for (Movie* movie in movies) {
        NSDate* releaseDate = [[Model model] releaseDateForMovie:movie];

        if (releaseDate != nil) {
          if ([releaseDate compare:today] == NSOrderedDescending) {
            date = releaseDate;
            break;
          }
        }
      }

      if (date != nil) {
        NSString* title = [DateUtilities formatFullDate:date];
        NSInteger section = [sectionTitles indexOfObject:title];

        if (section >= 0 && section < sectionTitles.count) {
          [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
          return YES;
        }
      }
    }
  }

  return NO;
}


- (void) onBeforeReloadTableViewData {
  [super onBeforeReloadTableViewData];
  [self sortMovies];
}


- (void) onAfterReloadTableViewData {
  [super onAfterReloadTableViewData];
  [self tryScrollToCurrentDate];
}


- (BOOL) outOfBounds:(NSIndexPath*) indexPath {
  if (indexPath.section < 0 || indexPath.section >= sectionTitles.count) {
    return YES;
  }

  NSArray* movies = [sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]];
  if (indexPath.row < 0 || indexPath.row >= movies.count) {
    return YES;
  }

  return NO;
}


- (BOOL) shouldShowSectionTitles {
  if (self.sortingByTitle &&
      self.movies.count > 0) {
    return YES;
  }

  return NO;
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
  if ([self outOfBounds:indexPath]) {
    return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
  }

  Movie* movie = [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

  UITableViewCell* cell = [self createCell:movie];
  if ([self shouldShowSectionTitles]) {
    cell.accessoryType = UITableViewCellAccessoryNone;
  } else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  return cell;
}


- (CommonNavigationController*) commonNavigationController {
  return (id) self.navigationController;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
  if ([self outOfBounds:indexPath]) {
    return;
  }

  Movie* movie = [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

  [self.commonNavigationController pushMovieDetails:movie animated:YES];
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
  return sectionTitles.count;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
  return [[sectionTitleToContentsMap objectsForKey:[sectionTitles objectAtIndex:section]] count];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
  NSString* title = [sectionTitles objectAtIndex:section];

  if (self.sortingByScore) {
    // Hide the header if sorting by score and we have no bookmarked movies
    if (sectionTitles.count == 1 && [LocalizedString(@"Movies", nil) isEqual:title]) {
      return nil;
    }
  } else if (self.sortingByFavorite) {
    if ([title isEqual:[StringUtilities starString]]) {
      return nil;
    }
  }

  return title;
}


- (NSArray*) sectionIndexTitlesForTableView:(UITableView*) tableView {
  if ([self shouldShowSectionTitles]) {
    return indexTitles;
  }

  return nil;
}


- (NSInteger)           tableView:(UITableView*) tableView
      sectionForSectionIndexTitle:(NSString*) title
                          atIndex:(NSInteger) index {
  unichar firstChar = [title characterAtIndex:0];

  if ([UITableViewIndexSearch isEqual:title]) {
    [self.tableView scrollRectToVisible:searchBar.frame animated:NO];
    return -1;
  } else if (firstChar == '#') {
    return [sectionTitles indexOfObject:@"#"];
  } else if (firstChar == [StringUtilities starCharacter]) {
    return [sectionTitles indexOfObject:[StringUtilities starString]];
  } else {
    for (unichar c = firstChar; c >= 'A'; c--) {
      NSString* s = [NSString stringWithFormat:@"%c", c];

      NSInteger result = [sectionTitles indexOfObject:s];
      if (result != NSNotFound) {
        return result;
      }
    }

    return NSNotFound;
  }
}


- (void) showInfo {
  [self.commonNavigationController pushInfoControllerAnimated:YES];
}


- (void) onTabBarItemSelected {
  [searchDisplayController setActive:NO animated:YES];
}

@end
