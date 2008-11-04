//
//  TappableImageView.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TappableImageView.h"

#import "TappableImageViewDelegate.h"

@implementation TappableImageView

@synthesize tapDelegate;

- (void) dealloc {
    self.tapDelegate = nil;
    
    [super dealloc];
}


- (id) initWithImage:(UIImage*) image {
    if (self = [super initWithImage:image]) {
        self.userInteractionEnabled = YES;
    }
    
    return self;
}


- (void) touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event {
    if (tapDelegate != nil) {
        UITouch* touch = touches.anyObject;
        if (touch.tapCount > 0) {
            [tapDelegate imageView:self wasTapped:touch.tapCount];
        }
    }
}

@end