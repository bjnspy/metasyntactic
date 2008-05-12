//
//  RatingsView.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 5/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "RatingsView.h"


@implementation RatingsView

- (id) initWithFrame:(CGRect) frame
              rating:(NSInteger) rating_
{
    if (self = [super initWithFrame:frame])
    {
        rating = rating_;
    }
    
    return self;
}

- (void) drawRect:(CGRect) rect
{
    UIFont* boldLargefont = [UIFont boldSystemFontOfSize:16];
    
    if (rating >= 0 && rating <= 100)
    {
        UIImage* ratingsImage = [UIImage imageNamed:(rating >= 60 ? @"Fresh.png" : @"Rotten.png")];
        CGRect ratingsRectangle = CGRectMake(5, 0, [ratingsImage size].width, [ratingsImage size].height);
		
		if (rating >= 60) {
			[ratingsImage drawInRect:ratingsRectangle blendMode:kCGBlendModeNormal alpha:0.7];
        } else {
			[ratingsImage drawInRect:ratingsRectangle blendMode:kCGBlendModeNormal alpha:0.5];
		}
		
        UIFont* boldSmallfont = [UIFont boldSystemFontOfSize:10];
        
        NSString* ratingString = [NSString stringWithFormat:@"%d", rating];
        NSString* percentString = @"%";
        
        CGSize ratingStringSize = [ratingString sizeWithFont:boldLargefont];
        CGSize percentStringSize = [ratingString sizeWithFont:boldSmallfont];
        
        int x = ((rect.size.width - (ratingStringSize.width + percentStringSize.width)) / 2) + 1;
        
		if (rating == 100) {
			x += 1;
		} else if (rating < 10) {
			x -= 2;
		}
		
        CGPoint point1 = CGPointMake(x, 6);
        [ratingString drawAtPoint:point1 withFont:boldLargefont];
        
        CGPoint point2 = CGPointMake(point1.x + ratingStringSize.width, 10);
        [percentString drawAtPoint:point2 withFont:boldSmallfont];
    }
    else
    {
        NSString* str = @"N/A";
        CGSize strSize = [str sizeWithFont:boldLargefont];
        
        int x = (rect.size.width - strSize.width) / 2;
        CGPoint point1 = CGPointMake(x, 6);
        [str drawAtPoint:point1 withFont:boldLargefont];
    }
}

@end
