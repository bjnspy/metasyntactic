//
//  GreenMovieTitleCell.m
//  NowPlaying
//
//  Created by Cyrus Najmabadi on 3/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GreenMovieTitleCell.h"

#import "ColorCache.h"
#import "FontCache.h"
#import "ImageCache.h"

@implementation GreenMovieTitleCell


+ (NSString*) reuseIdentifier {
    return @"GreenMovieTitleCell";
}

- (id) init {
    if (self = [super initWithReuseIdentifier:[[self class] reuseIdentifier]]) {
        self.image = [ImageCache greenRatingImage];
    }
    
    return self;
}

@end
