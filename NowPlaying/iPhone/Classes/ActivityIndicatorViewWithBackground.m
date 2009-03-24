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

@interface ActivityIndicatorViewWithBackground()
@property (retain) UIImageView* imageView_;
@property (retain) UIActivityIndicatorView* activityIndicator_;
@end


@implementation ActivityIndicatorViewWithBackground

@synthesize imageView_;
@synthesize activityIndicator_;

property_wrapper(UIImageView*, imageView, ImageView);
property_wrapper(UIActivityIndicatorView*, activityIndicator, ActivityIndicator);

- (void) dealloc {
    self.imageView = nil;
    self.activityIndicator = nil;

    [super dealloc];
}


- (id) init {
    if (self = [super init]) {
        UIImage* image = [UIImage imageNamed:@"BlackCircle.png"];
        self.imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
        self.frame = self.imageView.frame;

        self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
        self.activityIndicator.hidesWhenStopped = YES;

        CGRect frame = self.activityIndicator.frame;
        frame.origin.x = frame.origin.y = 4;
        self.activityIndicator.frame = frame;

        [self addSubview:self.imageView];
        [self addSubview:self.activityIndicator];

        [self sendSubviewToBack:self.imageView];
    }

    return self;
}


- (void) stopAnimating {
    [UIView beginAnimations:nil context:NULL];
    {
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(onStopAnimatingCompleted:finished:context:)];

        self.activityIndicator.alpha = 0;
        self.imageView.alpha = 0;
    }
    [UIView commitAnimations];
}


- (void) onStopAnimatingCompleted:(NSString*) animationId
                         finished:(BOOL) finished
                          context:(void*) context {
    [self.activityIndicator stopAnimating];
}


- (void) startAnimating {
    self.imageView.alpha = 0;
    self.activityIndicator.alpha = 0;

    [self.activityIndicator startAnimating];

    [UIView beginAnimations:nil context:NULL];
    {
        self.imageView.alpha = 0.75;
        self.activityIndicator.alpha = 1;
    }
    [UIView commitAnimations];
}

@end