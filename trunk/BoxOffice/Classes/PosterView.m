//
//  PosterView.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "PosterView.h"
#import "AllMoviesViewController.h"

@implementation PosterView

@synthesize controller;

- (void) dealloc {
    controller = nil;
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

- (void) layoutSubviews {
    //NSNumber* number = [NSNumber numberWithInt:0];
    //NSNumber* number = [NSNumber numberWithInt:1];
    
    //[self performSelector:@selector(showPoster:) withObject:number];
    
    for (int i = 0; i < 10; i++) {
        [self showPoster:[NSNumber numberWithInt:i]];
    }
}

- (void) showPoster:(NSNumber*) number {
    const double pi = 3.14159265358979323846;
    
    int index = [number intValue];
    
    BoxOfficeModel* model = [self model];
    NSArray* movies = model.movies;
    
    if (index >= [movies count] || index > 8) {
        return;
    }
    
    int row = index % 2;
    int column = index / 2;
    
    Movie* movie = [movies objectAtIndex:index];
    UIImage* poster = [model posterForMovie:movie];
    
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:poster] autorelease];
    CGRect rect = imageView.frame;
    
    float rotation;
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        rotation = pi / 2;
    } else {
        rotation = -pi / 2;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(rotation);
    imageView.transform = transform;
    imageView.center = 
    CGPointMake(row == 0 ? 240 : 80, 60 + column * 120);
        //CGPointMake(60 + column * 120, row == 0 ? 240 : 80);
    
    CGRect bounds = imageView.bounds;
    double dx = bounds.size.width / 20;
    double dy = bounds.size.height / 20;
    CGRect largeBounds = CGRectMake(bounds.origin.x - dx, bounds.origin.y - dy,
                                    bounds.size.width + 2 * dx, bounds.size.height + 2 * dy);

    imageView.bounds = CGRectMake(0, 0, 0, 0);
    imageView.alpha = 0;
        
    [UIView beginAnimations:nil context:imageView];
    {
//        [UIView setAnimationDelegate:self];
  //      [UIView setAnimationDidStopSelector:@selector(decreaseImageViewSize:)];
        
        NSTimeInterval duration = [[UIApplication sharedApplication] statusBarOrientationAnimationDuration];
        double baseDelay = (column * duration) / 2;

        [UIView setAnimationDuration:duration];
        
        if ((index % 2) == 0) {  
            [UIView setAnimationDelay:baseDelay];
        } else {
            [UIView setAnimationDelay:baseDelay + duration];
        }
        
        //imageView.bounds = largeBounds;
        //imageView.alpha = 0.5;
        imageView.bounds = bounds;
        imageView.alpha = 1;
    }
    [UIView commitAnimations];
    
    [self addSubview:imageView];
}

- (void) decreaseImageViewSize:(NSString*) animationID
                      finished:(NSNumber*) finished
                       context:(void*) context {
    //return;
    NSTimeInterval duration = [[UIApplication sharedApplication] statusBarOrientationAnimationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    {
        [UIView setAnimationDuration:duration];
        
        //imageView.bounds = bounds;
        //imageView.alpha = 1;
    }
    [UIView commitAnimations];   
}

@end
