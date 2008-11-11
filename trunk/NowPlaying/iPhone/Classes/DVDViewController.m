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

#import "DVDViewController.h"

#import "DVDCache.h"
#import "DVDCell.h"
#import "DVDNavigationController.h"
#import "DVDTypeViewController.h"
#import "NowPlayingModel.h"
#import "TappableLabel.h"

@interface DVDViewController()
@property (retain) UIView* titleView;
@property (retain) UIToolbar* toolbar;
@property (retain) UISegmentedControl* segmentedControl;
@end


@implementation DVDViewController

@synthesize titleView;
@synthesize toolbar;
@synthesize segmentedControl;

- (void) dealloc {
    self.titleView = nil;
    self.toolbar = nil;
    self.segmentedControl = nil;

    [super dealloc];
}


- (NSArray*) movies {
    NSMutableArray* result = [NSMutableArray array];
    [result addObjectsFromArray:self.model.dvdCache.movies];
    return result;
}


- (BOOL) sortingByTitle {
    return self.model.dvdMoviesSortingByTitle;
}


- (BOOL) sortingByReleaseDate {
    return self.model.dvdMoviesSortingByReleaseDate;
}


- (BOOL) sortingByScore {
    return NO;
}


- (BOOL) spaceForActivityIndicator {
    return NO;
}


- (int(*)(id,id,void*)) sortByReleaseDateFunction {
    return compareMoviesByReleaseDateAscending;
}


- (void) onSortOrderChanged:(id) sender {
    self.model.dvdMoviesSelectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    [self refresh];
}


- (id) initWithNavigationController:(DVDNavigationController*) controller {
    if (self = [super initWithNavigationController:controller]) {
    }

    return self;
}

/*
- (UISegmentedControl*) createSegmentedControl {
    UISegmentedControl* control = [[[UISegmentedControl alloc] initWithItems:
                                    [NSArray arrayWithObjects:
                                     NSLocalizedString(@"Release", nil),
                                     NSLocalizedString(@"Title", nil), nil]] autorelease];
    
    control.segmentedControlStyle = UISegmentedControlStyleBar;
    control.selectedSegmentIndex = self.model.dvdMoviesSelectedSegmentIndex;
    
    [control addTarget:self
                action:@selector(onSortOrderChanged:)
      forControlEvents:UIControlEventValueChanged];
    
    [control sizeToFit];
    
    CGRect controlFrame = control.frame;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        controlFrame.origin.y = 4;
    } else {
        controlFrame.origin.y = 7;
    }
    control.frame = controlFrame;
    
    return control;
}


- (UIToolbar*) createToolbar {
    UIBarButtonItem* dvdButton = [[[UIBarButtonItem alloc] initWithTitle:@"DVD" style:UIBarButtonItemStyleDone target:nil action:nil] autorelease];
    UIBarButtonItem* widthItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil] autorelease];
    widthItem.width = -8;
    UIBarButtonItem* blurayButton = [[[UIBarButtonItem alloc] initWithTitle:@"Bluray" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    
    UIToolbar* bar = [[[UIToolbar alloc] init] autorelease];
    bar.items = [NSArray arrayWithObjects:dvdButton, widthItem, blurayButton, nil];
    
    [bar sizeToFit];
    
    CGRect barFrame = bar.frame;
    barFrame.origin.y = -1;
    barFrame.origin.x = segmentedControl.frame.size.width;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        barFrame.size.height--;
    }
    
    bar.frame = barFrame;
    
    return bar;
}
*/

/*
- (void) setupTitleView { 
    self.segmentedControl = [self createSegmentedControl];
    self.toolbar = [self createToolbar];

    CGRect barFrame = toolbar.frame;
    CGRect controlFrame = segmentedControl.frame;  
    
    CGFloat height;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        height = 32;
    } else {
        height = 44;
    }
    
    CGRect frame = CGRectMake(0, 0, barFrame.size.width + controlFrame.size.width, height);
    
    self.titleView = [[[UIView alloc] initWithFrame:frame] autorelease];
    
    self.navigationItem.titleView = titleView;

    [titleView addSubview:segmentedControl];
    [titleView addSubview:toolbar];
}
 */
- (UISegmentedControl*) createSegmentedControl {
    UISegmentedControl* control = [[[UISegmentedControl alloc] initWithItems:
                                    [NSArray arrayWithObjects:
                                     NSLocalizedString(@"Release", nil),
                                     NSLocalizedString(@"Title", nil), nil]] autorelease];
    
    control.segmentedControlStyle = UISegmentedControlStyleBar;
    control.selectedSegmentIndex = self.model.dvdMoviesSelectedSegmentIndex;
    
    [control addTarget:self
                action:@selector(onSortOrderChanged:)
      forControlEvents:UIControlEventValueChanged];
    
    CGRect rect = control.frame;
    rect.size.width = 240;
    control.frame = rect;
    
    return control;
}


- (void) loadView {
    [super loadView];
      
    self.segmentedControl = [self createSegmentedControl];
    self.navigationItem.titleView = segmentedControl;
        
    self.title = NSLocalizedString(@"DVD", nil);
    self.tableView.rowHeight = 100;
}


- (void) didReceiveMemoryWarning {
    if (/*navigationController.visible ||*/ visible) {
        return;
    }
    
    self.titleView = nil;
    self.toolbar = nil;
    self.segmentedControl = nil;
    
    [super didReceiveMemoryWarning];
}


- (UITableViewCell*) createCell:(Movie*) movie {
    static NSString* reuseIdentifier = @"DVDCellIdentifier";
    id cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[DVDCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame
                               reuseIdentifier:reuseIdentifier
                                         model:self.model] autorelease];
    }

    [cell setMovie:movie owner:self];
    return cell;
}

/*
- (void) setupFrames {
    CGRect titleFrame = titleView.frame;
    CGRect toolbarFrame = toolbar.frame;
    CGRect controlFrame = segmentedControl.frame;
    
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        titleFrame.size.height = 32;
        toolbarFrame.size.height = 32;
        controlFrame.size.height = 24;
        toolbarFrame.origin.y = 4;
        controlFrame.origin.y = 9;
    } else {
        titleFrame.size.height = 44;
        toolbarFrame.size.height = 44;
        controlFrame.size.height = 30;
        toolbarFrame.origin.y = -1;
        controlFrame.origin.y = 7;
    }
    
    titleView.frame = titleFrame;
    toolbar.frame = toolbarFrame;
    segmentedControl.frame = controlFrame;
}
 */


- (UILabel*) createLabel:(NSString*) text {
    TappableLabel* label = [[[TappableLabel alloc] init] autorelease];
    label.delegate = self;
    label.text = text;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor darkGrayColor];
    [label sizeToFit];
    
    return label;
}



- (void) label:(TappableLabel*) label 
     wasTapped:(NSInteger) tapCount {
    DVDTypeViewController* controller = [[[DVDTypeViewController alloc] initWithDVDViewController:self] autorelease];
    [navigationController pushViewController:controller animated:YES];
}

- (void) setupButtons {
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        self.navigationItem.rightBarButtonItem = nil;
        return;
    }        

    /*
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[ImageCache emptyStarImage] forState:UIControlStateNormal];
    [button setImage:[ImageCache filledStarImage] forState:UIControlStateSelected];
    //[favoriteButton addTarget:self action:@selector(switchFavorite:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = favoriteButton.frame;
    frame.size = [ImageCache emptyStarImage].size;
    frame.size.width += 10;
    frame.size.height += 10;
    favoriteButton.frame = frame;
    */
    /*
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Disc.png"]] autorelease];
    UIBarButtonItem* discButton = [[[UIBarButtonItem alloc] initWithCustomView:imageView] autorelease];

    self.navigationItem.rightBarButtonItem = discButton;
*/
    
    UILabel* dvdLabel = [self createLabel:@"DVD"];
    UILabel* plusLabel = [self createLabel:@"+"];
    UILabel* blurayLabel = [self createLabel:@"Bluray"];
    [blurayLabel sizeToFit];

    CGRect frame = blurayLabel.frame;
    dvdLabel.frame = frame;
    
    frame.origin.y = 10;
    plusLabel.frame = frame;
    
    frame.origin.y = 20;
    blurayLabel.frame = frame;
    
    frame.size.height = frame.origin.y + frame.size.height;
    
    UIView* view = [[[UIView alloc] initWithFrame:frame] autorelease];
    
    [view addSubview:dvdLabel];
    [view addSubview:plusLabel];
    [view addSubview:blurayLabel];
        
    UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithCustomView:view] autorelease];
    self.navigationItem.rightBarButtonItem = item;
    //    UIButton* dvdButton = [[[UIButton alloc] initWithFrame:<#(CGRect)frame#>
    //  UIView* buttonView = [
    // [[[UIBarButtonItem alloc] initWithCustomView:<#(UIView *)customView#>];
    
    //[self setupTitleView];
}


- (void) refresh {
    self.tableView.rowHeight = 100;
    [self setupButtons];
    [super refresh];
}


- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation{
    //self.navigationItem.rightBarButtonItem = nil;
}

/*
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation {
    [self setupFrames];
    
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}
 */

@end