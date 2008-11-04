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

#if 0

#import "NumbersViewController.h"

#import "ColorCache.h"
#import "GlobalActivityIndicator.h"
#import "ImageCache.h"
#import "Movie.h"
#import "MovieNumbers.h"
#import "NowPlayingModel.h"
#import "NumbersCache.h"
#import "NumbersNavigationController.h"
#import "SettingCell.h"

@implementation NumbersViewController

@synthesize navigationController;
@synthesize segmentedControl;
@synthesize movieNumbers;

- (void) dealloc {
    self.navigationController = nil;
    self.segmentedControl = nil;
    self.movieNumbers = nil;
    
    [super dealloc];
}


- (id) initWithNavigationController:(NumbersNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = controller;
        self.title = NSLocalizedString(@"Numbers", @"Usually translated as 'Statistics'.  This shows the user data about how well the movie is doing in the boxoffice.");
        
        self.segmentedControl = [[[UISegmentedControl alloc] initWithItems:
                                  [NSArray arrayWithObjects:
                                   NSLocalizedString(@"Daily", nil),
                                   NSLocalizedString(@"Weekend", nil),
                                   NSLocalizedString(@"Total", nil), nil]] autorelease];
        
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segmentedControl.selectedSegmentIndex = self.model.numbersSelectedSegmentIndex;
        [segmentedControl addTarget:self
                             action:@selector(onFilterChanged:)
                   forControlEvents:UIControlEventValueChanged];
        
        CGRect rect = segmentedControl.frame;
        rect.size.width = 240;
        segmentedControl.frame = rect;
        
        self.navigationItem.titleView = segmentedControl;
    }
    
    return self;
}


- (void) onFilterChanged:(id) sender {
    self.model.numbersSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    [self refresh];
}


- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:[GlobalActivityIndicator activityView]] autorelease];
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:animated];
    
    [self refresh];
}


NSComparisonResult compareMoviesByTotalGross(id i1, id i2, void* context) {
    MovieNumbers* m1 = i1;
    MovieNumbers* m2 = i2;
    
    if (m1.totalGross > m2.totalGross) {
        return NSOrderedAscending;
    } else if (m1.totalGross < m2.totalGross) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}


- (void) createMovieMap {
    
}


- (void) refresh {
    if (self.model.numbersSortingByDailyGross) {
        self.movieNumbers = self.model.numbersCache.dailyNumbers;
    } else if (self.model.numbersSortingByWeekendGross) {
        self.movieNumbers = self.model.numbersCache.weekendNumbers;
    } else if (self.model.numbersSortingByTotalGross) {
        NSMutableArray* movies = [NSMutableArray arrayWithArray:self.model.numbersCache.dailyNumbers];
        [movies sortUsingFunction:compareMoviesByTotalGross context:NULL];
        self.movieNumbers = movies;
    }
    
    [self createMovieMap];
    
    [self.tableView reloadData];
}


- (NowPlayingModel*) model {
    return navigationController.model;
}


- (NowPlayingController*) controller {
    return navigationController.controller;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return MAX(1, self.movieNumbers.count);
}


- (BOOL) sortingByTotalGross {
    return self.model.numbersSortingByTotalGross;
}

- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    if (self.movieNumbers.count == 0) {
        return 0;
    }
    
    if (self.sortingByTotalGross) {
        return 6;
    } else {
        return 7;
    }
}


- (UITableViewCell*) headerCellForSection:(NSInteger) section {
    static NSString* reuseIdentifier = @"NumbersViewTitleCellIdentifier";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
        
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(43, 16, 0, 0)] autorelease];
        label.font = [UIFont systemFontOfSize:12];
        label.tag = 1;
        
        [cell addSubview:label];
    }
    
    MovieNumbers* numbers = [self.movieNumbers objectAtIndex:section];
    UILabel* label = (id)[cell viewWithTag:1];
    
    NSString* displayTitle = [Movie makeDisplay:numbers.canonicalTitle];
    
    if (self.sortingByTotalGross) {
        label.hidden = YES;
        cell.image = nil;
        cell.text = displayTitle;
    } else {
        label.hidden = NO;
        
        if (numbers.previousRank == 0 || numbers.currentRank == numbers.previousRank) {
            cell.image = [ImageCache neutralSquare];
            cell.text = displayTitle;
            label.text = nil;
        } else {
            cell.text = [NSString stringWithFormat:@"   %@", [Movie makeDisplay:numbers.canonicalTitle]];
            
            if (numbers.currentRank > numbers.previousRank) {
                cell.image = [ImageCache upArrow];
                label.text = [NSString stringWithFormat:@"+%d", numbers.currentRank - numbers.previousRank];
            } else {
                cell.image = [ImageCache downArrow];
                label.text = [NSString stringWithFormat:@"-%d", numbers.previousRank - numbers.currentRank];
            }
        }
        
        [label sizeToFit];
    }
    
    return cell;
}


- (NSNumberFormatter*) currencyFormatter {
    NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.maximumFractionDigits = 0;
    formatter.currencySymbol = @"";
    return formatter;
}


- (NSString*) formatCurrency:(NSNumber*) number {
    NSString* value = [self.currencyFormatter stringFromNumber:number];
    return [NSString stringWithFormat:@"$%@", value];
}


- (UITableViewCell*) tableView:(UITableView*) tableView
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.row == 0) {
        return [self headerCellForSection:indexPath.section];
    }
    
    static NSString* reuseIdentifier = @"NumbersViewDetailCellIdentifier";
    SettingCell* cell = (id)[self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[SettingCell alloc] initWithFrame:CGRectZero reuseIdentifier:reuseIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(0, -1, 320, 2)] autorelease];
        label.backgroundColor = [UIColor whiteColor];
        label.tag = 1;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [cell.contentView addSubview:label];
    }
    
    UIView* label = [cell viewWithTag:1];
    label.hidden = (indexPath.row == 1);
    
    [cell setValueColor:[ColorCache commandColor]];
    
    MovieNumbers* movie = [self.movieNumbers objectAtIndex:indexPath.section];
    
    NSInteger row = indexPath.row;
    if (self.sortingByTotalGross) {
        row++;
    }
    
    if (row == 1) {
        NSString* value = [self formatCurrency:[NSNumber numberWithInt:movie.currentGross]];
        
        if (self.model.numbersSortingByDailyGross) {
            [cell setKey:NSLocalizedString(@"Daily gross", nil)
                   value:value];
        } else {
            [cell setKey:NSLocalizedString(@"Weekend gross", nil)
                   value:value];
        }
    } else if (row == 2) {
        NSString* value = [self formatCurrency:[NSNumber numberWithInt:movie.totalGross]];
        
        [cell setKey:NSLocalizedString(@"Total gross", nil)
               value:value];
    } else if (row == 3) {
        double change;
        
        if (self.model.numbersSortingByDailyGross) {
            change = [self.model.numbersCache dailyChange:movie];
        } else if (self.model.numbersSortingByWeekendGross) {
            change = [self.model.numbersCache weekendChange:movie];
        } else {
            change = [self.model.numbersCache totalChange:movie];
        }
        
        NSString* value;
        if (IS_RETRIEVING(change)) {
            value = NSLocalizedString(@"Retrieving data...", nil);
            [cell setValueColor:[UIColor grayColor]];
        } else if (IS_NOT_ENOUGH_DATA(change)) {
            value = NSLocalizedString(@"Not enough data", nil);
            [cell setValueColor:[UIColor grayColor]];
        } else {
            NSNumberFormatter* formatter = [[[NSNumberFormatter alloc] init] autorelease];
            formatter.numberStyle = NSNumberFormatterPercentStyle;
            formatter.minimumFractionDigits = 2;
            formatter.maximumFractionDigits = 2;
            value = [formatter stringFromNumber:[NSNumber numberWithDouble:change]];
            
            if (change < 0) {
                [cell setValueColor:[UIColor redColor]];
            } else if (change > 0) {
                [cell setValueColor:[UIColor colorWithHue:120.0/360.0 saturation:0.75 brightness:0.75 alpha:1.0]];
            } else {
                [cell setValueColor:[UIColor grayColor]];
            }
        }
        
        if (self.model.numbersSortingByDailyGross) {
            [cell setKey:NSLocalizedString(@"Daily change", nil)
                   value:value];
        } else if (self.model.numbersSortingByWeekendGross) {
            [cell setKey:NSLocalizedString(@"Weekend change", nil)
                   value:value];
        } else {
            [cell setKey:NSLocalizedString(@"Total change", nil)
                   value:value];
        }
    } else if (row == 4) {
        NSInteger budget = [self.model.numbersCache budgetForMovie:movie];
        NSString* value;
        
        if (budget <= 0) {
            value = NSLocalizedString(@"Unknown", nil);
            [cell setValueColor:[UIColor grayColor]];
        } else {
            value = [self formatCurrency:[NSNumber numberWithInt:budget]];
        }
        
        [cell setKey:NSLocalizedString(@"Budget", nil)
               value:value];
    } else if (row == 5) {
        [cell setKey:NSLocalizedString(@"Days in theater", nil)
               value:[NSString stringWithFormat:@"%d", movie.days]];
    } else if (row == 6) {
        [cell setKey:NSLocalizedString(@"Theaters", nil)
               value:[NSString stringWithFormat:@"%d", movie.theaters]];
    }
    
    return cell;
}


- (CGFloat)         tableView:(UITableView*) tableView
      heightForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.row == 0) {
        return tableView.rowHeight;
    }
    
    return tableView.rowHeight - 16;
}


- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.row == 0) {
        //        NSMutableArray* lowercaseTitles = [NSMutableArray array]
        //       for (
        
        //     index = [[Application differenceEngine] findClosestMatchIndex:movie.canonicalTitle.lowercaseString inArray:lowercaseKeys];
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (movieNumbers.count == 0) {
        return NSLocalizedString(@"Retrieving data...", nil);
    }
    
    return [NSString stringWithFormat:@"#%d", section + 1];
}

@end

#endif