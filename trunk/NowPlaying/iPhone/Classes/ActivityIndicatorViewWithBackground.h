//
//  ActivityViewWithBackground.h
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface ActivityIndicatorViewWithBackground : UIView {
    UIImageView* imageView;
    UIActivityIndicatorView* activityIndicator;
}

@property (retain) UIImageView* imageView;
@property (retain) UIActivityIndicatorView* activityIndicator;

- (void) stopAnimating;

@end
