// Copyright 2010 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
    NSValue* pointegerValue = [NSValue valueWithCGPoint:point];
    NSNumber* tapCount = [NSNumber numberWithInteger:touch.tapCount];

    [self performSelector:@selector(reportTap:)
               withObject:[NSArray arrayWithObjects:pointegerValue, tapCount, nil]
               afterDelay:0.4];
    return;
  }

  [super touchesEnded:touches withEvent:event];
}


- (void) reportTap:(NSArray*) pointAndCount {
  CGPoint point = [[pointAndCount objectAtIndex:0] CGPointValue];
  NSInteger tapCount = [[pointAndCount objectAtIndex:1] integerValue];

  [tapDelegate scrollView:self wasTapped:tapCount atPoint:point];
}

@end
