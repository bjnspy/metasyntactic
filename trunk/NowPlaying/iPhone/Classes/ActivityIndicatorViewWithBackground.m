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

#import "ActivityIndicatorViewWithBackground.h"

@implementation ActivityIndicatorViewWithBackground

@synthesize imageView;
@synthesize activityIndicator;

- (void) dealloc {
    self.imageView = nil;
    self.activityIndicator = nil;

    [super dealloc];
}

- (id) init {
    if (self = [super init]) {
        UIImage* image = [UIImage imageNamed:@"BlackCircle.png"];
        self.imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        self.frame = imageView.frame;
        imageView.alpha = 0.75;

        self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        CGRect frame = activityIndicator.frame;
        frame.origin.x = frame.origin.y = 4;
        activityIndicator.frame = frame;

        [self addSubview:imageView];
        [self addSubview:activityIndicator];

        [self sendSubviewToBack:imageView];
    }

    return self;
}

- (void) stopAnimating {
    [activityIndicator stopAnimating];

    [UIView beginAnimations:nil context:NULL];
    {
        imageView.alpha = 0;
    }
    [UIView commitAnimations];
}

@end