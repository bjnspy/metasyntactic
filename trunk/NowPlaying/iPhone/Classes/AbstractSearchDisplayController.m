//
//  AbstractSearchDisplayController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AbstractSearchDisplayController.h"

#import "AbstractNavigationController.h"
#import "AppDelegate.h"
#import "ApplicationTabBarController.h"
#import "DVDCell.h"
#import "Model.h"
#import "MovieTitleCell.h"
#import "LocalSearchEngine.h"
#import "SearchResult.h"
#import "TheaterNameCell.h"
#import "UpcomingMovieCell.h"

@interface AbstractSearchDisplayController()
@property (assign) AbstractNavigationController* navigationController;
@property (retain) AbstractSearchEngine* searchEngineData;
@property (retain) SearchResult* searchResult;
@end

@implementation AbstractSearchDisplayController

@synthesize navigationController;
@synthesize searchEngineData;
@synthesize searchResult;

- (void) dealloc {
    self.navigationController = nil;
    self.searchEngineData = nil;
    self.searchResult = nil;
    
    [super dealloc];
}


- (Model*) model {
    return navigationController.model;
}


- (Controller*) controller {
    return navigationController.controller;
}


- (id)initNavigationController:(AbstractNavigationController*) navigationController_
                     searchBar:(UISearchBar *)searchBar_
            contentsController:(UIViewController *)viewController_ {
    if (self = [super initWithSearchBar:searchBar_ contentsController:viewController_]) {
        self.navigationController = navigationController_;
        
        self.delegate = self;
        self.searchResultsDataSource = self;
        self.searchResultsDelegate = self;
        
        self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.searchBar.showsScopeBar = YES;
    }
    
    return self;
}


- (AbstractSearchEngine*) createSearchEngine {
    @throw [NSException exceptionWithName:@"ImproperSubclassing" reason:@"" userInfo:nil];
}


- (AbstractSearchEngine*) searchEngine {
    if (searchEngineData == nil) {
        self.searchEngineData = [self createSearchEngine];
    }
    
    return searchEngineData;
}


- (BOOL) searching {
    NSString* searchText = self.searchBar.text;
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return searchText.length > 0 && ![searchText isEqual:searchResult.value];
}


- (void) reportResult:(SearchResult*) result {
    NSAssert([NSThread isMainThread], nil);
    self.searchResult = result;
    [self.searchResultsTableView reloadData];
}


- (BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchText {
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (searchText.length == 0) {
        [self.searchEngine invalidateExistingRequests];
        self.searchResult = nil;
        [self.searchResultsTableView reloadData];
        return YES;
    } else {
        [self.searchEngine submitRequest:searchText];
        return NO;
    }
}


- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 1;
}


- (NSInteger)     tableView:(UITableView*) tableView
      numberOfRowsInSection:(NSInteger) section {
    return 0;
}


- (UITableViewCell*) tableView:(UITableView*) tableView_
         cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    return [[[UITableViewCell alloc] init] autorelease];
}

@end