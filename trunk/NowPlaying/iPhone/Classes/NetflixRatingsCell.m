//
//  NetflixRatingsCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 12/18/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NetflixRatingsCell.h"

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
        
        NSString* rating = [movie.additionalFields objectForKey:@"average_rating"];
        CGFloat value = [rating floatValue];
        
        NSInteger fullStarsMax = (NSInteger)value;
        NSInteger emptyStarsMin = fullStarsMax + 1;
        
        value = MAX(MIN(5, value), 0);
        for (NSInteger i = 0; i < 5; i++) {
            UIImage* image;
            if (i < fullStarsMax) {
                image = [UIImage imageNamed:@"RedStar-1.0.png"];
            } else if (i >= emptyStarsMin) {
                image = [UIImage imageNamed:@"RedStar-0.0.png"];
            } else {
                CGFloat partial = value - fullStarsMax;
                if (partial < 0.2) {
                    image = [UIImage imageNamed:@"RedStar-0.0.png"];
                } else if (partial < 0.4) {
                    image = [UIImage imageNamed:@"RedStar-0.2.png"];
                } else if (partial < 0.6) {
                    image = [UIImage imageNamed:@"RedStar-0.4.png"];
                } else if (partial < 0.8) {
                    image = [UIImage imageNamed:@"RedStar-0.6.png"];
                } else if (partial < 1.0) {
                    image = [UIImage imageNamed:@"RedStar-0.8.png"];
                } else {
                    image = [UIImage imageNamed:@"RedStar-1.0.png"];
                }
            }

            UIImageView* imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
            CGRect rect = imageView.frame;
            rect.origin.y = 10;
            rect.origin.x = 60 + 40 * i;
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
