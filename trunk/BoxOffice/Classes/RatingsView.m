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

        CGRect labelRectangle;
        if (rating >= 60) {
            labelRectangle = CGRectMake(ratingsRectangle.origin.x, ratingsRectangle.origin.y + 2,
                                        ratingsRectangle.size.width, ratingsRectangle.size.height);
        } else {
            labelRectangle = CGRectMake(ratingsRectangle.origin.x - 2, ratingsRectangle.origin.y + 1,
                                        ratingsRectangle.size.width, ratingsRectangle.size.height);
        }
        
        UILabel* label = [[[UILabel alloc] initWithFrame:labelRectangle] autorelease];        label.text = [NSString stringWithFormat:@"%d", rating];
        label.opaque = NO;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        
        if (rating >= 60) {
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textColor = [UIColor whiteColor];
            
            [ratingsImage drawInRect:ratingsRectangle blendMode:kCGBlendModeNormal alpha:1];
        } else {
            label.font = [UIFont boldSystemFontOfSize:16];
            [ratingsImage drawInRect:ratingsRectangle blendMode:kCGBlendModeNormal alpha:0.5];
        }

        [label drawTextInRect:labelRectangle];
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
