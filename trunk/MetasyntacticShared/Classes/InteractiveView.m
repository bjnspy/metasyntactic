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

#import "InteractiveView.h"

#import "NSArray+Utilities.h"

@implementation InteractiveView

@synthesize tapDelegate;
@synthesize touchDelegate;
@synthesize pinchDelegate;

- (void) dealloc {
  self.tapDelegate = nil;
  self.touchDelegate = nil;
  self.pinchDelegate = nil;
  [super dealloc];
}


- (id) initWithFrame:(CGRect) frame {
  if ((self = [super initWithFrame:frame])) {
    self.multipleTouchEnabled = YES;
  }

  return self;
}

#define SWIPE_DRAG_MIN    20

- (void) initializeSwipe:(NSSet*) touches {
  NSLog(@"Initializing swipe");
  pinching = NO;
  UITouch* touch = [touches anyObject];
  startSwipePosition = [touch locationInView:self];
  previousTouchPosition = startSwipePosition;
}


- (void) initializePinch:(NSSet*) touches
                   event:(UIEvent*) event {
  pinching = YES;
  NSArray* touchesArray = event.allTouches.allObjects;
  UITouch* touch1 = touchesArray.firstObject;
  UITouch* touch2 = touchesArray.firstObject;

  CGPoint point1 = [touch1 locationInView:self];
  CGPoint point2 = [touch2 locationInView:self];

  previousPinchUpperLeftPosition = CGPointMake(MIN(point1.x, point2.x), MIN(point1.y, point2.y));
  previousPinchLowerRightPosition = CGPointMake(MAX(point1.x, point2.x), MAX(point1.y, point2.y));

  if (pinchDelegate != nil) {
    [pinchDelegate view:self pinchStarted:previousPinchUpperLeftPosition
         fromLowerRight:previousPinchLowerRightPosition];
  }
}


- (void) touchesBegan:(NSSet*) touches
            withEvent:(UIEvent*) event {
  [super touchesBegan:touches withEvent:event];
  NSLog(@"Touches began");

  if (pinching) {
    return;
  }

  NSSet* allTouches = event.allTouches;

  if (allTouches.count == 1) {
    [self initializeSwipe:touches];
  } else if (allTouches.count == 2) {
    [self initializePinch:touches event:event];
  }
}


- (void) handleTouch:(NSSet*) touches {
  UITouch* touch = [touches anyObject];
  CGPoint currentTouchPosition = [touch locationInView:self];

  NSInteger xDelta = ABS(startSwipePosition.x - currentTouchPosition.x);
  NSInteger yDelta = ABS(startSwipePosition.y - currentTouchPosition.y);
  if (xDelta > SWIPE_DRAG_MIN || yDelta > SWIPE_DRAG_MIN) {
    // we're swiping in at least one direction.
    if (xDelta > yDelta) {
      if ((2 * yDelta) < xDelta) {
        if (startSwipePosition.x < currentTouchPosition.x) {
          [touchDelegate viewReceviedLeftToRightSwipe:self];
        } else {
          [touchDelegate viewReceviedRightToLeftSwipe:self];
        }
      }
    } else {
      if ((2 * xDelta) < yDelta) {
        if (startSwipePosition.y < currentTouchPosition.y) {
          [touchDelegate viewReceviedTopToBottomSwipe:self];
        } else {
          [touchDelegate viewReceviedBottomToTopSwipe:self];
        }
      }
    }
  }

  CGPoint previous = previousTouchPosition;
  previousTouchPosition = currentTouchPosition;
  [touchDelegate view:self receviedTouchFrom:previous to:currentTouchPosition];
}


- (void) handlePinch:(NSSet*) touches
               event:(UIEvent*) event {
  NSArray* touchesArray = event.allTouches.allObjects;
  UITouch* touch1 = [touchesArray objectAtIndex:0];
  UITouch* touch2 = [touchesArray objectAtIndex:1];

  CGPoint endPoint1 = [touch1 locationInView:self];
  CGPoint endPoint2 = [touch2 locationInView:self];

  CGPoint startUpperLeft = previousPinchUpperLeftPosition;
  CGPoint startLowerRight = previousPinchLowerRightPosition;
  CGPoint endUpperLeft = CGPointMake(MIN(endPoint1.x, endPoint2.x), MIN(endPoint1.y, endPoint2.y));
  CGPoint endLowerRight = CGPointMake(MAX(endPoint1.x, endPoint2.x), MAX(endPoint1.y, endPoint2.y));

  previousPinchUpperLeftPosition = endUpperLeft;
  previousPinchLowerRightPosition = endLowerRight;

  [pinchDelegate view:self
           wasPinched:startUpperLeft
       fromLowerRight:startLowerRight
                   to:endUpperLeft
                   to:endLowerRight];
}


- (void) touchesMoved:(NSSet*) touches
            withEvent:(UIEvent*) event {
  [super touchesMoved:touches withEvent:event];

  NSSet* allTouches = event.allTouches;
  if (!pinching && allTouches.count == 1) {
    [self handleTouch:touches];
  } else if (allTouches.count == 2) {
    if (pinching) {
      [self handlePinch:touches event:event];
    } else {
      [self initializePinch:touches event:event];
    }
  }
}


- (void) touchesEnded:(NSSet*) touches
            withEvent:(UIEvent*) event {
  [super touchesEnded:touches withEvent:event];
  NSLog(@"Touches ended");

  pinching = NO;

  UITouch* touch = touches.anyObject;
  if (touch.tapCount > 0) {
    [tapDelegate view:self wasTouched:touch tapCount:touch.tapCount];
  }
}


- (void) touchesCancelled:(NSSet*) touches
                withEvent:(UIEvent*) event {
  [super touchesCancelled:touches withEvent:event];
  pinching = NO;
}

@end
