//
//  NetflixRatingsCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixRatingsCell.h"

#import "AlertUtilities.h"
#import "ImageCache.h"
#import "NetflixCache.h"
#import "NowPlayingModel.h"
#import "Movie.h"
#import "TappableImageView.h"

@implementation NetflixRatingsCell


- (void)dealloc {
    [super dealloc];
}


- (void) setupNetflixRating {
    CGFloat rating = [[model.netflixCache netflixRatingForMovie:movie] floatValue];
    
    for (NSInteger i = -1; i < 5; i++) {
        UIImage* image;
        if (i == -1) {
            image = [UIImage imageNamed:@"ClearRating.png"];
        } else {
            CGFloat value = rating - i;
            if (value < 0.2) {
                image = [UIImage imageNamed:@"RedStar-0.0.png"];
            } else if (value < 0.4) {
                image = [UIImage imageNamed:@"RedStar-0.2.png"];
            } else if (value < 0.6) {
                image = [UIImage imageNamed:@"RedStar-0.4.png"];
            } else if (value < 0.8) {
                image = [UIImage imageNamed:@"RedStar-0.6.png"];
            } else if (value < 1) {
                image = [UIImage imageNamed:@"RedStar-0.8.png"];
            } else {
                image = [UIImage imageNamed:@"RedStar-1.0.png"];
            }
        }
        
        TappableImageView* imageView = [[[TappableImageView alloc] initWithImage:image] autorelease];
        imageView.delegate = self;
        imageView.tag = i + 1;
        
        CGRect rect = imageView.frame;
        rect.origin.y = 10;
        NSInteger halfWayPoint = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? 230 : 150;
        
        rect.origin.x = (halfWayPoint - 110) + (40 * (i + 1));
        imageView.frame = rect;
        
        [self.contentView addSubview:imageView];
    }
}


- (void) setupUserRating:(NSString*) userRating {
    CGFloat rating = [userRating floatValue];
    
    for (NSInteger i = -1; i < 5; i++) {
        UIImage* image;
        if (i == -1) {
            image = [UIImage imageNamed:@"ClearRating.png"];
        } else {
            CGFloat value = rating - i;
            if (value < 1) {
                image = [ImageCache emptyStarImage];
            } else {
                image = [ImageCache filledStarImage];
            }
        }
        
        TappableImageView* imageView = [[[TappableImageView alloc] initWithImage:image] autorelease];
        imageView.delegate = self;
        imageView.tag = i + 1;
        
        CGRect rect = imageView.frame;
        rect.origin.y = 10;
        NSInteger halfWayPoint = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? 230 : 150;
        
        rect.origin.x = (halfWayPoint - 110) + (40 * (i + 1));
        imageView.frame = rect;
        
        [self.contentView addSubview:imageView];
    }
}


- (void) setupRating {
    NSString* userRating = [model.netflixCache userRatingForMovie:movie];
    if (userRating.length > 0) {
        [self setupUserRating:userRating];
    } else {
        [self setupNetflixRating];
    }
}


- (id) initWithFrame:(CGRect) frame
               model:(NowPlayingModel*) model_
               movie:(Movie*) movie_ {
    if (self = [super initWithFrame:frame
                              model:model_
                              movie:movie_]) {
        [self setupRating];
    }

    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];
}


- (void) imageView:(TappableImageView*) imageView
         wasTapped:(NSInteger) tapCount {
    NSInteger value = imageView.tag;
    NSInteger currentUserRating = (NSInteger)[[model.netflixCache userRatingForMovie:movie] floatValue];
    
    if (value == currentUserRating) {
        return;
    }
    
    // change the UI:
    [self setupUserRating:(value == 0 ? @"" : [NSString stringWithFormat:@"%d", value])];
    
    // now, update in the background.
    NSString* rating = value == 0 ? @"no_opinion" : [NSString stringWithFormat:@"%d", value];
    [model.netflixCache changeRatingTo:rating forMovie:movie delegate:self];
}


- (void) changeSucceeded {
    
}


- (void) changeFailedWithError:(NSString*) error {
    NSString* message = [NSString stringWithFormat:NSLocalizedString(@"Could not change rating:\n\n%@", nil), error];
    [AlertUtilities showOkAlert:message];
    
    [self setupRating];
}

@end
