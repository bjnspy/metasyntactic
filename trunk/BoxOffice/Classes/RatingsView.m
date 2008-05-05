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
        //rating = 100;
    }
    
    return self;
}

- (void) drawRect:(CGRect) rect
{
    // get the image that represents the element physical state and draw it
    UIImage* ratingsImage = [UIImage imageNamed:(rating >= 60 ? @"Fresh.png" : @"Rotten.png")];
    CGRect ratingsRectangle = CGRectMake(5, 0, [ratingsImage size].width, [ratingsImage size].height);
    [ratingsImage drawInRect:ratingsRectangle blendMode:kCGBlendModeNormal alpha:0.3];
    
    UIFont* boldLargefont = [UIFont boldSystemFontOfSize:16];
    UIFont* boldSmallfont = [UIFont boldSystemFontOfSize:10];
    
    NSString* ratingString = [NSString stringWithFormat:@"%d", rating];
    NSString* percentString = @"%";
    
    CGSize ratingStringSize = [ratingString sizeWithFont:boldLargefont];
    CGSize percentStringSize = [ratingString sizeWithFont:boldSmallfont];
    
    int x = (rect.size.width - (ratingStringSize.width + percentStringSize.width)) / 2;
    x++;
    
    CGPoint point1 = CGPointMake(x, 6);
    [ratingString drawAtPoint:point1 withFont:boldLargefont];
    
    CGPoint point2 = CGPointMake(point1.x + ratingStringSize.width, 10);
    [percentString drawAtPoint:point2 withFont:boldSmallfont];
}

@end
