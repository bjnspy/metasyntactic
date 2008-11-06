//
//  TappableScrollView.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "TappableScrollView.h"

#import "TappableScrollViewDelegate.h"

@implementation TappableScrollView

@synthesize tapDelegate;

- (void) dealloc {
    self.tapDelegate = nil;
    
    [super dealloc];
}


- (void) touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event {
    UITouch* touch = touches.anyObject;
    if (touch.tapCount > 0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        CGPoint point = [touch locationInView:self];
        NSValue* pointValue = [NSValue valueWithCGPoint:point];
        NSNumber* tapCount = [NSNumber numberWithInt:touch.tapCount];
        
        [self performSelector:@selector(reportTap:)
                   withObject:[NSArray arrayWithObjects:pointValue, tapCount, nil]
                   afterDelay:0.25];
        return;
    }
    
    [super touchesEnded:touches withEvent:event];
}


- (void) reportTap:(NSArray*) pointAndCount {
    CGPoint point = [[pointAndCount objectAtIndex:0] CGPointValue];
    NSInteger tapCount = [[pointAndCount objectAtIndex:1] intValue];
    
    [tapDelegate scrollView:self wasTapped:tapCount atPoint:point];
}

@end