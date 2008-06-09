//
//  AllTheatersViewController.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "BoxOfficeModel.h"
#import "MultiDictionary.h"

@class TheatersNavigationController;

@interface AllTheatersViewController : UITableViewController {
    TheatersNavigationController* navigationController;
    UISegmentedControl* segmentedControl;
    
    NSArray* sortedTheaters;
    NSMutableArray* sectionTitles;
    MultiDictionary* sectionTitleToContentsMap;
    
    NSArray* alphabeticSectionTitles;

    bool shouldRefresh;
}

@property (assign) TheatersNavigationController* navigationController;
@property (retain) UISegmentedControl* segmentedControl;
@property (retain) NSArray* sortedTheaters;
@property (retain) NSMutableArray* sectionTitles;
@property (retain) MultiDictionary* sectionTitleToContentsMap;
@property (retain) NSArray* alphabeticSectionTitles;

- (id) initWithNavigationController:(TheatersNavigationController*) navigationController;

- (void) refresh;
- (BoxOfficeModel*) model;

@end
