//
//  TappableLabel.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TappableLabel.h"

#import "TappableLabelDelegate.h"

@implementation TappableLabel

@synthesize delegate;

- (void) dealloc {
    self.delegate = nil;

    [super dealloc];
}

- (id) init {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}


- (void) touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event {
    if (delegate != nil) {
        UITouch* touch = touches.anyObject;
        if (touch.tapCount > 0) {
            [delegate label:self wasTapped:touch.tapCount];
        }
    }
}


- (UIView*) hitTest:(CGPoint) point
          withEvent:(UIEvent*) event {
    return self;
}

@end