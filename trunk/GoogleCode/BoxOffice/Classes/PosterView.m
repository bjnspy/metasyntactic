// Copyright (c) 2008, Cyrus Najmabadi
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//   Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
//   Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
//   Neither the name 'Cyrus Najmabadi' nor the names of its contributors may be
//   used to endorse or promote products derived from this software without
//   specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#import "PosterView.h"

#import "AllMoviesViewController.h"
#import "BoxOfficeModel.h"

@implementation PosterView

@synthesize controller;
@synthesize moviesWithPosters;

- (void) dealloc {
    self.controller = nil;
    self.moviesWithPosters = nil;
    [super dealloc];
}


- (id) initWithController:(AllMoviesViewController*) controller_ {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.controller = controller_;
        self.backgroundColor = [UIColor blackColor];
    }

    return self;
}


+ (PosterView*) viewWithController:(AllMoviesViewController*) controller {
    return [[[PosterView alloc] initWithController:controller] autorelease];
}


- (BoxOfficeModel*) model {
    return [controller model];
}


- (void) showPoster:(NSNumber*) number {
    const double pi = 3.14159265358979323846;

    int index = [number intValue];

    int row = index % 2;
    int column = index / 2;

    Movie* movie = [moviesWithPosters objectAtIndex:index];
    UIImage* poster = [self.model posterForMovie:movie];

    UIImageView* imageView = [[[UIImageView alloc] initWithImage:poster] autorelease];

    float rotation;
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        rotation = pi / 2;
    } else {
        rotation = -pi / 2;
    }

    CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
    imageView.transform = transform;

    CGRect originalBounds = imageView.bounds;
    if (row == 0) {
        imageView.center = CGPointMake(240 - 10, 60 + column * 120);
    } else {
        imageView.center = CGPointMake(80 - 5, 60 + column * 120);
    }

    imageView.bounds = CGRectMake(0, 0, 0, 0);
    imageView.alpha = 0;

    [UIView beginAnimations:nil context:imageView];
    {
        NSTimeInterval duration = [[UIApplication sharedApplication] statusBarOrientationAnimationDuration];
        double baseDelay = (column * duration) / 2;

        [UIView setAnimationDuration:duration];

        if ((index % 2) == 0) {
            [UIView setAnimationDelay:baseDelay];
        } else {
            [UIView setAnimationDelay:baseDelay + duration];
        }

        imageView.bounds = originalBounds;
        imageView.alpha = 1;
    }
    [UIView commitAnimations];

    [self addSubview:imageView];
}


- (void) layoutSubviews {
    [super layoutSubviews];

    NSArray* movies = [self.model movies];
    moviesWithPosters = [NSMutableArray array];

    for (Movie* movie in movies) {
        UIImage* image = [self.model posterForMovie:movie];
        if (image != nil) {
            [moviesWithPosters addObject:movie];
        }
    }

    for (int i = 0; i < 10 && i < moviesWithPosters.count; i++) {
        [self showPoster:[NSNumber numberWithInt:i]];
    }
}


@end
