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

#import "TappableImageView.h"

#import "TappableImageViewDelegate.h"

@implementation TappableImageView

@synthesize delegate;

- (void) dealloc {
    self.delegate = nil;

    [super dealloc];
}

- (id) initWithImage:(UIImage*) image {
    if (self = [super initWithImage:image]) {
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