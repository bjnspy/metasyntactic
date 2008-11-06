//
//  PostersViewController.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TappableScrollViewDelegate.h"

@interface PostersViewController : UIViewController<TappableScrollViewDelegate, UIScrollViewDelegate> {
    AbstractNavigationController* navigationController;
    
    NSLock* downloadCoverGate;
    Movie* movie;
    
    NSInteger posterCount;
    NSMutableArray* pageViews;
    NSInteger currentPage;

    UINavigationBar* toolBar;
    BOOL toolBarHidden;
    BOOL shutdown;
    
    CGRect smallPosterFrame;
}

@property (assign) AbstractNavigationController* navigationController;
@property (retain) NSLock* downloadCoverGate;
@property (retain) Movie* movie;
@property (retain) NSMutableArray* pageViews;
@property (retain) UINavigationBar* toolBar;


- (id) initWithNavigationController:(AbstractNavigationController*) navigationController
                              movie:(Movie*) movie
                        posterCount:(NSInteger) posterCount
                   smallPosterFrame:(CGRect) smallPosterFrame;

- (void) hideToolBar:(BOOL) hidden;

@end
