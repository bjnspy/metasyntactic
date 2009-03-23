//
//  NetflixSearchDisplayController.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NetflixSearchDisplayController.h"

#import "AbstractNavigationController.h"
#import "NetflixSearchEngine.h"

@implementation NetflixSearchDisplayController

- (id)initNavigationController:(AbstractNavigationController*) navigationController_
                     searchBar:(UISearchBar*) searchBar_
            contentsController:(UIViewController*) viewController_ {
    if (self = [super initNavigationController:navigationController_ searchBar:searchBar_ contentsController:viewController_]) {
        searchBar_.placeholder = NSLocalizedString(@"Search Netflix", nil);
    }
    
    return self;
}


- (AbstractSearchEngine*) createSearchEngine {
    return [NetflixSearchEngine engineWithModel:navigationController.model
                                delegate:self];
}

@end
