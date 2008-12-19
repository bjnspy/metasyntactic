//
//  NetflixRatingsCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixRatingsCell.h"

#import "NetflixCache.h"
#import "NowPlayingModel.h"
#import "Movie.h"

@implementation NetflixRatingsCell


- (void)dealloc {
    [super dealloc];
}


- (id) initWithFrame:(CGRect) frame
               model:(NowPlayingModel*) model_
               movie:(Movie*) movie_ {
    if (self = [super initWithFrame:frame
                              model:model_
                              movie:movie_]) {
        CGFloat rating = [[model.netflixCache ratingForMovie:movie] floatValue];
        
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

            UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
            CGRect rect = imageView.frame;
            rect.origin.y = 10;
            NSInteger halfWayPoint = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? 230 : 150;
            
            rect.origin.x = (halfWayPoint - 110) + (40 * (i + 1));
            imageView.frame = rect;
            
            [self.contentView addSubview:imageView];
        }
    }
    
    return self;
}


- (void) layoutSubviews {
    [super layoutSubviews];    
}

@end
