//
//  TomatoMovieTitleCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TomatoMovieTitleCell.h"

#import "ImageCache.h"


@implementation TomatoMovieTitleCell


+ (NSString*) reuseIdentifier {
    return @"TomatoMovieTitleCell";
}

- (id) init {
    if (self = [super initWithReuseIdentifier:[[self class] reuseIdentifier]]) {
        self.image = [ImageCache freshImage];
        
        scoreLabel.font = [UIFont boldSystemFontOfSize:15];
        scoreLabel.textColor = [UIColor whiteColor];
        
#ifdef IPHONE_OS_VERSION_3
        CGRect frame = CGRectMake(5, 7, 32, 32);
#else
        CGRect frame = CGRectMake(10, 8, 32, 32);  
#endif

        scoreLabel.frame = frame;
    }
    
    return self;
}

@end
