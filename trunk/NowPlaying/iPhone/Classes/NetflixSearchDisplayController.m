//
//  NetflixSearchDisplayController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetflixSearchDisplayController.h"

#import "AbstractNavigationController.h"
#import "Model.h"
#import "NetflixSearchEngine.h"

@implementation NetflixSearchDisplayController

- (id)initNavigationController:(AbstractNavigationController*) navigationController_
                     searchBar:(UISearchBar*) searchBar_
            contentsController:(UIViewController*) viewController_ {
    if (self = [super initNavigationController:navigationController_ searchBar:searchBar_ contentsController:viewController_]) {
        self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"Both", nil), NSLocalizedString(@"Disc", nil), NSLocalizedString(@"Instant", nil), nil];
        self.searchBar.selectedScopeButtonIndex = self.model.netflixSearchSelectedScopeButtonIndex;
        self.searchBar.placeholder = NSLocalizedString(@"Search Netflix", nil);
    }
    
    return self;
}


- (AbstractSearchEngine*) createSearchEngine {
    return [NetflixSearchEngine engineWithModel:navigationController.model
                                delegate:self];
}


- (void) searchBar:(UISearchBar*) searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    self.model.netflixSearchSelectedScopeButtonIndex = selectedScope;
    [self.searchResultsTableView reloadData];
}

@end
