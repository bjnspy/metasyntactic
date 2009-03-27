//
//  YellowMovieTitleCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "YellowMovieTitleCell.h"

#import "ColorCache.h"
#import "FontCache.h"
#import "ImageCache.h"

@implementation YellowMovieTitleCell


+ (NSString*) reuseIdentifier {
    return @"YellowMovieTitleCell";
}

- (id) init {
    if (self = [super initWithReuseIdentifier:[[self class] reuseIdentifier]]) {
        self.image = [ImageCache yellowRatingImage];
    }
    
    return self;
}

@end
