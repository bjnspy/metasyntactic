//
//  PosterView.h
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@class AllMoviesViewController;

@interface PosterView : UIView {
    AllMoviesViewController* controller;
    NSMutableArray* moviesWithPosters;
}

@property (assign) AllMoviesViewController* controller;
@property (retain) NSMutableArray* moviesWithPosters;

+ (PosterView*) viewWithController:(AllMoviesViewController*) controller;

@end
