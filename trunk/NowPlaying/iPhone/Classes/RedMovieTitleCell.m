//
//  RedMovieTitleCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RedMovieTitleCell.h"

#import "ColorCache.h"
#import "FontCache.h"
#import "ImageCache.h"

@implementation RedMovieTitleCell


+ (NSString*) reuseIdentifier {
    return @"RedMovieTitleCell";
}

- (id) init {
    if (self = [super initWithReuseIdentifier:[[self class] reuseIdentifier]]) {
        self.image = [ImageCache redRatingImage];
    }

    return self;
}

@end
