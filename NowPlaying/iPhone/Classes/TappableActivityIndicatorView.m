//
//  TappableActivityIndicatorView.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 1/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TappableActivityIndicatorView.h"

#import "TappableActivityIndicatorViewDelegate.h"

@implementation TappableActivityIndicatorView

@synthesize delegate;

- (void) dealloc {
    self.delegate = nil;
    [super dealloc];
}


- (id)initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style {
    if (self = [super initWithActivityIndicatorStyle:style]) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}


- (void) touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event {
    if (delegate != nil) {
        UITouch* touch = touches.anyObject;
        if (touch.tapCount > 0) {
            [delegate imageView:self wasTapped:touch.tapCount];
        }
    }
}

@end
