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

#import "LargeActivityIndicatorViewWithBackground.h"

#import "MetasyntacticStockImages.h"

@interface LargeActivityIndicatorViewWithBackground()
@property (retain) UIImageView* backgroundView;
@property (retain) UIActivityIndicatorView* activityIndicator;
@end


@implementation LargeActivityIndicatorViewWithBackground

@synthesize backgroundView;
@synthesize activityIndicator;

- (void) dealloc {
  self.backgroundView = nil;
  self.activityIndicator = nil;

  [super dealloc];
}


- (id) init {
  if ((self = [super init])) {
    UIImage* image = [MetasyntacticStockImages largeActivityBackground];
    self.backgroundView = [[[UIImageView alloc] initWithImage:image] autorelease];
    self.frame = backgroundView.frame;

    self.activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    activityIndicator.hidesWhenStopped = YES;

    CGRect frame = activityIndicator.frame;
    frame.origin.x = frame.origin.y = 4;
    activityIndicator.frame = frame;

    [self addSubview:backgroundView];
    [self addSubview:activityIndicator];

    [self sendSubviewToBack:backgroundView];
  }

  return self;
}


- (void) stopAnimating {
  [UIView beginAnimations:nil context:NULL];
  {
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onStopAnimatingCompleted:finished:context:)];

    activityIndicator.alpha = 0;
    backgroundView.alpha = 0;
  }
  [UIView commitAnimations];
}


- (void) onStopAnimatingCompleted:(NSString*) animationId
                         finished:(BOOL) finished
                          context:(void*) context {
  [activityIndicator stopAnimating];
}


- (void) startAnimating {
  backgroundView.alpha = 0;
  activityIndicator.alpha = 0;

  [activityIndicator startAnimating];

  [UIView beginAnimations:nil context:NULL];
  {
    backgroundView.alpha = 0.75f;
    activityIndicator.alpha = 1.f;
  }
  [UIView commitAnimations];
}

@end
