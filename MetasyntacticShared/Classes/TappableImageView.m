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

#import "TappableImageView.h"

#import "TappableImageViewDelegate.h"

@implementation TappableImageView

@synthesize delegate;

- (void) dealloc {
  self.delegate = nil;

  [super dealloc];
}

- (id) initWithImage:(UIImage*) image {
  if ((self = [super initWithImage:image])) {
    self.userInteractionEnabled = YES;
  }

  return self;
}


- (void) touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event {
  if (delegate != nil) {
    UITouch* touch = touches.anyObject;
    if (touch.tapCount > 0) {
      [delegate imageView:self wasTouched:touch tapCount:touch.tapCount];
    }
  }
}


@end
