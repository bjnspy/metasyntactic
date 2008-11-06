//
//  NonClippingView.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NonClippingView.h"

@implementation NonClippingView

- (void) dealloc {
    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void) didMoveToSuperview {
    for (UIView* view = self; view != nil; view = view.superview) {
        view.clipsToBounds = NO;
    }
}

@end