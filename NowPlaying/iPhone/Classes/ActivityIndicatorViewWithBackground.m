//
//  ActivityViewWithBackground.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 11/7/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

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
