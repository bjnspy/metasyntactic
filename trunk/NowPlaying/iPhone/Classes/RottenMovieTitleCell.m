//
//  RottenMovieTitleCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RottenMovieTitleCell.h"

#import "ImageCache.h"

@implementation RottenMovieTitleCell

+ (NSString*) reuseIdentifier {
    return @"RottenMovieTitleCell";
}


- (id) init {
    if (self = [super initWithReuseIdentifier:[[self class] reuseIdentifier]]) {
        self.image = [ImageCache rottenFadedImage];
        
        scoreLabel.font = [UIFont boldSystemFontOfSize:17];
        scoreLabel.textColor = [UIColor blackColor];
      
#ifdef IPHONE_OS_VERSION_3
        CGRect frame = CGRectMake(5, 5, 30, 32);
#else
        CGRect frame = CGRectMake(10, 6, 30, 32);
#endif
        
        scoreLabel.frame = frame;
    }
    
    return self;
}

@end
