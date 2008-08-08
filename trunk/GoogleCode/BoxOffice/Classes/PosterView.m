// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

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
