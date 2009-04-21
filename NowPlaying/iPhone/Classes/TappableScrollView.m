// Copyright 2008 Cyrus Najmabadi
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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